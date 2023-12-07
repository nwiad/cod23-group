/* 维护一个采用直接映射的BTB                   */
/* 根据ID段的信息将指令传给IF                  */
/* 因为涉及到寄存器的读/写（BLT），所以需要时序 */


`default_nettype none

module branch_predictor (
  input wire clk_i,
  input wire rst_i,
  input wire [31:0] ID_pc_i,
  input wire ID_is_branch_i,
  input wire [31:0] IF_pc_i,  /* IF段这个周期本来要读的pc */

  input wire [31:0] EXE_pc_i, 
  input wire EXE_is_branch_i,
  input wire EXE_need_branch_i,
  input wire [31:0] EXE_pc_result_i,

  input wire ID_is_bubble_i,

  output reg [31:0] IF_pc_o,
  output reg IF_take_predict_o
);

  typedef enum logic [1:0] { 
    STATE_TAKEN = 0,      /* 上一次预测成功 */
    STATE_NOT_TAKEN = 1   /* 上一次预测失败 */
  } state_t;

  reg btb_valid [0:63];
  reg [25:0] btb_tag [0:63];
  reg [31:0] btb_pc [0:63];
  reg [1:0] btb_state [0:63];

  logic [5:0] ID_index_comb;
  logic [25:0] ID_tag_comb;
  logic [5:0] EXE_index_comb;
  logic [25:0] EXE_tag_comb;
  logic hit;

  logic [31:0] IF_pc_o_reg;
  logic hit_reg;

  always_comb begin
    ID_index_comb = ID_pc_i[5:0];
    ID_tag_comb = ID_pc_i[31:6];
    EXE_index_comb = EXE_pc_i[5:0];
    EXE_tag_comb = EXE_pc_i[31:6];
    if (ID_is_bubble_i) begin
      hit = hit_reg;
    end else begin
      hit = btb_valid[ID_index_comb] && (btb_tag[ID_index_comb] == ID_tag_comb) && ID_is_branch_i && btb_state[ID_index_comb] == STATE_TAKEN;
    end
    if (hit) begin
      /* 只有上一状态为接受时，才采取分支预测 */
      if (ID_is_bubble_i) begin
        IF_pc_o = IF_pc_o_reg;
      end else begin
        IF_pc_o = btb_pc[ID_index_comb];
      end
    end else begin
      IF_pc_o = 32'h0000_0000;
    end
    IF_take_predict_o = hit;  // test
  end

  always_ff@ (posedge clk_i) begin
    if (rst_i) begin
      hit_reg <= 1'b0;
      IF_pc_o_reg <= 32'h0000_0000;
    end else begin
      hit_reg <= hit;
      IF_pc_o_reg <= IF_pc_o;
    end
  end

  always_ff@ (posedge clk_i) begin
    if (rst_i) begin
      for (int i = 0; i < 64; i = i + 1) begin
        btb_pc[i] <= 32'h0000_0000;
        btb_valid[i] <= 1'b0;
        btb_tag[i] <= 26'h0000_0000;
        btb_state[i] <= STATE_NOT_TAKEN;
      end
    end else begin
      if (EXE_is_branch_i) begin
        if (btb_tag[EXE_index_comb] == EXE_tag_comb) begin
          /* 当前存的就是现在EXE传递进来的指令 */
          // TODO: 用拥有四个状态的状态机来实现
          btb_pc[EXE_index_comb] <= EXE_pc_result_i;
          btb_valid[EXE_index_comb] <= 1'b1;
          btb_state[EXE_index_comb] <= EXE_need_branch_i ? STATE_TAKEN : STATE_NOT_TAKEN;
        end else begin
          btb_pc[EXE_index_comb] <= EXE_pc_result_i;
          btb_valid[EXE_index_comb] <= 1'b1;
          // btb_tag[EXE_index_comb] <= EXE_tag_comb;
          btb_state[EXE_index_comb] <= EXE_need_branch_i ? STATE_TAKEN : STATE_NOT_TAKEN;
        end
        btb_tag[EXE_index_comb] <= EXE_tag_comb;
      end
    end
  end



endmodule