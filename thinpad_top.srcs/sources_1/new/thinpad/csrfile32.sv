module csrfile32(
  input wire clk,
  input wire reset,

  //csr寄存器的正常读写指令
  input wire[11:0] waddr,
  input wire[31:0] wdata,
  input wire we,
  
  input wire[11:0] raddr,
  output reg[31:0] rdata
//   input wire mtime_exceed_i,
//   output reg time_interupt,
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
  end else if (we) begin
    case(waddr)
      12'h305: mtvec <= wdata;
      12'h340: mscratch <= wdata;
      12'h341: mepc[31:2] <= wdata[31:2];
      12'h342: mcause <= wdata;
      12'h300: mstatus[12:11] <= wdata[12:11];
      12'h304: mie[7] <= wdata[7];
    endcase
  end
end

// always_ff @ (posedge clk) begin
//     if (reset) begin
//         mip <= 0;
//     end else if (mtime_exceed_i) begin
//         mip[7] <= 1;
//     end else begin
//         mip[7] <= 0;
//     end
// end

// always_comb begin
//     if (reset) begin
//         time_interupt = 0;
//     end else if (mip[7] && mie[7]) begin
//         time_interupt = 1;
//     end else begin
//         time_interupt = 0;
//     end
// end

always_comb begin
  case(raddr)
    12'h305: rdata = mtvec;
    12'h340: rdata = mscratch;
    12'h341: rdata = mepc;
    12'h342: rdata = mcause;
    12'h300: rdata = mstatus;  //U
    12'h304: rdata = mie;
    12'h344: rdata = mip;
    default: rdata = 0;
  endcase
end

endmodule