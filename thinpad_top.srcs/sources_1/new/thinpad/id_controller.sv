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
    output reg [31:0] rf_rdata_c_o,
    output reg [31:0] imm_o,
    output reg [4:0]  rs1_o,
    output reg [4:0]  rs2_o,
    output reg [4:0]  rd_o,
    output reg [31:0] pc_now_o,

    // EXE control
    output reg [3:0] alu_op_o,
    output reg alu_src_o_1, // reg1 1: alu_operand2 = rf_rdata_b; 0: alu_operand2 = imm
    output reg alu_src_o_2, // reg2 1: alu_operand2 = rf_rdata_b; 0: alu_operand2 = imm

    // forwarding
    input reg exe_rdata_a_hazard_i,
    input reg exe_rdata_b_hazard_i,
    input reg mem_rdata_a_hazard_i,
    input reg mem_rdata_b_hazard_i,
    input reg wb_rdata_a_hazard_i,
    input reg wb_rdata_b_hazard_i,

    output reg exe_rdata_a_hazard_o,
    output reg exe_rdata_b_hazard_o,
    output reg mem_rdata_a_hazard_o,
    output reg mem_rdata_b_hazard_o,
    output reg wb_rdata_a_hazard_o,
    output reg wb_rdata_b_hazard_o,

    // MEM control
    output reg [2:0] branch_o, // for IF
    output reg mem_read_o,
    output reg mem_write_o,
    output reg [3:0] mem_sel_o,

    // WB control
    output reg mem_to_reg_o,
    output reg reg_write_o,
    output reg imm_to_reg_o,

    // fence.i
    output reg clear_icache_o,
    // branch prediction
    output reg [31:0] ID_pc_now_o,
    output reg ID_is_branch_o,
    output reg ID_is_jalr_o,
    output reg [31:0] ID_imm_o
);
  // outputs are bounded to these regs
  reg [31:0] rf_rdata_a_reg, rf_rdata_b_reg, rf_rdata_c_reg;
  reg [31:0] imm_reg;
  reg [4:0] rs1_reg, rs2_reg, rd_reg;
  reg [31:0] pc_now_reg;

  reg [3:0] alu_op_reg;
  reg alu_src_reg_1;
  reg alu_src_reg_2;

  reg [2:0] branch_reg;
  reg mem_read_reg, mem_write_reg;
  reg [3:0] mem_sel_reg;

  reg mem_to_reg_reg, reg_write_reg, imm_to_reg_reg;

  reg clear_icache_reg;

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

  //types
  logic is_rtype_comb, is_itype_comb, is_stype_comb, is_btype_comb, is_jtype_comb, is_utype_comb, is_load_comb;
  //Rtype
  logic is_add_comb, is_and_comb, is_or_comb, is_xor_comb;
  //Itype
  logic is_addi_comb, is_andi_comb, is_lb_comb, is_lw_comb, is_ori_comb, is_slli_comb, is_srli_comb, is_jalr_comb;
  //Utype
  logic is_auipc_comb, is_lui_comb;
  //Btype
  logic is_beq_comb, is_bne_comb;
  //Jtype
  logic is_jal_comb;
  //Stype
  logic is_sb_comb, is_sw_comb;

  //special instructions：PCNT, MINU, SBCLR
  // integer bit_counter;
  logic is_pcnt_comb, is_minu_comb, is_sbclr_comb;
  // logic [5:0] 1bit_num_comb;

  logic is_fence_i_comb;

  logic is_lh_comb;
  logic is_sh_comb;

  logic [4:0] rd_comb, rs1_comb, rs2_comb;
  logic [3:0] alu_op_comb;
  logic alu_src_comb_1, alu_src_comb_2;
  logic [3:0] mem_sel_comb;

  always_comb begin
    is_rtype_comb = (inst_i[6:0] == 7'b011_0011);
    is_itype_comb = (inst_i[6:0] == 7'b001_0011) || (inst_i[6:0] == 7'b110_0111); // 不包括 load
    is_load_comb  = (inst_i[6:0] == 7'b000_0011);
    is_jtype_comb = (inst_i[6:0] == 7'b110_1111);
    is_utype_comb = (inst_i[6:0] == 7'b001_0111) || (inst_i[6:0] == 7'b011_0111);
    is_stype_comb = (inst_i[6:0] == 7'b010_0011);
    is_btype_comb = (inst_i[6:0] == 7'b110_0011);

    is_lh_comb = (is_load_comb && (inst_i[14:12] == 3'b001));

    is_sh_comb = (is_stype_comb && (inst_i[14:12] == 3'b001));

    is_fence_i_comb = (inst_i == 32'h0000_100F); // 0000_0000_0000_0000_0001_0000_0000_1111

    is_pcnt_comb = (is_itype_comb && (inst_i[14:12] == 3'b001)) && (inst_i[31:25] == 7'b011_0000);
    
    is_minu_comb  = (is_rtype_comb && (inst_i[14:12] == 3'b110)) && (inst_i[31:25] == 7'b000_0101);

    is_sbclr_comb  = (is_rtype_comb && (inst_i[14:12] == 3'b001)) && (inst_i[31:25] == 7'b010_0100);

    //ADD   0000000SSSSSsssss000ddddd0110011
    is_add_comb  = (is_rtype_comb && (inst_i[14:12] == 3'b000));
    //ADDI  iiiiiiiiiiiisssss000ddddd0010011
    is_addi_comb = (is_itype_comb && (inst_i[14:12] == 3'b000));
    //AND   0000000SSSSSsssss111ddddd0110011
    is_and_comb  = (is_rtype_comb && (inst_i[14:12] == 3'b111));
    //ANDI  iiiiiiiiiiiisssss111ddddd0010011
    is_andi_comb = (is_itype_comb && (inst_i[14:12] == 3'b111));
    //AUIPC iiiiiiiiiiiiiiiiiiiiddddd0010111
    is_auipc_comb = (inst_i[6:0] == 7'b001_0111);
    //BEQ   iiiiiiiSSSSSsssss000iiiii1100011
    is_beq_comb  = (is_btype_comb && (inst_i[14:12] == 3'b000));
    //BNE   iiiiiiiSSSSSsssss001iiiii1100011
    is_bne_comb  = (is_btype_comb && (inst_i[14:12] == 3'b001));
    //JAL   iiiiiiiiiiiiiiiiiiiiddddd1101111
    is_jal_comb  = (inst_i[6:0] == 7'b110_1111);
    //JALR  iiiiiiiiiiiisssss000ddddd1100111
    is_jalr_comb  = (inst_i[6:0] == 7'b110_0111);
    //LB    iiiiiiiiiiiisssss000ddddd0000011
    is_lb_comb   = (is_load_comb && (inst_i[14:12] == 3'b000));
    //LUI   iiiiiiiiiiiiiiiiiiiiddddd0110111
    is_lui_comb   = (inst_i[6:0] == 7'b011_0111);
    //LW    iiiiiiiiiiiisssss010ddddd0000011
    is_lw_comb   = (is_load_comb && (inst_i[14:12] == 3'b010));
    //OR    0000000SSSSSsssss110ddddd0110011
    is_or_comb  = (is_rtype_comb && (inst_i[14:12] == 3'b110)) && (inst_i[31:25] == 7'b000_0000);
    //ORI   iiiiiiiiiiiisssss110ddddd0010011
    is_ori_comb  = (is_itype_comb && (inst_i[14:12] == 3'b110));
    //SB    iiiiiiiSSSSSsssss000iiiii0100011
    is_sb_comb   = (is_stype_comb && (inst_i[14:12] == 3'b000));
    //SLLI  0000000iiiiisssss001ddddd0010011
    is_slli_comb   = (is_itype_comb && (inst_i[14:12] == 3'b001) && (inst_i[31:25] == 7'b000_0000));
    //SRLI  0000000iiiiisssss101ddddd0010011
    is_srli_comb   = (is_itype_comb && (inst_i[14:12] == 3'b101));
    //SW    iiiiiiiSSSSSsssss010iiiii0100011
    is_sw_comb   = (is_stype_comb && (inst_i[14:12] == 3'b010));
    //XOR   0000000SSSSSsssss100ddddd0110011
    is_xor_comb  = (is_rtype_comb && (inst_i[14:12] == 3'b100));
    rd_comb  = inst_i[11:7];
    rs1_comb = inst_i[19:15];
    rs2_comb = inst_i[24:20];

    // 1bit_num_comb = 0;
    // for (bit_counter = 0; bit_counter < 32; bit_counter++) begin
    //   1bit_num_comb = 1bit_num_comb + rf_rdata_a[bit_counter];
    // end

    if (is_add_comb || is_addi_comb || is_lb_comb || is_lh_comb || is_lw_comb || is_sb_comb || is_sh_comb || is_sw_comb || is_utype_comb || is_jtype_comb || is_jalr_comb) begin
      alu_op_comb = 4'b0001;
    end else if (is_andi_comb || is_and_comb) begin
      alu_op_comb = 4'b0011;
    end else if (is_or_comb || is_ori_comb) begin
      alu_op_comb = 4'b0100;
    end else if (is_xor_comb) begin
      alu_op_comb = 4'b0101;
    end else if (is_slli_comb) begin
      alu_op_comb = 4'b0111;
    end else if (is_srli_comb) begin
      alu_op_comb = 4'b1000;
    end else if (is_pcnt_comb) begin
      alu_op_comb = 4'b1011;
    end else if (is_minu_comb) begin
      alu_op_comb = 4'b1100;
    end else if (is_sbclr_comb) begin
      alu_op_comb = 4'b1101;
    end else begin
      alu_op_comb = 4'b0000;
    end

    alu_src_comb_1 = !(is_lui_comb || is_auipc_comb || is_jtype_comb || is_jalr_comb);
    alu_src_comb_2 = is_rtype_comb;

    if (is_lb_comb || is_sb_comb) begin
      mem_sel_comb = 4'b0001;
    end else if (is_lh_comb || is_sh_comb) begin
      mem_sel_comb = 4'b0011;
    end else if (is_sw_comb || is_lw_comb) begin
      mem_sel_comb = 4'b1111;
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
    end else if (is_utype_comb) begin
      inst_type = 3'b100;
    end else if (is_jtype_comb) begin
      inst_type = 3'b101;
    end else begin
      inst_type = 3'b000;
    end
  end

  assign ID_is_branch_o = is_beq_comb || is_bne_comb || is_jal_comb || is_jalr_comb;
  assign ID_is_jalr_o = is_jalr_comb;
  assign ID_imm_o = imm;
  assign ID_pc_now_o = pc_now_i;

  always_comb begin
    stall_o = 1'b0; // won't stall other stages ?
    flush_o = 1'b0; // won't flush other stages ?

    rf_rdata_a_o = rf_rdata_a_reg;
    rf_rdata_b_o = rf_rdata_b_reg;
    rf_rdata_c_o = rf_rdata_c_reg;

    imm_o = imm_reg;
    rs1_o = rs1_reg;
    rs2_o = rs2_reg;
    rd_o = rd_reg;
    pc_now_o = pc_now_reg;

    alu_op_o = alu_op_reg;
    alu_src_o_1 = alu_src_reg_1;
    alu_src_o_2 = alu_src_reg_2;

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
      rf_rdata_a_reg <= 32'h0000_0000;
      rf_rdata_b_reg <= 32'h0000_0000;
      rf_rdata_c_reg <= 32'h0000_0000;
      imm_reg <= 32'h0000_0000;
      rs1_reg <= 5'b00000;
      rs2_reg <= 5'b00000;
      rd_reg <= 5'b00000;
      pc_now_reg <= 32'h8000_0000;

      alu_op_reg <= 4'b0000;
      alu_src_reg_1 <= 1'b0;
      alu_src_reg_2 <= 1'b0;

      branch_reg <= 3'b0;
      mem_read_reg <= 1'b0;
      mem_write_reg <= 1'b0;
      mem_sel_reg <= 4'b0000;

      mem_to_reg_reg <= 1'b0;
      reg_write_reg <= 1'b0;
      imm_to_reg_reg <= 1'b0;
      clear_icache_reg <= 1'b0;
    end else if (stall_i) begin
      // do nothing
    end else if (bubble_i) begin
      rf_rdata_a_reg <= 32'h0000_0000;
      rf_rdata_b_reg <= 32'h0000_0000;
      rf_rdata_c_reg <= 32'h0000_0000;
      imm_reg <= 32'h0000_0000;
      rs1_reg <= 5'b00000;
      rs2_reg <= 5'b00000;
      rd_reg <= 5'b00000;

      // controls of addi zero, zero, 0
      alu_op_reg <= 4'b0001;
      alu_src_reg_1 <= 1'b0;
      alu_src_reg_2 <= 1'b0;

      branch_reg <= 3'b0;
      mem_read_reg <= 1'b0;
      mem_write_reg <= 1'b0;
      mem_sel_reg <= 4'b0000;

      mem_to_reg_reg <= 1'b0;
      reg_write_reg <= 1'b1;
      imm_to_reg_reg <= 1'b0;

      clear_icache_reg <= 1'b0;
    end else begin
      rf_rdata_a_reg <= rf_rdata_a;
      // rf_rdata_b_reg <= rf_rdata_b;
      if (is_lui_comb) begin
        rf_rdata_c_reg <= 32'b0;
      end else if (is_auipc_comb || is_jtype_comb || is_jalr_comb) begin
        rf_rdata_c_reg <= pc_now_i;
      end else begin
        rf_rdata_c_reg <= 32'b0;
      end
      if (is_jtype_comb || is_jalr_comb) begin
        rf_rdata_b_reg <= 32'b100;
      end else begin
        rf_rdata_b_reg <= rf_rdata_b;
      end

      imm_reg <= imm;
      // if (is_pcnt_comb) begin
      //   imm_reg <= 1bit_num_comb;
      // end else begin
      //   imm_reg <= imm;
      // end

      rs1_reg <= rs1_comb;
      rs2_reg <= rs2_comb;
      if (is_rtype_comb || is_utype_comb || is_itype_comb || is_jtype_comb || is_load_comb) begin
        rd_reg <= rd_comb;
      end else begin
        rd_reg <= 5'b0;
      end
      pc_now_reg <= pc_now_i;

      alu_op_reg <= alu_op_comb;
      alu_src_reg_1 <= alu_src_comb_1;
      alu_src_reg_2 <= alu_src_comb_2;

      if (is_beq_comb) begin
        branch_reg <= 3'b001;
      end else if (is_bne_comb) begin
        branch_reg <= 3'b010;
      end else if (is_jal_comb) begin
        branch_reg <= 3'b011;
      end else if (is_jalr_comb) begin
        branch_reg <= 3'b100;
      end else begin
        branch_reg <= 3'b000;
      end
      mem_read_reg <= is_lb_comb || is_lh_comb || is_lw_comb;
      mem_write_reg <= (is_sb_comb || is_sh_comb || is_sw_comb);
      mem_sel_reg <= mem_sel_comb;

      mem_to_reg_reg <= is_lb_comb || is_lh_comb || is_lw_comb;
      reg_write_reg <= (is_rtype_comb || is_utype_comb || is_itype_comb || is_jtype_comb || is_load_comb);
      imm_to_reg_reg <= 1'b0;

      clear_icache_reg <= is_fence_i_comb;

      // forwarding
      exe_rdata_a_hazard_o <= exe_rdata_a_hazard_i;
      exe_rdata_b_hazard_o <= exe_rdata_b_hazard_i;
      mem_rdata_a_hazard_o <= mem_rdata_a_hazard_i;
      mem_rdata_b_hazard_o <= mem_rdata_b_hazard_i;
      wb_rdata_a_hazard_o <= wb_rdata_a_hazard_i;
      wb_rdata_b_hazard_o <= wb_rdata_b_hazard_i;
    end
  end

endmodule