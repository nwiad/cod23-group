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
    output reg cache_hit_o,

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
  logic [1:0] refetch;
  logic [31:0] refetch_pc;
  logic [31:0] cache_pc_comb;
  always_comb begin
    pc_plus_4_comb = pc_now_reg + 32'h0000_0004;
    pc_next_comb = (refetch == 2'b10) ? refetch_pc : pc_plus_4_comb;
    cache_pc_comb = (refetch != 2'b0) ? refetch_pc : pc_plus_4_comb;
  end

  // icache
  logic write;
  logic [31:0] write_pc, write_inst;
  logic [31:0] cached_inst;
  logic hit;
  reg hit_reg;
  icache u_icache (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .write_i(write),
    .write_pc_i(write_pc),
    .write_inst_i(write_inst),
    .pc_i(cache_pc_comb),
    .inst_o(cached_inst),
    .hit_o(hit)
  );

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
        if (hit == 1'b1 || stall_i) begin
          stall_o = 1'b0;
          wb_cyc_o = 1'b0;
          wb_stb_o = 1'b0;
        end else begin
          stall_o = 1'b1;
          wb_cyc_o = 1'b1;
          wb_stb_o = 1'b1;
          wb_adr_o = pc_next_comb;
          wb_dat_o = 32'h0000_0000;
          wb_sel_o = 4'b1111;
          wb_we_o = 1'b0;
        end
      end
      default: ;
    endcase
  end

  always_comb begin
    cache_hit_o = hit;
    inst_o = inst_reg;
    pc_now_o = pc_now_reg;
    rs1_o = inst_reg[19:15];
    rs2_o = inst_reg[24:20];
  end

  always_ff @(posedge clk_i) begin
    hit_reg <= hit;
    if (write == 1'b1) begin
      write <= 1'b0;
    end
    if (pc_src_i == 1'b1) begin
      refetch <= 2'b01;
      refetch_pc <= pc_result_i;
    end
    if (rst_i) begin
      state <= STATE_READY;
      pc_now_reg <= 32'h7FFF_FFFC;
      inst_reg <= 32'h0000_0000;
      refetch <= 2'b0;
      refetch_pc <= 32'h0000_0000;
      hit_reg <= 1'b0;
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
          if (refetch == 2'b0) begin
            pc_now_reg <= pc_next_comb;
            if (hit_reg == 1'b1) begin
              inst_reg <= cached_inst;
            end else begin
              inst_reg <= wb_dat_i;
              write <= 1'b1;
              write_pc <= pc_next_comb;
              write_inst <= wb_dat_i;
            end
          end else if (refetch == 2'b01) begin
            refetch <= 2'b10;
          end else if (refetch == 2'b10) begin
            pc_now_reg <= pc_next_comb;
            if (hit_reg == 1'b1) begin
              inst_reg <= cached_inst;
            end else begin
              inst_reg <= wb_dat_i;
              write <= 1'b1;
              write_pc <= pc_next_comb;
              write_inst <= wb_dat_i;
            end
            refetch <= 2'b0;
          end
          if (hit_reg == 1'b0) begin
            state <= STATE_READY;
          end
        end
      endcase
    end
  end

endmodule