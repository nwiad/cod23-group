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
    output reg MEM_wb_we_o,

    // 时钟中断
    input reg mtime_int_i,

    output reg [31:0] satp_o,

    output reg [1:0] mode_o,

    // sfence
    output reg sfence_o
);
  // exception handler
  logic [1:0] mode;
  always_comb begin
    mode_o = mode;
  end
  logic ID_EXE_is_exception;
  logic [31:0] ID_EXE_exception_cause;

  logic mtime_int_o;

  // csr_file
  logic [11:0] ID_rf_raddr_csr;
  logic [31:0] ID_rf_rdata_csr;
  logic [11:0] ID_rf_waddr_csr;
  logic [31:0] ID_rf_wdata_csr;
  logic ID_rf_we_csr;

  logic [11:0] EXE_rf_raddr_csr;
  logic [31:0] EXE_rf_rdata_csr;
  logic [11:0] EXE_rf_waddr_csr;
  logic [31:0] EXE_rf_wdata_csr;
  logic EXE_rf_we_csr;

  csrfile32 id_csrfile32 (
    .clk(clk_i),
    .reset(rst_i),

    .raddr_1(ID_rf_raddr_csr),
    .rdata_1(ID_rf_rdata_csr),

    .raddr_2(EXE_rf_raddr_csr),
    .rdata_2(EXE_rf_rdata_csr),

    .waddr_1(ID_rf_waddr_csr),
    .wdata_1(ID_rf_wdata_csr),
    .we_1(ID_rf_we_csr),

    .waddr_2(EXE_rf_waddr_csr),
    .wdata_2(EXE_rf_wdata_csr),
    .we_2(EXE_rf_we_csr),

    .mtime_int_i(mtime_int_i),
    .mtime_int_o(mtime_int_o),
    
    .satp_o(satp_o)
  );



  // IF logic & IF/ID regs
  logic IF_ID_stall_in, IF_ID_bubble_in;
  logic IF_ID_stall_out, IF_ID_flush_out;
  logic IF_cache_hit;
  logic [31:0] EXE_MEM_pc_result;
  logic [31:0] IF_ID_inst;
  logic [31:0] IF_ID_pc_now;
  logic [4:0] IF_ID_rs1, IF_ID_rs2;
  logic [31:0] IF_pc_now, IF_pc_predicted;
  logic IF_take_predict_in, IF_take_predict_out;
  logic IF_is_bubble;
  logic IF_ID_inst_page_fault;
  logic [31:0] IF_ID_mcause;
  if_controller u_if_controller (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stall_i(IF_ID_stall_in),
    .bubble_i(IF_ID_bubble_in),
    .stall_o(IF_ID_stall_out), // 1 while wishbone request is pending
    .flush_o(IF_ID_flush_out), // 0
    .cache_hit_o(IF_cache_hit),
    .wb_cyc_o(IF_wb_cyc_o),
    .wb_stb_o(IF_wb_stb_o),
    .wb_ack_i(IF_wb_ack_i),
    .wb_adr_o(IF_wb_adr_o),
    .wb_dat_o(IF_wb_dat_o),
    .wb_dat_i(IF_wb_dat_i),
    .wb_sel_o(IF_wb_sel_o),
    .wb_we_o(IF_wb_we_o),

    .mode_i(mode),
    .satp_i(satp_o),

    .inst_page_fault_o(IF_ID_inst_page_fault),
    .mcause_o(IF_ID_mcause),

    .pc_src_i(EXE_MEM_branch),
    .pc_result_i(pc_result_for_IF),
    .inst_o(IF_ID_inst),
    .pc_now_o(IF_ID_pc_now),
    .rs1_o(IF_ID_rs1),
    .rs2_o(IF_ID_rs2),

    // fence.i
    .clear_icache_i(EXE_MEM_clear_icache),
    .sync_refetch_pc_i(EXD_MEM_sync_refetch_pc),
    .IF_pc_now(IF_pc_now),
    .IF_pc_predicted(IF_pc_predicted),
    .IF_take_predict_i(IF_take_predict_in),
    .IF_take_predict_o(IF_take_predict_out),
    .IF_is_bubble_o(IF_is_bubble)
  );
  
  // ID logic & ID/EXE regs
  logic ID_EXE_stall_in, ID_EXE_bubble_in;
  logic ID_EXE_stall_out, ID_EXE_flush_out;
  logic WB_rf_we;
  logic [4:0] WB_rf_waddr;
  logic [31:0] WB_rf_wdata;
  logic WB_rf_csr_we;
  logic [11:0] WB_rf_csr_waddr;
  logic [31:0] WB_rf_csr_wdata;
  logic [31:0] ID_EXE_rf_rdata_a, ID_EXE_rf_rdata_b, ID_EXE_rf_rdata_c;
  logic [31:0] ID_EXE_imm;
  logic [4:0] ID_EXE_rs1, ID_EXE_rs2, ID_EXE_rd;
  logic [31:0] ID_EXE_pc_now;
  logic [3:0] ID_EXE_alu_op;
  logic ID_EXE_alu_src_1, ID_EXE_alu_src_2;
  logic ID_EXE_mem_read, ID_EXE_mem_write;
  logic [2:0] ID_EXE_branch;
  logic [3:0] ID_EXE_mem_sel;
  logic ID_EXE_mem_to_reg, ID_EXE_reg_write, ID_EXE_imm_to_reg;
  logic ID_EXE_clear_icache;
  //csr
  logic [31:0] ID_EXE_rf_rdata_csr, ID_EXE_rf_rdata_rs1_csr;
  logic [11:0] ID_EXE_rf_raddr_csr;
  logic [4:0] ID_EXE_rf_raddr_rs1_csr;
  logic [1:0] ID_EXE_alu_csr_op;
  logic ID_EXE_reg_to_csr;

  // forwarding
  logic EXE_rdata_a_hazard_in, EXE_rdata_b_hazard_in, MEM_rdata_a_hazard_in, MEM_rdata_b_hazard_in, WB_rdata_a_hazard_in, WB_rdata_b_hazard_in;
  logic EXE_rdata_a_hazard_out, EXE_rdata_b_hazard_out, MEM_rdata_a_hazard_out, MEM_rdata_b_hazard_out, WB_rdata_a_hazard_out, WB_rdata_b_hazard_out;
  logic ID_is_branch, ID_is_jalr;
  logic [31:0] ID_pc_now, ID_imm;

  // csr
  logic EXE_csr_hazard_in, MEM_csr_hazard_in, WB_csr_hazard_in;
  logic EXE_csr_hazard_out, MEM_csr_hazard_out, WB_csr_hazard_out;
  logic [11:0] ID_csr;

  logic ID_EXE_inst_page_fault;
  logic [31:0] ID_EXE_mcause;

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
    
    .inst_page_fault_i(IF_ID_inst_page_fault),
    .mcause_i(IF_ID_mcause),
    .inst_page_fault_o(ID_EXE_inst_page_fault),
    .mcause_o(ID_EXE_mcause),

    .rf_rdata_a_o(ID_EXE_rf_rdata_a),
    .rf_rdata_b_o(ID_EXE_rf_rdata_b),
    .rf_rdata_c_o(ID_EXE_rf_rdata_c),
    .imm_o(ID_EXE_imm),
    .rs1_o(ID_EXE_rs1),
    .rs2_o(ID_EXE_rs2),
    .rd_o(ID_EXE_rd),
    .pc_now_o(ID_EXE_pc_now),
    .alu_op_o(ID_EXE_alu_op),
    .alu_src_o_1(ID_EXE_alu_src_1),
    .alu_src_o_2(ID_EXE_alu_src_2),

    //csr
    .ID_csr_o(ID_csr),
    .rf_we_csr_i(WB_rf_csr_we),
    .rf_waddr_csr_i(WB_rf_csr_waddr),
    .rf_wdata_csr_i(WB_rf_csr_wdata),
    .rf_rdata_csr_o(ID_EXE_rf_rdata_csr),
    .rf_raddr_csr_o(ID_EXE_rf_raddr_csr),
    .rf_rdata_rs1_csr_o(ID_EXE_rf_rdata_rs1_csr),
    .rf_raddr_rs1_csr_o(ID_EXE_rf_raddr_rs1_csr),
    .alu_csr_op(ID_EXE_alu_csr_op),

    //exception
    .mode_i(mode),
    .is_exception_o(ID_EXE_is_exception),
    .exception_cause_o(ID_EXE_exception_cause),

    // forwarding
    .exe_rdata_a_hazard_i(EXE_rdata_a_hazard_in),
    .exe_rdata_b_hazard_i(EXE_rdata_b_hazard_in),
    .mem_rdata_a_hazard_i(MEM_rdata_a_hazard_in),
    .mem_rdata_b_hazard_i(MEM_rdata_b_hazard_in),
    .wb_rdata_a_hazard_i(WB_rdata_a_hazard_in),
    .wb_rdata_b_hazard_i(WB_rdata_b_hazard_in),

    .exe_rdata_a_hazard_o(EXE_rdata_a_hazard_out),
    .exe_rdata_b_hazard_o(EXE_rdata_b_hazard_out),
    .mem_rdata_a_hazard_o(MEM_rdata_a_hazard_out),
    .mem_rdata_b_hazard_o(MEM_rdata_b_hazard_out),
    .wb_rdata_a_hazard_o(WB_rdata_a_hazard_out),
    .wb_rdata_b_hazard_o(WB_rdata_b_hazard_out),

    .exe_csr_hazard_i(EXE_csr_hazard_in),
    .mem_csr_hazard_i(MEM_csr_hazard_in),
    .wb_csr_hazard_i(WB_csr_hazard_in),

    .exe_csr_hazard_o(EXE_csr_hazard_out),
    .mem_csr_hazard_o(MEM_csr_hazard_out),
    .wb_csr_hazard_o(WB_csr_hazard_out),


    .branch_o(ID_EXE_branch),
    .mem_read_o(ID_EXE_mem_read),
    .mem_write_o(ID_EXE_mem_write),
    .mem_sel_o(ID_EXE_mem_sel),
    .mem_to_reg_o(ID_EXE_mem_to_reg),
    .reg_write_o(ID_EXE_reg_write),
    .imm_to_reg_o(ID_EXE_imm_to_reg),
    .csr_write_o(ID_EXE_reg_to_csr),

    // fence.i
    .clear_icache_o(ID_EXE_clear_icache),
    .ID_is_branch_o(ID_is_branch),
    .ID_is_jalr_o(ID_is_jalr),
    .ID_pc_now_o(ID_pc_now),
    .ID_imm_o(ID_imm),

    // csr file
    .rf_raddr_csr(ID_rf_raddr_csr),
    .rf_rdata_csr(ID_rf_rdata_csr),
    .rf_waddr_csr(ID_rf_waddr_csr),
    .rf_wdata_csr(ID_rf_wdata_csr),
    .rf_we_csr(ID_rf_we_csr),

    .sfence_o(sfence_o)
  );

  // EXE logic & EXE/MEM regs
  logic EXE_MEM_stall_in, EXE_MEM_bubble_in;
  logic EXE_MEM_stall_out, EXE_MEM_flush_out;
  logic [31:0] EXE_MEM_alu_result;
  logic [31:0] EXE_MEM_rf_rdata_b;
  logic [4:0] EXE_MEM_rd;
  logic [31:0] EXE_MEM_imm;
  logic EXE_MEM_mem_read, EXE_MEM_mem_write;
  logic EXE_MEM_branch;
  logic [3:0] EXE_MEM_mem_sel;
  logic EXE_MEM_mem_to_reg, EXE_MEM_reg_write, EXE_MEM_imm_to_reg;
  logic exe_is_load;
  logic [31:0] rdata_from_mem;
  logic [31:0] rdata_from_wb;
  logic [31:0] csr_from_mem;
  logic [31:0] csr_from_wb;
  logic [31:0] EXE_MEM_pc_now;
  logic EXE_MEM_clear_icache;
  logic [31:0] EXD_MEM_sync_refetch_pc;
  logic EXE_is_branch, branch_eq;
  logic [31:0] EXE_pc_result_comb;
  logic [31:0] pc_result_for_IF;

  //csr
  logic [11:0] EXE_csr;
  logic EXE_MEM_reg_to_csr;
  logic [31:0] EXE_MEM_alu_result_csr;
  logic [11:0] EXE_MEM_rd_csr;
  logic EXE_handling_exception;

  exe_controller u_exe_controller (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .stall_i(EXE_MEM_stall_in),
    .bubble_i(EXE_MEM_bubble_in),
    .stall_o(EXE_MEM_stall_out),
    .flush_o(EXE_MEM_flush_out),

    .mode_i(mode),
    .satp_i(satp_o),

    .inst_page_fault_i(ID_EXE_inst_page_fault),
    .inst_mcause_i(ID_EXE_mcause),

    .alu_op_i(ID_EXE_alu_op),
    .alu_src_i_1(ID_EXE_alu_src_1),
    .alu_src_i_2(ID_EXE_alu_src_2),
    .branch_i(ID_EXE_branch),
    .mem_read_i(ID_EXE_mem_read),
    .mem_write_i(ID_EXE_mem_write),
    .mem_sel_i(ID_EXE_mem_sel),
    .mem_to_reg_i(ID_EXE_mem_to_reg),
    .reg_write_i(ID_EXE_reg_write),
    .reg_to_csr_i(ID_EXE_reg_to_csr),
    .imm_to_reg_i(ID_EXE_imm_to_reg),
    .rf_rdata_a_i(ID_EXE_rf_rdata_a),
    .rf_rdata_b_i(ID_EXE_rf_rdata_b),
    .rf_rdata_c_i(ID_EXE_rf_rdata_c),
    .imm_i(ID_EXE_imm),
    .rs1_i(ID_EXE_rs1),
    .rs2_i(ID_EXE_rs2),
    .rd_i(ID_EXE_rd),
    .pc_now_i(ID_EXE_pc_now),

    // csr
    .rf_rdata_csr_i(ID_EXE_rf_rdata_csr),
    .rf_raddr_csr_i(ID_EXE_rf_raddr_csr),
    .rf_rdata_rs1_csr_i(ID_EXE_rf_rdata_rs1_csr),
    .rf_raddr_rs1_csr_i(ID_EXE_rf_raddr_rs1_csr),
    .alu_csr_op_i(ID_EXE_alu_csr_op),

    .alu_result_csr_o(EXE_MEM_alu_result_csr),
    .rd_csr_o(EXE_MEM_rd_csr),

    //exception
    .mode_o(mode),
    .is_exception_i(ID_EXE_is_exception),
    .exception_cause_i(ID_EXE_exception_cause),
    .handling_exception_o(EXE_handling_exception),
    .mtime_int(mtime_int_o),

    // forwarding
    .exe_rdata_a_hazard_i(EXE_rdata_a_hazard_out),
    .exe_rdata_b_hazard_i(EXE_rdata_b_hazard_out),
    .mem_rdata_a_hazard_i(MEM_rdata_a_hazard_out),
    .mem_rdata_b_hazard_i(MEM_rdata_b_hazard_out),
    .wb_rdata_a_hazard_i(WB_rdata_a_hazard_out),
    .wb_rdata_b_hazard_i(WB_rdata_b_hazard_out),
    .exe_csr_hazard_i(EXE_csr_hazard_out),
    .mem_csr_hazard_i(MEM_csr_hazard_out),
    .wb_csr_hazard_i(WB_csr_hazard_out),

    .exe_is_load_o(exe_is_load),
    .EXE_csr_o(EXE_csr),
    .rdata_from_mem_i(rdata_from_mem),
    .rdata_from_wb_i(rdata_from_wb),
    .csr_from_mem_i(csr_from_mem),
    .csr_from_wb_i(csr_from_wb),
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
    .imm_to_reg_o(EXE_MEM_imm_to_reg),
    .reg_to_csr_o(EXE_MEM_reg_to_csr),

    // fence.i
    .clear_icache_i(ID_EXE_clear_icache),
    .clear_icache_o(EXE_MEM_clear_icache),
    .sync_refetch_pc_o(EXD_MEM_sync_refetch_pc),
    .ID_take_predict_i(IF_take_predict_out),
    .EXE_is_branch_o(EXE_is_branch),
    .branch_eq_o(branch_eq),
    .pc_result_comb_o(EXE_pc_result_comb),
    .pc_result_for_IF_o(pc_result_for_IF),

    // csr file
    .rf_raddr_csr(EXE_rf_raddr_csr),
    .rf_rdata_csr(EXE_rf_rdata_csr),
    .rf_waddr_csr(EXE_rf_waddr_csr),
    .rf_wdata_csr(EXE_rf_wdata_csr),
    .rf_we_csr(EXE_rf_we_csr)
  );

  // MEM logic & MEM/WB regs
  logic MEM_WB_stall_in, MEM_WB_bubble_in;
  logic MEM_WB_stall_out, MEM_WB_flush_out;
  logic [31:0] MEM_WB_sram_rdata;
  logic [31:0] MEM_WB_alu_result;
  logic [4:0] MEM_WB_rd;
  logic [31:0] MEM_WB_imm;
  logic MEM_WB_mem_to_reg, MEM_WB_reg_write, MEM_WB_imm_to_reg;
  logic [31:0] MEM_WB_pc_now;

  //csr
  logic [11:0] MEM_csr;
  logic MEM_WB_reg_to_csr;
  logic [31:0] MEM_WB_alu_result_csr;
  logic [11:0] MEM_WB_rd_csr;

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

    //csr
    .alu_result_csr_i(EXE_MEM_alu_result_csr),
    .rd_csr_i(EXE_MEM_rd_csr),
    .alu_result_csr_o(MEM_WB_alu_result_csr),
    .rd_csr_o(MEM_WB_rd_csr),

    .mem_read_i(EXE_MEM_mem_read),
    .mem_write_i(EXE_MEM_mem_write),
    .mem_sel_i(EXE_MEM_mem_sel),
    .mem_to_reg_i(EXE_MEM_mem_to_reg),
    .reg_write_i(EXE_MEM_reg_write),
    .imm_to_reg_i(EXE_MEM_imm_to_reg),
    .reg_to_csr_i(EXE_MEM_reg_to_csr),
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
    .reg_to_csr_o(MEM_WB_reg_to_csr),
    .rdata_from_mem_o(rdata_from_mem),
    .MEM_csr_o(MEM_csr),
    .csr_from_mem_o(csr_from_mem)
  );

  // WB logic
  logic WB_stall_in, WB_bubble_in;
  logic WB_stall_out, WB_flush_out;
  logic [11:0] WB_csr;
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
    .rdata_from_wb_o(rdata_from_wb),
    .rd_i(MEM_WB_rd),
    .imm_i(MEM_WB_imm),
    .pc_now_i(MEM_WB_pc_now),

    //csr
    .rf_we_csr_o(WB_rf_csr_we),
    .rf_waddr_csr_o(WB_rf_csr_waddr),
    .rf_wdata_csr_o(WB_rf_csr_wdata),
    .csr_from_wb_o(csr_from_wb),
    .WB_csr_o(WB_csr),

    .alu_result_csr_i(MEM_WB_alu_result_csr),
    .rd_csr_i(MEM_WB_rd_csr),
    .reg_to_csr_i(MEM_WB_reg_to_csr),

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
    .wb_rd_i(MEM_WB_rd),

    .id_csr_i(ID_csr),
    .exe_csr_i(EXE_csr),
    .mem_csr_i(MEM_csr),
    .wb_csr_i(WB_csr),

    .exe_handling_exception_i(EXE_handling_exception),

    .exe_branch_i(EXE_MEM_flush_out),
    .exe_is_load_i(exe_is_load),
    .IF_wb_ack_i(IF_wb_ack_i),
    .IF_cache_hit_i(IF_cache_hit),
    .MEM_wb_ack_i(MEM_wb_ack_i),

    .stall_if_o(IF_ID_stall_in),
    .bubble_if_o(IF_ID_bubble_in),
    .stall_id_o(ID_EXE_stall_in),
    .bubble_id_o(ID_EXE_bubble_in),
    .stall_exe_o(EXE_MEM_stall_in),
    .bubble_exe_o(EXE_MEM_bubble_in),
    .stall_mem_o(MEM_WB_stall_in),
    .bubble_mem_o(MEM_WB_bubble_in),
    .stall_wb_o(WB_stall_in),
    .bubble_wb_o(WB_bubble_in),

    .exe_rdata_a_hazard_o(EXE_rdata_a_hazard_in),
    .exe_rdata_b_hazard_o(EXE_rdata_b_hazard_in),
    .mem_rdata_a_hazard_o(MEM_rdata_a_hazard_in),
    .mem_rdata_b_hazard_o(MEM_rdata_b_hazard_in),
    .wb_rdata_a_hazard_o(WB_rdata_a_hazard_in),
    .wb_rdata_b_hazard_o(WB_rdata_b_hazard_in),

    .exe_csr_hazard_o(EXE_csr_hazard_in),
    .mem_csr_hazard_o(MEM_csr_hazard_in),
    .wb_csr_hazard_o(WB_csr_hazard_in)
  );


  branch_predictor u_branch_predictor (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .ID_pc_i(ID_pc_now),
    .ID_is_branch_i(ID_is_branch),
    .ID_is_jalr_i(ID_is_jalr),
    .ID_imm_i(ID_imm),
    .IF_pc_i(IF_pc_now),
    .EXE_pc_i(ID_EXE_pc_now),
    .EXE_is_branch_i(EXE_is_branch),
    .EXE_need_branch_i(branch_eq),
    .EXE_pc_result_i(EXE_pc_result_comb),
    .ID_is_bubble_i(IF_is_bubble),
    .IF_pc_o(IF_pc_predicted),
    .IF_take_predict_o(IF_take_predict_in)
  );

endmodule
