`default_nettype none

module mem_controller #(
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

    // MEM control
    input wire mem_read_i,
    input wire mem_write_i,
    input wire [3:0] mem_sel_i,

    // WB control
    input wire mem_to_reg_i,
    input wire reg_write_i,
    input wire imm_to_reg_i,

    // EXE -> MEM
    input wire [31:0] pc_now_i,
    input wire [31:0] alu_result_i,
    input wire [31:0] rf_rdata_b_i,
    input wire [4:0]  rd_i,
    input wire [31:0] pc_result_i, // useless
    input wire [31:0] imm_i, // for lui

    // MEM -> WB
    output reg [31:0] sram_rdata_o,
    output reg [31:0] alu_result_o,
    output reg [4:0]  rd_o,
    output reg [31:0] imm_o,
    output reg [31:0] pc_now_o,

    // WB control
    output reg mem_to_reg_o,
    output reg reg_write_o,
    output reg imm_to_reg_o,

    // forwarding
    output reg [31:0] rdata_from_mem_o
);
  // outputs are bounded to these regs
  reg [31:0] sram_rdata_reg;

  reg [31:0] alu_result_reg;
  reg [4:0] rd_reg;
  reg [31:0] imm_reg;
  reg mem_to_reg_reg, reg_write_reg, imm_to_reg_reg;

  reg mem_read_reg;

  reg [31:0] pc_now_reg;

  typedef enum logic [2:0] { 
    STATE_READY = 0,
    STATE_PENDING = 1
  } state_t;
  state_t state;

  always_comb begin
    flush_o = 1'b0;
    stall_o = 1'b0;
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
        if (mem_read_i) begin // lb
          stall_o = 1'b1;
          wb_cyc_o = 1'b1;
          wb_stb_o = 1'b1;
          wb_adr_o = alu_result_i;
          wb_dat_o = 32'h0000_0000;
          wb_sel_o = mem_sel_i << alu_result_i[1:0];
          wb_we_o = 1'b0;
        end else if (mem_write_i) begin // sb or sw
          stall_o = 1'b1;
          wb_cyc_o = 1'b1;
          wb_stb_o = 1'b1;
          wb_adr_o = alu_result_i;
          wb_dat_o = rf_rdata_b_i << ({30'b0, alu_result_i[1:0]} << 3);
          wb_sel_o = mem_sel_i << alu_result_i[1:0];
          wb_we_o = 1'b1;
        end else begin
          stall_o = 1'b0;
          wb_cyc_o = 1'b0;
          wb_stb_o = 1'b0;
          wb_adr_o = 32'h0000_0000;
          wb_dat_o = 32'h0000_0000;
          wb_sel_o = 4'b0000;
          wb_we_o = 1'b0;
        end
      end

      default: ;
    endcase
  end

  always_comb begin
    sram_rdata_o = sram_rdata_reg;
    alu_result_o = alu_result_reg;
    rd_o = rd_reg;
    imm_o = imm_reg;
    pc_now_o = pc_now_reg;

    mem_to_reg_o = mem_to_reg_reg;
    reg_write_o = reg_write_reg;
    imm_to_reg_o = imm_to_reg_reg;

    rdata_from_mem_o = (mem_read_reg) ? sram_rdata_reg : alu_result_reg;
  end

  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      sram_rdata_reg <= 32'h0000_0000;
      alu_result_reg <= 32'h0000_0000;
      rd_reg <= 5'b00000;
      imm_reg <= 32'h0000_0000;
      pc_now_reg <= 32'h8000_0000;

      mem_to_reg_reg <= 1'b0;
      reg_write_reg <= 1'b0;
      imm_to_reg_reg <= 1'b0;
      state <= STATE_READY;
    end else if (stall_i) begin
      // do nothing
    end else if (bubble_i) begin // insert bubble while waiting for bus response
      sram_rdata_reg <= 32'h0000_0000;
      alu_result_reg <= 32'h0000_0000;
      rd_reg <= 5'b00000;
      imm_reg <= 32'h0000_0000;

      mem_to_reg_reg <= 1'b0;
      reg_write_reg <= 1'b1;
      imm_to_reg_reg <= 1'b0;
    end else begin
      case (state)
        STATE_READY: begin
          state <= STATE_PENDING;
        end
        STATE_PENDING: begin
          if (wb_ack_i) begin
            if (mem_read_i) begin
              sram_rdata_reg <= wb_dat_i >> ({30'b0, alu_result_i[1:0]} << 3);
            end else begin
              sram_rdata_reg <= 32'h0000_0000;
            end
            state <= STATE_READY;
          end
          alu_result_reg <= alu_result_i;
          rd_reg <= rd_i;
          imm_reg <= imm_i;
          mem_to_reg_reg <= mem_to_reg_i;
          reg_write_reg <= reg_write_i;
          imm_to_reg_reg <= imm_to_reg_i;

          mem_read_reg <= mem_read_i;

          pc_now_reg <= pc_now_i;
        end

        default: ;
      endcase
    end
  end

endmodule