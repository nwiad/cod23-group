`default_nettype none

module exe_controller #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
) (
    input wire clk_i,
    input wire rst_i,

    input wire stall_i,
    input wire bubble_i,

    output reg stall_o,
    output reg flush_o,

    // EXE control
    input wire [3:0] alu_op_i,
    input wire alu_src_i_1, // 1: alu_operand2 = rf_rdata_b; 0: alu_operand2 = imm
    input wire alu_src_i_2, // 1: alu_operand2 = rf_rdata_b; 0: alu_operand2 = imm

    // MEM control
    input wire [2:0] branch_i,
    input wire mem_read_i,
    input wire mem_write_i,
    input wire [3:0] mem_sel_i,

    // WB control
    input wire mem_to_reg_i,
    input wire reg_write_i,
    input wire imm_to_reg_i,

    // ID -> EXE
    input wire [31:0] rf_rdata_a_i,
    input wire [31:0] rf_rdata_b_i,
    input wire [31:0] rf_rdata_c_i,
    input wire [31:0] imm_i,
    input wire [4:0]  rs1_i,
    input wire [4:0]  rs2_i,
    input wire [4:0]  rd_i,
    input wire [31:0] pc_now_i,

    // forwarding
    input wire exe_rdata_a_hazard_i,  // data hazard
    input wire exe_rdata_b_hazard_i, 
    input wire mem_rdata_a_hazard_i,
    input wire mem_rdata_b_hazard_i,
    input wire wb_rdata_a_hazard_i,
    input wire wb_rdata_b_hazard_i,

    output reg exe_is_load_o,

    input wire [31:0] rdata_from_mem_i,
    input wire [31:0] rdata_from_wb_i,

    // EXE -> MEM
    output reg [31:0] alu_result_o,
    output reg [31:0] rf_rdata_b_o,
    output reg [4:0]  rd_o,
    output reg [31:0] pc_result_o, // for IF
    output reg [31:0] imm_o, // for lui
    output reg [31:0] pc_now_o, 

    // MEM control
    output reg branch_o, // for IF
    output reg mem_read_o,
    output reg mem_write_o,
    output reg [3:0] mem_sel_o,

    // WB control
    output reg mem_to_reg_o,
    output reg reg_write_o,
    output reg imm_to_reg_o,

    // fence.i
    input wire clear_icache_i,
    output reg clear_icache_o,
    output reg [31:0] sync_refetch_pc_o
);
  // outputs are bounded to these regs
  reg [31:0] alu_result_reg;
  reg [31:0] rf_rdata_b_reg;
  reg [4:0] rd_reg;
  reg [31:0] pc_result_reg;
  reg [31:0] imm_reg;

  reg branch_reg, mem_read_reg, mem_write_reg;
  reg [3:0] mem_sel_reg;

  reg mem_to_reg_reg, reg_write_reg, imm_to_reg_reg;

  reg [31:0] pc_now_reg;

  reg clear_icache_reg;
  reg [31:0] sync_refetch_pc_reg;

  // ALU
  logic [31:0] alu_operand1, alu_operand2;
  logic [3:0] alu_op;
  logic [31:0] alu_result;

  logic [31:0] rf_rdata_a_real, rf_rdata_b_real;

  logic [31:0] alu_operand1_reg, alu_operand2_reg;
  logic last_stall;
  alu32 if_alu32 (
    .alu_a(alu_operand1),
    .alu_b(alu_operand2),
    .alu_y(alu_result),
    .alu_op(alu_op)
  );

  logic branch_eq;

  always_ff @(posedge clk_i) begin
    last_stall <= stall_i;
    alu_operand1_reg <= alu_operand1;
    alu_operand2_reg <= alu_operand2;
  end

  always_comb begin
    exe_is_load_o = mem_read_i;
    // forwarding

    if (exe_rdata_a_hazard_i) begin
      rf_rdata_a_real = alu_result_reg;
    end else if (mem_rdata_a_hazard_i) begin
      rf_rdata_a_real = rdata_from_mem_i;
    end else if (wb_rdata_a_hazard_i) begin
      rf_rdata_a_real = rdata_from_wb_i;
    end else begin
      rf_rdata_a_real = rf_rdata_a_i;
    end

    if (exe_rdata_b_hazard_i) begin
      rf_rdata_b_real = alu_result_reg;
    end else if (mem_rdata_b_hazard_i) begin
      rf_rdata_b_real = rdata_from_mem_i;
    end else if (wb_rdata_b_hazard_i) begin
      rf_rdata_b_real = rdata_from_wb_i;
    end else begin
      rf_rdata_b_real = rf_rdata_b_i;
    end

    // alu_operand1
    if (last_stall) begin
      alu_operand1 = alu_operand1_reg;
    end else if (alu_src_i_1) begin
      alu_operand1 = rf_rdata_a_real;
    end else begin  // operand_1 is imm
      alu_operand1 = rf_rdata_c_i;
    end

    // alu_operand2
    if (last_stall) begin
      alu_operand2 = alu_operand2_reg;
    end else if (alu_src_i_2) begin
      alu_operand2 = rf_rdata_b_real;
    end else begin  // operand_2 is imm
      if ((branch_i == 3'b100) || (branch_i == 3'b011)) begin
        alu_operand2 = 32'b100;
      end else begin
        alu_operand2 = imm_i;
      end
    end
    alu_op = alu_op_i;

    branch_eq = (branch_i == 3'b100) || (branch_i == 3'b011) || ((branch_i == 3'b001) && (rf_rdata_a_real == rf_rdata_b_real)) || ((branch_i == 3'b010) && (rf_rdata_a_real != rf_rdata_b_real));
  end

  always_comb begin
    stall_o = 1'b0; // won't stall other stages ?
    // flush_o = branch_eq ? 1'b1 : 1'b0;
    flush_o = (branch_eq || clear_icache_i) ? 1'b1 : 1'b0;

    alu_result_o = alu_result_reg;
    rf_rdata_b_o = rf_rdata_b_reg;
    rd_o = rd_reg;
    pc_result_o = pc_result_reg;
    imm_o = imm_reg;
    pc_now_o = pc_now_reg;

    branch_o = branch_reg;
    mem_read_o = mem_read_reg;
    mem_write_o = mem_write_reg;
    mem_sel_o = mem_sel_reg;

    mem_to_reg_o = mem_to_reg_reg;
    reg_write_o = reg_write_reg;
    imm_to_reg_o = imm_to_reg_reg;

    clear_icache_o = clear_icache_reg;
  end

  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      alu_result_reg <= 32'h0000_0000;
      rf_rdata_b_reg <= 32'h0000_0000;
      rd_reg <= 5'b00000;
      pc_result_reg <= 32'h8000_0000;
      imm_reg <= 32'h0000_0000;

      branch_reg <= 1'b0;
      mem_read_reg <= 1'b0;
      mem_write_reg <= 1'b0;

      mem_to_reg_reg <= 1'b0;
      reg_write_reg <= 1'b0;
      imm_to_reg_reg <= 1'b0;
      pc_now_reg <= 32'h8000_0000;

      clear_icache_reg <= 1'b0;
      sync_refetch_pc_reg <= 32'h8000_0000;
    end else if (stall_i) begin
      // do nothing
    end else if (bubble_i) begin
      // won'b be flushed ?
    end else begin
      alu_result_reg <= alu_result;
      rf_rdata_b_reg <= rf_rdata_b_real;
      // if (exe_rdata_b_hazard_i) begin
      //   rf_rdata_b_reg <= alu_result_reg;
      // end else if (mem_rdata_b_hazard_i) begin
      //   rf_rdata_b_reg <= rdata_from_mem_i;
      // end else if (wb_rdata_b_hazard_i) begin
      //   rf_rdata_b_reg <= rdata_from_wb_i;
      // end begin
      //   rf_rdata_b_reg <= rf_rdata_b_i;
      // end
      // rf_rdata_b_reg <= rf_rdata_b_i;
      rd_reg <= rd_i;
      if (branch_i == 3'b100) begin
        pc_result_reg <= rf_rdata_a_real + imm_i;
      end else begin
        pc_result_reg <= pc_now_i + imm_i;
      end
      imm_reg <= imm_i;

      branch_reg <= branch_eq;
      mem_read_reg <= mem_read_i;
      mem_write_reg <= mem_write_i;
      mem_sel_reg <= mem_sel_i;

      mem_to_reg_reg <= mem_to_reg_i;
      reg_write_reg <= reg_write_i;
      imm_to_reg_reg <= imm_to_reg_i;
      pc_now_reg <= pc_now_i;

      clear_icache_reg <= clear_icache_i;
      sync_refetch_pc_reg <= pc_now_i + 32'h0000_0004;
    end
  end

endmodule