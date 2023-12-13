`default_nettype none

module bram_controller (
  // clk and reset
  input wire clk_i,
  input wire rst_i,

  // wishbone slave interface
  input wire wb_cyc_i,
  input wire wb_stb_i,
  output reg wb_ack_o,
  input wire [31:0] wb_adr_i,
  input wire [31:0] wb_dat_i,
  output reg [31:0] wb_dat_o,
  input wire [3:0] wb_sel_i,
  input wire wb_we_i,

  // to bram
  output reg bram_we,
  output reg [18:0] bram_addr,
  output reg [7:0]  bram_data
);
  logic [1:0] adr_low_2;


  typedef enum logic [2:0] {
    STATE_INIT = 0,
    STATE_WRITE = 1,
    STATE_DONE = 2
  } state_t;
  state_t state;

  always_comb begin
    bram_we = 0;
    bram_addr = 0;
    bram_data = 0;
    wb_ack_o = 0;
    wb_dat_o = 0;
    adr_low_2 = 2'b0;
    case (state)
      STATE_INIT: begin
        /* do nothing */
      end
      STATE_WRITE: begin
        bram_we = 1;
        bram_addr = wb_adr_i[18:0];  /* 截低19位就行 */
        adr_low_2 = bram_addr[1:0];
        if (adr_low_2 == 2'b00) begin
          bram_data = wb_dat_i[7:0];
        end else if (adr_low_2 == 2'b01) begin
          bram_data = wb_dat_i[15:8];
        end else if (adr_low_2 == 2'b10) begin
          bram_data = wb_dat_i[23:16];
        end else if (adr_low_2 == 2'b11) begin
          bram_data = wb_dat_i[31:24];
        end
      end
      STATE_DONE: begin
        wb_ack_o = 1;
      end
    endcase
  end

  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      state <= STATE_INIT;
    end else begin
      case (state)
        STATE_INIT: begin
          if (wb_cyc_i && wb_stb_i && wb_we_i) begin
            state <= STATE_WRITE;
          end
        end
        STATE_WRITE: begin
          state <= STATE_DONE;
        end
        STATE_DONE: begin
          state <= STATE_INIT;
        end
      endcase
    end
  end

endmodule