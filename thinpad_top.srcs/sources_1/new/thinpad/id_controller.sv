`default_nettype none

module id_controller #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
) (
    input wire clk_i,
    input wire rst_i,

    input wire stall_i,
    input wire bubble_i,

    output reg stall_o,
    output reg flush_o,

    // WB -> ID
    input wire rf_we_i,
    input wire [4:0] rf_waddr_i,
    input wire [31:0] rf_wdata_i,

    // IF -> ID
    input wire [31:0] pc_now_i,
    input wire [31:0] inst_i,

    // ID -> EXE
    output reg [31:0] rf_rdata_a_o,
    output reg [31:0] rf_rdata_b_o,
    output reg [31:0] imm_o,
    output reg [4:0]  rs1_o,
    output reg [4:0]  rs2_o,
    output reg [4:0]  rd_o,
    output reg [31:0] pc_now_o,

    // EXE control
    output reg [3:0] alu_op_o,
    output reg alu_src_o, // 1: alu_operand2 = rf_rdata_b; 0: alu_operand2 = imm

    // forwarding
    input reg exe_rdata_a_hazard_i,
    input reg exe_rdata_b_hazard_i,
    input reg mem_rdata_a_hazard_i,
    input reg mem_rdata_b_hazard_i,

    output reg exe_rdata_a_hazard_o,
    output reg exe_rdata_b_hazard_o,
    output reg mem_rdata_a_hazard_o,
    output reg mem_rdata_b_hazard_o,

    // MEM control
    output reg branch_o, // for IF
    output reg mem_read_o,
    output reg mem_write_o,
    output reg [3:0] mem_sel_o,

    // WB control
    output reg mem_to_reg_o,
    output reg reg_write_o,
    output reg imm_to_reg_o
);
  // outputs are bounded to these regs
  reg [31:0] rf_rdata_a_reg, rf_rdata_b_reg;
  reg [31:0] imm_reg;
  reg [4:0] rs1_reg, rs2_reg, rd_reg;
  reg [31:0] pc_now_reg;

  reg [3:0] alu_op_reg;
  reg alu_src_reg;

  reg branch_reg, mem_read_reg, mem_write_reg;
  reg [3:0] mem_sel_reg;

  reg mem_to_reg_reg, reg_write_reg, imm_to_reg_reg;

  // regfile
  logic [4:0] rf_raddr_a, rf_raddr_b;
  logic [31:0] rf_rdata_a, rf_rdata_b;
  logic [4:0] rf_waddr;
  logic [31:0] rf_wdata;
  logic rf_we;
  regfile32 id_regfile32 (
    .clk(clk_i),
    .reset(rst_i),
    .rf_raddr_a(rf_raddr_a),
    .rf_rdata_a(rf_rdata_a),
    .rf_raddr_b(rf_raddr_b),
    .rf_rdata_b(rf_rdata_b),
    .rf_waddr(rf_waddr),
    .rf_wdata(rf_wdata),
    .rf_we(rf_we)
  );

  // immediate generator
  logic [31:0] inst;
  logic [2:0] inst_type;
  logic [31:0] imm;
  imm_gen id_imm_gen (
    .inst(inst),
    .inst_type(inst_type),
    .imm(imm)
  );

  logic is_rtype_comb, is_itype_comb, is_load_comb, is_stype_comb, is_btype_comb, is_lui_comb;
  logic is_add_comb, is_addi_comb, is_andi_comb, is_lb_comb, is_sb_comb, is_sw_comb, is_beq_comb;
  logic [4:0] rd_comb, rs1_comb, rs2_comb;
  logic [3:0] alu_op_comb;
  logic alu_src_comb;
  logic [3:0] mem_sel_comb;

  always_comb begin
    is_rtype_comb = (inst_i[6:0] == 7'b011_0011);
    is_itype_comb = (inst_i[6:0] == 7'b001_0011); // 不包括 load
    is_load_comb  = (inst_i[6:0] == 7'b000_0011);
    is_stype_comb = (inst_i[6:0] == 7'b010_0011);
    is_btype_comb = (inst_i[6:0] == 7'b110_0011);
    is_lui_comb   = (inst_i[6:0] == 7'b011_0111);

    is_add_comb  = (is_rtype_comb && (inst_i[14:12] == 3'b000));
    is_addi_comb = (is_itype_comb && (inst_i[14:12] == 3'b000));
    is_andi_comb = (is_itype_comb && (inst_i[14:12] == 3'b111));
    is_lb_comb   = (is_load_comb  && (inst_i[14:12] == 3'b000));
    is_sb_comb   = (is_stype_comb && (inst_i[14:12] == 3'b000));
    is_sw_comb   = (is_stype_comb && (inst_i[14:12] == 3'b010));
    is_beq_comb  = (is_btype_comb && (inst_i[14:12] == 3'b000));

    rd_comb  = inst_i[11:7];
    rs1_comb = inst_i[19:15];
    rs2_comb = inst_i[24:20];

    if (is_add_comb || is_addi_comb || is_lb_comb || is_sb_comb || is_sw_comb) begin
      alu_op_comb = 4'b0001;
    end else if (is_andi_comb) begin
      alu_op_comb = 4'b0011;
    end else begin
      alu_op_comb = 4'b0000;
    end

    alu_src_comb = is_add_comb;

    if (is_lb_comb || is_sb_comb) begin
      mem_sel_comb = 4'b0001;
    end else if (is_sw_comb) begin
      mem_sel_comb = 4'b0011;
    end else begin
      mem_sel_comb = 4'b0000;
    end

    rf_raddr_a = rs1_comb;
    rf_raddr_b = rs2_comb;
    rf_waddr = rf_waddr_i;
    rf_wdata = rf_wdata_i;
    rf_we = rf_we_i;

    inst = inst_i;
    if (is_itype_comb || is_load_comb) begin
      inst_type = 3'b001;
    end else if (is_stype_comb) begin
      inst_type = 3'b010;
    end else if (is_btype_comb) begin
      inst_type = 3'b011;
    end else if (is_lui_comb) begin
      inst_type = 3'b100;
    end else begin
      inst_type = 3'b000;
    end
  end

  always_comb begin
    stall_o = 1'b0; // won't stall other stages ?
    flush_o = 1'b0; // won't flush other stages ?

    rf_rdata_a_o = rf_rdata_a_reg;
    rf_rdata_b_o = rf_rdata_b_reg;
    imm_o = imm_reg;
    rs1_o = rs1_reg;
    rs2_o = rs2_reg;
    rd_o = rd_reg;
    pc_now_o = pc_now_reg;

    alu_op_o = alu_op_reg;
    alu_src_o = alu_src_reg;

    branch_o = branch_reg;
    mem_read_o = mem_read_reg;
    mem_write_o = mem_write_reg;
    mem_sel_o = mem_sel_reg;

    mem_to_reg_o = mem_to_reg_reg;
    reg_write_o = reg_write_reg;
    imm_to_reg_o = imm_to_reg_reg;
  end

  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      rf_rdata_a_reg <= 32'h0000_0000;
      rf_rdata_b_reg <= 32'h0000_0000;
      imm_reg <= 32'h0000_0000;
      rs1_reg <= 5'b00000;
      rs2_reg <= 5'b00000;
      rd_reg <= 5'b00000;
      pc_now_reg <= 32'h8000_0000;

      alu_op_reg <= 4'b0000;
      alu_src_reg <= 1'b0;

      branch_reg <= 1'b0;
      mem_read_reg <= 1'b0;
      mem_write_reg <= 1'b0;
      mem_sel_reg <= 4'b0000;

      mem_to_reg_reg <= 1'b0;
      reg_write_reg <= 1'b0;
      imm_to_reg_reg <= 1'b0;
    end else if (stall_i) begin
      // do nothing
    end else if (bubble_i) begin
      rf_rdata_a_reg <= 32'h0000_0000;
      rf_rdata_b_reg <= 32'h0000_0000;
      imm_reg <= 32'h0000_0000;
      rs1_reg <= 5'b00000;
      rs2_reg <= 5'b00000;
      rd_reg <= 5'b00000;

      // controls of addi zero, zero, 0
      alu_op_reg <= 4'b0001;
      alu_src_reg <= 1'b0;

      branch_reg <= 1'b0;
      mem_read_reg <= 1'b0;
      mem_write_reg <= 1'b0;
      mem_sel_reg <= 4'b0000;

      mem_to_reg_reg <= 1'b0;
      reg_write_reg <= 1'b1;
      imm_to_reg_reg <= 1'b0;
    end else begin
      rf_rdata_a_reg <= rf_rdata_a;
      rf_rdata_b_reg <= rf_rdata_b;
      imm_reg <= imm;
      rs1_reg <= rs1_comb;
      rs2_reg <= rs2_comb;
      rd_reg <= rd_comb;
      pc_now_reg <= pc_now_i;

      alu_op_reg <= alu_op_comb;
      alu_src_reg <= alu_src_comb;

      branch_reg <= is_beq_comb;
      mem_read_reg <= is_lb_comb;
      mem_write_reg <= (is_sb_comb || is_sw_comb);
      mem_sel_reg <= mem_sel_comb;

      mem_to_reg_reg <= is_lb_comb;
      reg_write_reg <= (is_add_comb || is_addi_comb || is_andi_comb || is_lb_comb || is_lui_comb);
      imm_to_reg_reg <= is_lui_comb;

      // forwarding
      exe_rdata_a_hazard_o <= exe_rdata_a_hazard_i;
      exe_rdata_b_hazard_o <= exe_rdata_b_hazard_i;
      mem_rdata_a_hazard_o <= mem_rdata_a_hazard_i;
      mem_rdata_b_hazard_o <= mem_rdata_b_hazard_i;
    end
  end

endmodule