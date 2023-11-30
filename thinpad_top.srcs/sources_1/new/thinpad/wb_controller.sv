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

    // MEM -> WB
    input wire [31:0] sram_rdata_i,
    input wire [31:0] alu_result_i,
    input wire [4:0]  rd_i,

    // WB -> ID
    output reg [31:0] rf_wdata_o,
    output reg [4:0]  rf_waddr_o,
    output reg rf_we_o
);
  // outputs are bounded to these regs
  reg [31:0] rf_wdata_reg;
  reg [4:0] rf_waddr_reg;
  reg rf_we_reg;

  logic [31:0] writeback_data_comb;
  always_comb begin
    writeback_data_comb = mem_to_reg_i ? sram_rdata_i : alu_result_i;
  end

  always_comb begin
    stall_o = 1'b0;
    flush_o = 1'b0;
    rf_wdata_o = rf_wdata_reg;
    rf_waddr_o = rf_waddr_reg;
    rf_we_o = rf_we_reg;
  end

  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      rf_wdata_reg <= 32'h0000_0000;
      rf_waddr_reg <= 5'b00000;
      rf_we_reg <= 1'b0;
    end else if (stall_i) begin
      // do nothing
    end else if (bubble_i) begin
      // won'b be flushed ?
    end else begin
      rf_wdata_reg <= writeback_data_comb;
      rf_waddr_reg <= rd_i;
      rf_we_reg <= reg_write_i;
    end
  end

endmodule
