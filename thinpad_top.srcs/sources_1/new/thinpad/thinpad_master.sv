`default_nettype none

module thinpad_master #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
) (
    input wire clk_i,
    input wire rst_i,

    // wishbone master for IF
    output reg IF_wb_cyc_o,
    output reg IF_wb_stb_o,
    input wire IF_wb_ack_i,
    output reg [ADDR_WIDTH-1:0] IF_wb_adr_o,
    output reg [DATA_WIDTH-1:0] IF_wb_dat_o,
    input wire [DATA_WIDTH-1:0] IF_wb_dat_i,
    output reg [DATA_WIDTH/8-1:0] IF_wb_sel_o,
    output reg IF_wb_we_o,

    // wishbone master for MEM
    output reg MEM_wb_cyc_o,
    output reg MEM_wb_stb_o,
    input wire MEM_wb_ack_i,
    output reg [ADDR_WIDTH-1:0] MEM_wb_adr_o,
    output reg [DATA_WIDTH-1:0] MEM_wb_dat_o,
    input wire [DATA_WIDTH-1:0] MEM_wb_dat_i,
    output reg [DATA_WIDTH/8-1:0] MEM_wb_sel_o,
    output reg MEM_wb_we_o
);

  // IF logic & IF/ID regs
  logic IF_ID_stall_in, IF_ID_bubble_in;
  logic IF_ID_stall_out, IF_ID_flush_out;
  logic [31:0] EXE_MEM_pc_result;
  logic [31:0] IF_ID_inst;
  logic [31:0] IF_ID_pc_now;
  logic [4:0] IF_ID_rs1, IF_ID_rs2;
  if_controller u_if_controller (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stall_i(IF_ID_stall_in),
    .bubble_i(IF_ID_bubble_in),
    .stall_o(IF_ID_stall_out), // 1 while wishbone request is pending
    .flush_o(IF_ID_flush_out), // 0
    .wb_cyc_o(IF_wb_cyc_o),
    .wb_stb_o(IF_wb_stb_o),
    .wb_ack_i(IF_wb_ack_i),
    .wb_adr_o(IF_wb_adr_o),
    .wb_dat_o(IF_wb_dat_o),
    .wb_dat_i(IF_wb_dat_i),
    .wb_sel_o(IF_wb_sel_o),
    .wb_we_o(IF_wb_we_o),
    .pc_src_i(EXE_MEM_branch),
    .pc_result_i(EXE_MEM_pc_result),
    .inst_o(IF_ID_inst),
    .pc_now_o(IF_ID_pc_now),
    .rs1_o(IF_ID_rs1),
    .rs2_o(IF_ID_rs2)
  );
  
  // ID logic & ID/EXE regs
  logic ID_EXE_stall_in, ID_EXE_bubble_in;
  logic ID_EXE_stall_out, ID_EXE_flush_out;
  logic WB_rf_we;
  logic [4:0] WB_rf_waddr;
  logic [31:0] WB_rf_wdata;
  logic [31:0] ID_EXE_rf_rdata_a, ID_EXE_rf_rdata_b;
  logic [31:0] ID_EXE_imm;
  logic [4:0] ID_EXE_rs1, ID_EXE_rs2, ID_EXE_rd;
  logic [31:0] ID_EXE_pc_now;
  logic [3:0] ID_EXE_alu_op;
  logic ID_EXE_alu_src;
  logic ID_EXE_branch, ID_EXE_mem_read, ID_EXE_mem_write;
  logic [3:0] ID_EXE_mem_sel;
  logic ID_EXE_mem_to_reg, ID_EXE_reg_write, ID_EXE_imm_to_reg;
  // forwarding
  logic EXE_rdata_a_hazard_in, EXE_rdata_b_hazard_in, MEM_rdata_a_hazard_in, MEM_rdata_b_hazard_in;
  logic EXE_rdata_a_hazard_out, EXE_rdata_b_hazard_out, MEM_rdata_a_hazard_out, MEM_rdata_b_hazard_out;
  id_controller u_id_controller (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stall_i(ID_EXE_stall_in),
    .bubble_i(ID_EXE_bubble_in),
    .stall_o(ID_EXE_stall_out),
    .flush_o(ID_EXE_flush_out),
    .rf_we_i(WB_rf_we),
    .rf_waddr_i(WB_rf_waddr),
    .rf_wdata_i(WB_rf_wdata),
    .pc_now_i(IF_ID_pc_now),
    .inst_i(IF_ID_inst),
    .rf_rdata_a_o(ID_EXE_rf_rdata_a),
    .rf_rdata_b_o(ID_EXE_rf_rdata_b),
    .imm_o(ID_EXE_imm),
    .rs1_o(ID_EXE_rs1),
    .rs2_o(ID_EXE_rs2),
    .rd_o(ID_EXE_rd),
    .pc_now_o(ID_EXE_pc_now),
    .alu_op_o(ID_EXE_alu_op),
    .alu_src_o(ID_EXE_alu_src),

    // forwarding
    .exe_rdata_a_hazard_i(EXE_rdata_a_hazard_in),
    .exe_rdata_b_hazard_i(EXE_rdata_b_hazard_in),
    .mem_rdata_a_hazard_i(MEM_rdata_a_hazard_in),
    .mem_rdata_b_hazard_i(MEM_rdata_b_hazard_in),
    .exe_rdata_a_hazard_o(EXE_rdata_a_hazard_out),
    .exe_rdata_b_hazard_o(EXE_rdata_b_hazard_out),
    .mem_rdata_a_hazard_o(MEM_rdata_a_hazard_out),
    .mem_rdata_b_hazard_o(MEM_rdata_b_hazard_out),

    .branch_o(ID_EXE_branch),
    .mem_read_o(ID_EXE_mem_read),
    .mem_write_o(ID_EXE_mem_write),
    .mem_sel_o(ID_EXE_mem_sel),
    .mem_to_reg_o(ID_EXE_mem_to_reg),
    .reg_write_o(ID_EXE_reg_write),
    .imm_to_reg_o(ID_EXE_imm_to_reg)
  );

  // EXE logic & EXE/MEM regs
  logic EXE_MEM_stall_in, EXE_MEM_bubble_in;
  logic EXE_MEM_stall_out, EXE_MEM_flush_out;
  logic [31:0] EXE_MEM_alu_result;
  logic [31:0] EXE_MEM_rf_rdata_b;
  logic [4:0] EXE_MEM_rd;
  logic [31:0] EXE_MEM_imm;
  logic EXE_MEM_branch, EXE_MEM_mem_read, EXE_MEM_mem_write;
  logic [3:0] EXE_MEM_mem_sel;
  logic EXE_MEM_mem_to_reg, EXE_MEM_reg_write, EXE_MEM_imm_to_reg;
  logic exe_is_load;
  logic [31:0] rdata_from_mem;
  logic [31:0] EXE_MEM_pc_now;
  exe_controller u_exe_controller (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stall_i(EXE_MEM_stall_in),
    .bubble_i(EXE_MEM_bubble_in),
    .stall_o(EXE_MEM_stall_out),
    .flush_o(EXE_MEM_flush_out),
    .alu_op_i(ID_EXE_alu_op),
    .alu_src_i(ID_EXE_alu_src),
    .branch_i(ID_EXE_branch),
    .mem_read_i(ID_EXE_mem_read),
    .mem_write_i(ID_EXE_mem_write),
    .mem_sel_i(ID_EXE_mem_sel),
    .mem_to_reg_i(ID_EXE_mem_to_reg),
    .reg_write_i(ID_EXE_reg_write),
    .imm_to_reg_i(ID_EXE_imm_to_reg),
    .rf_rdata_a_i(ID_EXE_rf_rdata_a),
    .rf_rdata_b_i(ID_EXE_rf_rdata_b),
    .imm_i(ID_EXE_imm),
    .rs1_i(ID_EXE_rs1),
    .rs2_i(ID_EXE_rs2),
    .rd_i(ID_EXE_rd),
    .pc_now_i(ID_EXE_pc_now),

    // forwarding
    .exe_rdata_a_hazard_i(EXE_rdata_a_hazard_out),
    .exe_rdata_b_hazard_i(EXE_rdata_b_hazard_out),
    .mem_rdata_a_hazard_i(MEM_rdata_a_hazard_out),
    .mem_rdata_b_hazard_i(MEM_rdata_b_hazard_out),
    .exe_is_load_o(exe_is_load),
    .rdata_from_mem_i(rdata_from_mem),
    
    .alu_result_o(EXE_MEM_alu_result),
    .rf_rdata_b_o(EXE_MEM_rf_rdata_b),
    .rd_o(EXE_MEM_rd),
    .pc_result_o(EXE_MEM_pc_result),
    .imm_o(EXE_MEM_imm), // for lui
    .pc_now_o(EXE_MEM_pc_now),
    .branch_o(EXE_MEM_branch),
    .mem_read_o(EXE_MEM_mem_read),
    .mem_write_o(EXE_MEM_mem_write),
    .mem_sel_o(EXE_MEM_mem_sel),
    .mem_to_reg_o(EXE_MEM_mem_to_reg),
    .reg_write_o(EXE_MEM_reg_write),
    .imm_to_reg_o(EXE_MEM_imm_to_reg)
  );

  // MEM logic & MEM/WB regs
  logic MEM_WB_stall_in, MEM_WB_bubble_in;
  logic MEM_WB_stall_out, MEM_WB_flush_out;
  logic [31:0] MEM_WB_sram_rdata;
  logic [31:0] MEM_WB_alu_result;
  logic [4:0] MEM_WB_rd;
  logic [31:0] MEM_WB_imm;
  logic MEM_WB_mem_to_reg, MEM_WB_reg_write, MEM_WB_imm_to_reg;
  logic MEM_WB_pc_now;
  mem_controller u_mem_controller (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stall_i(MEM_WB_stall_in),
    .bubble_i(MEM_WB_bubble_in),
    .stall_o(MEM_WB_stall_out), // 1 while wishbone request is pending
    .flush_o(MEM_WB_flush_out), // 0
    .wb_cyc_o(MEM_wb_cyc_o),
    .wb_stb_o(MEM_wb_stb_o),
    .wb_ack_i(MEM_wb_ack_i),
    .wb_adr_o(MEM_wb_adr_o),
    .wb_dat_o(MEM_wb_dat_o),
    .wb_dat_i(MEM_wb_dat_i),
    .wb_sel_o(MEM_wb_sel_o),
    .wb_we_o(MEM_wb_we_o),
    .mem_read_i(EXE_MEM_mem_read),
    .mem_write_i(EXE_MEM_mem_write),
    .mem_sel_i(EXE_MEM_mem_sel),
    .mem_to_reg_i(EXE_MEM_mem_to_reg),
    .reg_write_i(EXE_MEM_reg_write),
    .imm_to_reg_i(EXE_MEM_imm_to_reg),
    .pc_now_i(EXE_MEM_pc_now),
    .alu_result_i(EXE_MEM_alu_result),
    .rf_rdata_b_i(EXE_MEM_rf_rdata_b),
    .rd_i(EXE_MEM_rd),
    .pc_result_i(EXE_MEM_pc_result),
    .imm_i(EXE_MEM_imm), // for lui
    .sram_rdata_o(MEM_WB_sram_rdata),
    .alu_result_o(MEM_WB_alu_result),
    .rd_o(MEM_WB_rd),
    .imm_o(MEM_WB_imm), // for lui
    .pc_now_o(MEM_WB_pc_now),
    .mem_to_reg_o(MEM_WB_mem_to_reg),
    .reg_write_o(MEM_WB_reg_write),
    .imm_to_reg_o(MEM_WB_imm_to_reg),
    .rdata_from_mem_o(rdata_from_mem)
  );

  // WB logic
  logic WB_stall_out, WB_flush_out;
  wb_controller u_wb_controller (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stall_i(1'b0),
    .bubble_i(1'b0),
    .stall_o(WB_stall_out),
    .flush_o(WB_flush_out),

    .mem_to_reg_i(MEM_WB_mem_to_reg),
    .reg_write_i(MEM_WB_reg_write),
    .imm_to_reg_i(MEM_WB_imm_to_reg),
    .sram_rdata_i(MEM_WB_sram_rdata),
    .alu_result_i(MEM_WB_alu_result),
    .rd_i(MEM_WB_rd),
    .imm_i(MEM_WB_imm),
    .pc_now_i(MEM_WB_pc_now),

    .rf_wdata_o(WB_rf_wdata),
    .rf_waddr_o(WB_rf_waddr),
    .rf_we_o(WB_rf_we)
  );


  stall_controller u_stall_controller (
    .if_pending_i(IF_ID_stall_out),
    .mem_pending_i(MEM_WB_stall_out),
    .id_rs1_i(IF_ID_rs1),
    .id_rs2_i(IF_ID_rs2),
    .exe_rd_i(ID_EXE_rd),
    .mem_rd_i(EXE_MEM_rd),
    .exe_branch_i(EXE_MEM_branch),
    .exe_is_load_i(exe_is_load),
    .IF_wb_ack_i(IF_wb_ack_i),
    .MEM_wb_ack_i(MEM_wb_ack_i),

    .stall_if_o(IF_ID_stall_in),
    .bubble_if_o(IF_ID_bubble_in),
    .stall_id_o(ID_EXE_stall_in),
    .bubble_id_o(ID_EXE_bubble_in),
    .stall_exe_o(EXE_MEM_stall_in),
    .bubble_exe_o(EXE_MEM_bubble_in),
    .stall_mem_o(MEM_WB_stall_in),
    .bubble_mem_o(MEM_WB_bubble_in),

    .exe_rdata_a_hazard_o(EXE_rdata_a_hazard_in),
    .exe_rdata_b_hazard_o(EXE_rdata_b_hazard_in),
    .mem_rdata_a_hazard_o(MEM_rdata_a_hazard_in),
    .mem_rdata_b_hazard_o(MEM_rdata_b_hazard_in)
  );

  // always_comb begin    


  // end

  // always_ff @(posedge clk_i) begin
  //   if (rst_i) begin
      
  //   end else begin

  //   end
  // end

endmodule