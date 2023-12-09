module mtime_controller #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
) (
  // clk and reset
  input wire clk_i,
  input wire rst_i,
  
  // wishbone slave interface
  input wire wb_cyc_i,
  input wire wb_stb_i,
  output reg wb_ack_o,
  input wire [ADDR_WIDTH-1:0] wb_adr_i,
  input wire [DATA_WIDTH-1:0] wb_dat_i,
  output reg [DATA_WIDTH-1:0] wb_dat_o,
  input wire [DATA_WIDTH/8-1:0] wb_sel_i,
  input wire wb_we_i,  
  
  // mtime exceeded signal
  output reg mtime_exceed_o
);


endmodule