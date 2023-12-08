`timescale 1ns / 1ps
module tb;

  wire clk_50M, clk_11M0592;

  reg push_btn;   // BTN5 按钮�??关，带消抖电路，按下时为 1
  reg reset_btn;  // BTN6 复位按钮，带消抖电路，按下时�?? 1

  reg [3:0] touch_btn; // BTN1~BTN4，按钮开关，按下时为 1
  reg [31:0] dip_sw;   // 32 位拨码开关，拨到“ON”时�?? 1

  wire [15:0] leds;  // 16 �?? LED，输出时 1 点亮
  wire [7:0] dpy0;   // 数码管低位信号，包括小数点，输出 1 点亮
  wire [7:0] dpy1;   // 数码管高位信号，包括小数点，输出 1 点亮

  wire txd;  // 直连串口发�?�端
  wire rxd;  // 直连串口接收�??

  wire [31:0] base_ram_data;  // BaseRAM 数据，低 8 位与 CPLD 串口控制器共�??
  wire [19:0] base_ram_addr;  // BaseRAM 地址
  wire[3:0] base_ram_be_n;    // BaseRAM 字节使能，低有效。如果不使用字节使能，请保持�?? 0
  wire base_ram_ce_n;  // BaseRAM 片�?�，低有�??
  wire base_ram_oe_n;  // BaseRAM 读使能，低有�??
  wire base_ram_we_n;  // BaseRAM 写使能，低有�??

  wire [31:0] ext_ram_data;  // ExtRAM 数据
  wire [19:0] ext_ram_addr;  // ExtRAM 地址
  wire[3:0] ext_ram_be_n;    // ExtRAM 字节使能，低有效。如果不使用字节使能，请保持�?? 0
  wire ext_ram_ce_n;  // ExtRAM 片�?�，低有�??
  wire ext_ram_oe_n;  // ExtRAM 读使能，低有�??
  wire ext_ram_we_n;  // ExtRAM 写使能，低有�??

  wire [22:0] flash_a;  // Flash 地址，a0 仅在 8bit 模式有效�??16bit 模式无意�??
  wire [15:0] flash_d;  // Flash 数据
  wire flash_rp_n;   // Flash 复位信号，低有效
  wire flash_vpen;   // Flash 写保护信号，低电平时不能擦除、烧�??
  wire flash_ce_n;   // Flash 片�?�信号，低有�??
  wire flash_oe_n;   // Flash 读使能信号，低有�??
  wire flash_we_n;   // Flash 写使能信号，低有�??
  wire flash_byte_n; // Flash 8bit 模式选择，低有效。在使用 flash �?? 16 位模式时请设�?? 1

  wire uart_rdn;  // 读串口信号，低有�??
  wire uart_wrn;  // 写串口信号，低有�??
  wire uart_dataready;  // 串口数据准备�??
  wire uart_tbre;  // 发�?�数据标�??
  wire uart_tsre;  // 数据发�?�完毕标�??

  // Windows �??要注意路径分隔符的转义，例如 "D:\\foo\\bar.bin"
  `define DWN "D:\\rv-2023\\asmcode\\lab6.bin"
  `define WJL "D:\\Codefield\\ComputerOrganization\\rv-2023\\asmcode\\kernel-rv32-no16550.bin"
  // parameter BASE_RAM_INIT_FILE = "D:\\Codefield\\ComputerOrganization\\rv-2023\\asmcode\\test.bin"; // BaseRAM 初始化文件，请修改为实际的绝对路�??
  // parameter BASE_RAM_INIT_FILE = "D:\\code\\cod23-grp53\\rvtests_simple\\test19.bin";
  parameter BASE_RAM_INIT_FILE = `WJL; // dwn
  parameter EXT_RAM_INIT_FILE = "/tmp/eram.bin";  // ExtRAM 初始化文件，请修改为实际的绝对路�??
  parameter FLASH_INIT_FILE = "/tmp/kernel.elf";  // Flash 初始化文件，请修改为实际的绝对路�??

  initial begin
    // 在这里可以自定义测试输入序列，例如：
    // dip_sw = 32'h2;
    // touch_btn = 0;
    // reset_btn = 0;
    // push_btn = 0;

    #100;
    reset_btn = 1;
    #100;
    reset_btn = 0;
    // for (integer i = 0; i < 20; i = i + 1) begin
    //   #100;  // 等待 100ns
    //   push_btn = 1;  // 按下 push_btn 按钮
    //   #100;  // 等待 100ns
    //   push_btn = 0;  // 松开 push_btn 按钮
    // end
  
    // // 模拟 PC 通过直连串口，向 FPGA 发�?�字�??
    // uart.pc_send_byte(8'h32); // ASCII '2'
    // #10000;
    // uart.pc_send_byte(8'h33); // ASCII '3'
    #4000000 $finish;
    // #400000 $finish; // dwn
  end

  // 待测试用户设�??
  thinpad_top dut (
      .clk_50M(clk_50M),
      .clk_11M0592(clk_11M0592),
      .push_btn(push_btn),
      .reset_btn(reset_btn),
      .touch_btn(touch_btn),
      .dip_sw(dip_sw),
      .leds(leds),
      .dpy1(dpy1),
      .dpy0(dpy0),
      .txd(txd),
      .rxd(rxd),
      .uart_rdn(uart_rdn),
      .uart_wrn(uart_wrn),
      .uart_dataready(uart_dataready),
      .uart_tbre(uart_tbre),
      .uart_tsre(uart_tsre),
      .base_ram_data(base_ram_data),
      .base_ram_addr(base_ram_addr),
      .base_ram_ce_n(base_ram_ce_n),
      .base_ram_oe_n(base_ram_oe_n),
      .base_ram_we_n(base_ram_we_n),
      .base_ram_be_n(base_ram_be_n),
      .ext_ram_data(ext_ram_data),
      .ext_ram_addr(ext_ram_addr),
      .ext_ram_ce_n(ext_ram_ce_n),
      .ext_ram_oe_n(ext_ram_oe_n),
      .ext_ram_we_n(ext_ram_we_n),
      .ext_ram_be_n(ext_ram_be_n),
      .flash_d(flash_d),
      .flash_a(flash_a),
      .flash_rp_n(flash_rp_n),
      .flash_vpen(flash_vpen),
      .flash_oe_n(flash_oe_n),
      .flash_ce_n(flash_ce_n),
      .flash_byte_n(flash_byte_n),
      .flash_we_n(flash_we_n)
  );
  // 时钟�??
  clock osc (
      .clk_11M0592(clk_11M0592),
      .clk_50M    (clk_50M)
  );
  // CPLD 串口仿真模型
  cpld_model cpld (
      .clk_uart(clk_11M0592),
      .uart_rdn(uart_rdn),
      .uart_wrn(uart_wrn),
      .uart_dataready(uart_dataready),
      .uart_tbre(uart_tbre),
      .uart_tsre(uart_tsre),
      .data(base_ram_data[7:0])
  );
  // 直连串口仿真模型
  uart_model uart (
    .rxd (txd),
    .txd (rxd)
  );
  // BaseRAM 仿真模型
  sram_model base1 (
      .DataIO(base_ram_data[15:0]),
      .Address(base_ram_addr[19:0]),
      .OE_n(base_ram_oe_n),
      .CE_n(base_ram_ce_n),
      .WE_n(base_ram_we_n),
      .LB_n(base_ram_be_n[0]),
      .UB_n(base_ram_be_n[1])
  );
  sram_model base2 (
      .DataIO(base_ram_data[31:16]),
      .Address(base_ram_addr[19:0]),
      .OE_n(base_ram_oe_n),
      .CE_n(base_ram_ce_n),
      .WE_n(base_ram_we_n),
      .LB_n(base_ram_be_n[2]),
      .UB_n(base_ram_be_n[3])
  );
  // ExtRAM 仿真模型
  sram_model ext1 (
      .DataIO(ext_ram_data[15:0]),
      .Address(ext_ram_addr[19:0]),
      .OE_n(ext_ram_oe_n),
      .CE_n(ext_ram_ce_n),
      .WE_n(ext_ram_we_n),
      .LB_n(ext_ram_be_n[0]),
      .UB_n(ext_ram_be_n[1])
  );
  sram_model ext2 (
      .DataIO(ext_ram_data[31:16]),
      .Address(ext_ram_addr[19:0]),
      .OE_n(ext_ram_oe_n),
      .CE_n(ext_ram_ce_n),
      .WE_n(ext_ram_we_n),
      .LB_n(ext_ram_be_n[2]),
      .UB_n(ext_ram_be_n[3])
  );
  // Flash 仿真模型
  x28fxxxp30 #(
      .FILENAME_MEM(FLASH_INIT_FILE)
  ) flash (
      .A   (flash_a[1+:22]),
      .DQ  (flash_d),
      .W_N (flash_we_n),      // Write Enable 
      .G_N (flash_oe_n),      // Output Enable
      .E_N (flash_ce_n),      // Chip Enable
      .L_N (1'b0),            // Latch Enable
      .K   (1'b0),            // Clock
      .WP_N(flash_vpen),      // Write Protect
      .RP_N(flash_rp_n),      // Reset/Power-Down
      .VDD ('d3300),
      .VDDQ('d3300),
      .VPP ('d1800),
      .Info(1'b1)
  );

  initial begin
    wait (flash_byte_n == 1'b0);
    $display("8-bit Flash interface is not supported in simulation!");
    $display("Please tie flash_byte_n to high");
    $stop;
  end

  // 从文件加�?? BaseRAM
  initial begin
    reg [31:0] tmp_array[0:1048575];
    integer n_File_ID, n_Init_Size;
    n_File_ID = $fopen(BASE_RAM_INIT_FILE, "rb");
    if (!n_File_ID) begin
      n_Init_Size = 0;
      $display("Failed to open BaseRAM init file");
    end else begin
      n_Init_Size = $fread(tmp_array, n_File_ID);
      n_Init_Size /= 4;
      $fclose(n_File_ID);
    end
    $display("BaseRAM Init Size(words): %d", n_Init_Size);
    for (integer i = 0; i < n_Init_Size; i++) begin
      base1.mem_array0[i] = tmp_array[i][24+:8];
      base1.mem_array1[i] = tmp_array[i][16+:8];
      base2.mem_array0[i] = tmp_array[i][8+:8];
      base2.mem_array1[i] = tmp_array[i][0+:8];
    end
  end

  // 从文件加�?? ExtRAM
  initial begin
    reg [31:0] tmp_array[0:1048575];
    integer n_File_ID, n_Init_Size;
    n_File_ID = $fopen(EXT_RAM_INIT_FILE, "rb");
    if (!n_File_ID) begin
      n_Init_Size = 0;
      $display("Failed to open ExtRAM init file");
    end else begin
      n_Init_Size = $fread(tmp_array, n_File_ID);
      n_Init_Size /= 4;
      $fclose(n_File_ID);
    end
    $display("ExtRAM Init Size(words): %d", n_Init_Size);
    for (integer i = 0; i < n_Init_Size; i++) begin
      ext1.mem_array0[i] = tmp_array[i][24+:8];
      ext1.mem_array1[i] = tmp_array[i][16+:8];
      ext2.mem_array0[i] = tmp_array[i][8+:8];
      ext2.mem_array1[i] = tmp_array[i][0+:8];
    end
  end
endmodule
