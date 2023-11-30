`default_nettype none

module if_controller #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
) (
    input wire clk_i,
    input wire rst_i,

    input wire stall_i,
    input wire bubble_i,

    output reg stall_o,
    output reg flush_o,

    // wishbone master
    output reg wb_cyc_o,
    output reg wb_stb_o,
    input wire wb_ack_i,
    output reg [ADDR_WIDTH-1:0] wb_adr_o,
    output reg [DATA_WIDTH-1:0] wb_dat_o,
    input wire [DATA_WIDTH-1:0] wb_dat_i,
    output reg [DATA_WIDTH/8-1:0] wb_sel_o,
    output reg wb_we_o,

    // EXE -> IF
    input wire pc_src_i,
    input wire [31:0] pc_result_i,

    // IF -> ID
    output reg [31:0] inst_o,
    output reg [31:0] pc_now_o,

    output reg [4:0] rs1_o,
    output reg [4:0] rs2_o
);
  // reg [31:0] pc_reg;
  // outputs are bounded to these regs
  reg [31:0] inst_reg;
  reg [31:0] pc_now_reg;

  // states of wishbone request
  typedef enum logic [2:0] { 
    STATE_READY = 0,
    STATE_PENDING = 1
  } state_t;
  state_t state;

  // pc mux
  logic [31:0] pc_plus_4_comb;
  logic [31:0] pc_next_comb;
  always_comb begin
    // pc_plus_4_comb = pc_reg + 32'h0000_0004;
    pc_plus_4_comb = pc_now_reg + 32'h0000_0004;
    pc_next_comb = (pc_src_i == 1'b1) ? pc_result_i : pc_plus_4_comb;
  end

  always_comb begin
    stall_o = 1'b0;
    flush_o = 1'b0;  // IF段不会发出flush请求
    wb_cyc_o = 1'b0;
    wb_stb_o = 1'b0;
    wb_adr_o = 32'h0000_0000;
    wb_dat_o = 32'h0000_0000;
    wb_sel_o = 4'b0000;
    wb_we_o = 1'b0;
    case (state)
      STATE_READY: begin
        stall_o = 1'b0;
        wb_cyc_o = 1'b0;
        wb_stb_o = 1'b0;
      end
      STATE_PENDING: begin
        stall_o = 1'b1;
        wb_cyc_o = 1'b1;
        wb_stb_o = 1'b1;
        // wb_adr_o = pc_reg;
        wb_adr_o = pc_next_comb;
        wb_dat_o = 32'h0000_0000;
        wb_sel_o = 4'b1111;
        wb_we_o = 1'b0;
      end
      default: ;
    endcase
  end

  always_comb begin
    inst_o = inst_reg;
    pc_now_o = pc_now_reg;
    rs1_o = inst_reg[19:15];
    rs2_o = inst_reg[24:20];
  end

  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      state <= STATE_READY;
      // pc_reg <= 32'h8000_0000;
      // pc_now_reg <= 32'h8000_0000;
      pc_now_reg <= 32'h7FFF_FFFC;
      inst_reg <= 32'h0000_0000;
    end else if (stall_i) begin
      // do nothing
    end else if (bubble_i) begin // insert bubble while waiting for bus response
      inst_reg <= 32'h0000_0013;
      if (state == STATE_READY) begin
        state <= STATE_PENDING;
      end
    end else begin
      case (state)
        STATE_READY: begin
          state <= STATE_PENDING;
        end
        STATE_PENDING: begin
          pc_now_reg <= pc_next_comb;
          inst_reg <= wb_dat_i;
          state <= STATE_READY;
          // if (wb_ack_i == 1'b1) begin
          //   // pc_now_reg <= pc_reg;
          //   // pc_reg <= pc_next_comb;
          //   pc_now_reg <= pc_next_comb;
          //   inst_reg <= wb_dat_i;
          //   state <= STATE_READY;
          // end
        end
      endcase
    end
  end

endmodule