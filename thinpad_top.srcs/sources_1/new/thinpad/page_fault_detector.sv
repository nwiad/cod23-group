`default_nettype none

module page_fault_detector (
  input wire enable_i,
  input wire [1:0] mode_i,
  input wire [31:0] satp_i,
  input wire is_inst_fetch_i,
  input wire is_load_i,
  input wire is_store_i,
  input wire [31:0] v_addr_i,
  output reg page_fault_o,
  output reg [31:0] mcause_o
);
  typedef enum logic [31:0] {
    INSTRUCTION_PAGE_FAULT = 32'h0000000c,
    LOAD_PAGE_FAULT = 32'h0000000d,
    STORE_PAGE_FAULT = 32'h0000000f,
    NO_PAGE_FAULT = 32'h00000000
  } mcause_t;

  typedef enum logic [1:0] {
    U_MODE = 2'b00,
    M_MODE = 2'b11 // no translation
  } mode_t;

  typedef enum logic { 
    BARE = 0, // no translation
    SV32 = 1 // 32-bit sv32
  } satp_mode_t;

  // serial registers
  `define SERIAL_STATUS 32'h1000_0005
  `define SERIAL_DATA   32'h1000_0000
  // vga memories
  `define MIN_VGA_ADDR 32'h0100_0000
  `define MAX_VGA_ADDR 32'h0107_52FF
  // user code
  `define MIN_USER_CODE_ADDR 32'h00000000
  `define MAX_USER_CODE_ADDR 32'h002FFFFF
  // user data
  `define MIN_USER_DATA_ADDR 32'h7FC10000
  `define MAX_USER_DATA_ADDR 32'h7FFFFFFF
  // kernel code, identity mapped
  `define MIN_KERNEL_CODE_ADDR_1 32'h80000000
  `define MAX_KERNEL_CODE_ADDR_1 32'h80001FFF
  `define MIN_KERNEL_CODE_ADDR_2 32'h80100000
  `define MAX_KERNEL_CODE_ADDR_2 32'h80100FFF
  // otherwise triggers exception
  
  logic satp_mode;
  logic is_serial, is_vga;
  logic user_code, user_data, kernel_code_1, kernel_code_2;
  logic addr_valid_for_mapping, addr_executable, addr_writable;
  logic inst_page_fault, load_page_fault, store_page_fault;

  always_comb begin
    satp_mode = satp_i[31];
    
    is_serial = (v_addr_i == `SERIAL_DATA || v_addr_i == `SERIAL_STATUS);
    is_vga    = (v_addr_i >= `MIN_VGA_ADDR && v_addr_i <= `MAX_VGA_ADDR);
    user_code = (v_addr_i >= `MIN_USER_CODE_ADDR && v_addr_i <= `MAX_USER_CODE_ADDR);
    user_data = (v_addr_i >= `MIN_USER_DATA_ADDR && v_addr_i <= `MAX_USER_DATA_ADDR);
    kernel_code_1 = (v_addr_i >= `MIN_KERNEL_CODE_ADDR_1 && v_addr_i <= `MAX_KERNEL_CODE_ADDR_1);
    kernel_code_2 = (v_addr_i >= `MIN_KERNEL_CODE_ADDR_2 && v_addr_i <= `MAX_KERNEL_CODE_ADDR_2);

    addr_valid_for_mapping = (is_serial || is_vga || user_code || user_data || kernel_code_1 || kernel_code_2);
    addr_executable = (user_code || kernel_code_1 || kernel_code_2);
    addr_writable = user_data || is_vga;

    inst_page_fault  = enable_i && (mode_i == U_MODE) && (satp_mode == SV32) && is_inst_fetch_i && (!addr_valid_for_mapping || !addr_executable);
    load_page_fault  = enable_i && (mode_i == U_MODE) && (satp_mode == SV32) && is_load_i && !addr_valid_for_mapping;
    store_page_fault = enable_i && (mode_i == U_MODE) && (satp_mode == SV32) && is_store_i && (!addr_valid_for_mapping || !addr_writable);
    
    mcause_o     = inst_page_fault ? INSTRUCTION_PAGE_FAULT : ( load_page_fault ? LOAD_PAGE_FAULT : ( store_page_fault ? STORE_PAGE_FAULT : NO_PAGE_FAULT ) );
    page_fault_o = (inst_page_fault || load_page_fault || store_page_fault);
  end
endmodule