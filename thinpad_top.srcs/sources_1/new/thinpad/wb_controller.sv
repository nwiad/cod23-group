`default_nettype none

module wb_controller #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
) (
    input wire clk_i,
    input wire rst_i,

    input wire stall_i,
    input wire bubble_i,

    output reg stall_o,
    output reg flush_o,

    // WB control
    input wire mem_to_reg_i,
    input wire reg_write_i,
    input wire imm_to_reg_i,

    // MEM -> WB
    input wire [31:0] sram_rdata_i,
    input wire [31:0] alu_result_i,
    input wire [4:0]  rd_i,
    input wire [31:0] imm_i, // for lui
    input wire [31:0] pc_now_i,

    // MEM -> WB : csr
    input wire [31:0] alu_result_csr_i,
    input wire [11:0] rd_csr_i,
    input wire reg_to_csr_i,

    // WB -> ID
    output reg [31:0] rf_wdata_o,
    output reg [4:0]  rf_waddr_o,
    output reg rf_we_o,

    // WB -> ID csr
    output reg rf_we_csr_o,
    output reg [11:0] rf_waddr_csr_o,
    output reg [31:0] rf_wdata_csr_o,

    output reg [31:0] rdata_from_wb_o,
    output reg [31:0] csr_from_wb_o,
    output reg [11:0] WB_csr_o
);
  // outputs are bounded to these regs
  reg [31:0] rf_wdata_reg;
  reg [4:0] rf_waddr_reg;
  reg rf_we_reg;
  
  //csr
  reg [31:0] rf_wdata_csr_reg;
  reg [4:0] rf_waddr_csr_reg;
  reg rf_we_csr_reg;

  logic [31:0] writeback_data_comb;
  logic [31:0] writeback_data_csr_comb;
  always_comb begin
    writeback_data_comb = mem_to_reg_i ? sram_rdata_i : (imm_to_reg_i ? imm_i : alu_result_i);
    writeback_data_csr_comb = reg_to_csr_i ? alu_result_csr_i : 0;
  end

  always_comb begin
    stall_o = 1'b0;
    flush_o = 1'b0;
    rf_wdata_o = mem_to_reg_i ? sram_rdata_i : (imm_to_reg_i ? imm_i : alu_result_i);
    rf_waddr_o = rd_i;
    rf_we_o = reg_write_i;

    //csr
    rf_wdata_csr_o = reg_to_csr_i ? alu_result_csr_i : 0;
    rf_waddr_csr_o = rd_csr_i;
    rf_we_csr_o = reg_to_csr_i;
    WB_csr_o = rd_csr_i;
    csr_from_wb_o = alu_result_csr_i;
  end

  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      rf_wdata_reg <= 32'h0000_0000;
      rf_waddr_reg <= 5'b00000;
      rf_we_reg <= 1'b0;
      
      rf_wdata_csr_reg <= 32'h0000_0000;
      rf_waddr_csr_reg <= 5'b00000;
      rf_we_csr_reg <= 1'b0;
    end else if (stall_i) begin
      // do nothing
    end else if (bubble_i) begin
      // won'b be flushed ?
    end else begin
      // rf_wdata_reg <= writeback_data_comb;
      // rf_waddr_reg <= rd_i;
      // rf_we_reg <= reg_write_i;
      rdata_from_wb_o <= mem_to_reg_i ? sram_rdata_i : (imm_to_reg_i ? imm_i : alu_result_i);
    end
  end

endmodule
