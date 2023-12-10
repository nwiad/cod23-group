module csrfile32(
  input wire clk,
  input wire reset,

  //csr寄存器的正常读写指令   1
  input wire[11:0] waddr_1,
  input wire[31:0] wdata_1,
  input wire we_1,
  
  input wire[11:0] raddr_1,
  output reg[31:0] rdata_1,

  //csr寄存器的正常读写指令   2
  input wire[11:0] waddr_2,
  input wire[31:0] wdata_2,
  input wire we_2,
  
  input wire[11:0] raddr_2,
  output reg[31:0] rdata_2,

  input wire mtime_int_i,
  output reg mtime_int_o,

  output reg [31:0] satp_o
);

// todo:
// reg [31:0] satp; // 0x180

reg [31:0] mtvec;//0x305
reg [31:0] mscratch;//0x340
reg [31:0] mepc;//0x341
reg [31:0] mcause;//0x342
reg [31:0] mstatus;//0x300 MPP[1:0] => 12:11
reg [31:0] mie;//0x304 MTIE：7
reg [31:0] mip;//0x344 MTIP：7
reg [31:0] satp; //0x180 MODE[0] => 31
// Bits mip.MTIP and mie.MTIE are the interrupt-pending and interrupt-enable bits for machine
// timer interrupts. MTIP is read-only in mip, and is cleared by writing to the memory-mapped
// machine-mode timer compare register.

always_ff @ (posedge clk or posedge reset) begin
  if (reset) begin
    mtvec <= 0;
    mscratch <= 0;
    mepc <= 0;
    mcause <= 0; 
    mstatus <= 0;
    mie <= 0;
    satp <= 0;
  end else begin
    if(we_1) begin
      case(waddr_1)
        12'h305: mtvec <= wdata_1;
        12'h340: mscratch <= wdata_1;
        12'h341: mepc[31:2] <= wdata_1[31:2];
        12'h342: mcause <= wdata_1;
        12'h300: mstatus[12:11] <= wdata_1[12:11];
        12'h304: mie[7] <= wdata_1[7];
        12'h180: satp <= wdata_1;
      endcase
    end else if (we_2) begin
      case(waddr_2)
        12'h305: mtvec <= wdata_2;
        12'h340: mscratch <= wdata_2;
        12'h341: mepc[31:2] <= wdata_2[31:2];
        12'h342: mcause <= wdata_2;
        12'h300: mstatus[12:11] <= wdata_2[12:11];
        12'h304: mie[7] <= wdata_2[7];
        12'h180: satp <= wdata_1;
      endcase
    end
  end
end

always_ff @ (posedge clk or posedge reset) begin
  if (reset) begin
    mip <= 0;
  end else begin
    if (mtime_int_i == 1) begin
      mip[7] <= 1;
    end else begin
      mip[7] <= 0;
    end
  end
end

always_comb begin
  if (mip[7] == 1 && mie[7] == 1) begin
    mtime_int_o = 1;
  end else begin
    mtime_int_o = 0;
  end
  satp_o = satp;
end

always_comb begin
  case(raddr_1)
    12'h305: rdata_1 = mtvec;
    12'h340: rdata_1 = mscratch;
    12'h341: rdata_1 = mepc;
    12'h342: rdata_1 = mcause;
    12'h300: rdata_1 = mstatus;  //U
    12'h304: rdata_1 = mie;
    12'h344: rdata_1 = mip;
    12'h180: rdata_1 = satp;
    default: rdata_1 = 0;
  endcase

  case(raddr_2)
    12'h305: rdata_2 = mtvec;
    12'h340: rdata_2 = mscratch;
    12'h341: rdata_2 = mepc;
    12'h342: rdata_2 = mcause;
    12'h300: rdata_2 = mstatus;  //U
    12'h304: rdata_2 = mie;
    12'h344: rdata_2 = mip;
    12'h180: rdata_1 = satp;
    default: rdata_2 = 0;
  endcase
end

endmodule