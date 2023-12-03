// 根据master提供的信号，控制流水线的暂停和恢复
// 是一个组合逻辑模块

module stall_controller (
  // 模块输入

  input wire if_pending_i,  
  input wire mem_pending_i,

  input wire [4:0] id_rs1_i,    // ID段的两个寄存器
  input wire [4:0] id_rs2_i,
  input wire [4:0] exe_rd_i,    // ID段需要写的寄存器
  input wire [4:0] mem_rd_i,    // MEM段需要写的寄存器
  input wire [4:0] wb_rd_i,     // WB段需要写的寄存器

  input wire exe_branch_i,       // EXE段检测出是否需要跳转
  input wire exe_is_load_i,      // 当前EXE段是否是load指令

  // 还有IF和MEM的ack

  input wire IF_wb_ack_i,
  input wire MEM_wb_ack_i,

  // 模块输出：

  output reg stall_if_o,
  output reg bubble_if_o,

  output reg stall_id_o,
  output reg bubble_id_o,

  output reg stall_exe_o,
  output reg bubble_exe_o,

  output reg stall_mem_o,
  output reg bubble_mem_o,

  // 告诉ID段数据冲突的情况

  output reg exe_rdata_a_hazard_o,
  output reg exe_rdata_b_hazard_o,

  output reg mem_rdata_a_hazard_o,
  output reg mem_rdata_b_hazard_o,

  output reg wb_rdata_a_hazard_o,
  output reg wb_rdata_b_hazard_o

);

logic stall_if_i, flush_if_i;

logic stall_id_i, flush_id_i;

logic stall_exe_i, flush_exe_i;

logic stall_mem_i, flush_mem_i;


always_comb begin
  exe_rdata_a_hazard_o = ((exe_rd_i != 5'b00000) && (id_rs1_i == exe_rd_i));
  exe_rdata_b_hazard_o = ((exe_rd_i != 5'b00000) && (id_rs2_i == exe_rd_i));
  mem_rdata_a_hazard_o = ((mem_rd_i != 5'b00000) && (id_rs1_i == mem_rd_i));
  mem_rdata_b_hazard_o = ((mem_rd_i != 5'b00000) && (id_rs2_i == mem_rd_i));
  wb_rdata_a_hazard_o = ((wb_rd_i != 5'b00000) && (id_rs1_i == wb_rd_i));
  wb_rdata_b_hazard_o = ((wb_rd_i != 5'b00000) && (id_rs2_i == wb_rd_i));
end


always_comb begin
  // IF段还没读完指令，发出stall请求
  if (if_pending_i == 1'b1) begin
    stall_if_i = 1;
    flush_if_i = 0;
  end else begin
    stall_if_i = 0;
    flush_if_i = 0;
  end

  // ID段检测到数据冲突，发出stall_o
  // 需要暂停的数据冲突情况：当前EXE段是load指令，且ID段的两个寄存器中有一个是EXE段需要写的寄存器
  if (exe_is_load_i && ((exe_rd_i != 5'b00000) && (id_rs1_i == exe_rd_i || id_rs2_i == exe_rd_i))) begin
    stall_id_i = 1;
    flush_id_i = 0;
  end else begin
    stall_id_i = 0;
    flush_id_i = 0;
  end

  // EXE段检测到跳转，发出bubble_o
  if (exe_branch_i) begin
    stall_exe_i = 0;
    flush_exe_i = 1;
  end else begin
    stall_exe_i = 0;
    flush_exe_i = 0;
  end

  // MEM还没有完成，发出stall_o
  if (mem_pending_i == 1'b1) begin
    stall_mem_i = 1;
    flush_mem_i = 0;
  end else begin
    stall_mem_i = 0;
    flush_mem_i = 0;
  end
end


always_comb begin
  // 检查if_id段是否需要stall/bubble
  if (flush_exe_i) begin  // 需要首先检查是否flush
    stall_if_o = 0;
    bubble_if_o = 1;
  end else if (IF_wb_ack_i) begin
    stall_if_o = 0;
    bubble_if_o = 0;
  end else if (stall_id_i || stall_mem_i) begin  // ID段检测到数据冲突，或者MEM段还没有完成
    stall_if_o = 1;
    bubble_if_o = 0;
  end else if (stall_if_i) begin  // IF段还没有从wb总线上读到地址，或EXE段检测到跳转
    stall_if_o = 0;
    bubble_if_o = 1;
  end else begin
    stall_if_o = 0;
    bubble_if_o = 1;
  end

  // 检查id_exe段是否需要stall/bubble
  if (stall_id_i || flush_exe_i) begin  // ID段检测到数据冲突，
    stall_id_o = 0;
    bubble_id_o = 1;
  end else if (stall_mem_i) begin  // MEM还没有完成
    stall_id_o = 1;
    bubble_id_o = 0;
  end else begin
    stall_id_o = 0;
    bubble_id_o = 0;
  end

  // 检查exe_mem段是否需要stall/bubble
  if (stall_mem_i) begin
    stall_exe_o = 1;
    bubble_exe_o = 0;
  end else begin
    stall_exe_o = 0;
    bubble_exe_o = 0;
  end

  // 检查mem_wb段是否需要stall/bubble
  if (MEM_wb_ack_i) begin
    stall_mem_o = 0;
    bubble_mem_o = 0;
  end else if (stall_mem_i) begin
    stall_mem_o = 0;
    bubble_mem_o = 1;
  end else begin
    stall_mem_o = 0;
    bubble_mem_o = 0;
  end

end


endmodule