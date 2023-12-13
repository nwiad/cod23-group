`default_nettype none

module thinpad_top (
    input wire clk_50M,     // 50MHz 时钟输入
    input wire clk_11M0592, // 11.0592MHz 时钟输入（备用，可不用）

    input wire push_btn,  // BTN5 按钮开关，带消抖电路，按下时为 1
    input wire reset_btn, // BTN6 复位按钮，带消抖电路，按下时为 1

    input  wire [ 3:0] touch_btn,  // BTN1~BTN4，按钮开关，按下时为 1
    input  wire [31:0] dip_sw,     // 32 位拨码开关，拨到“ON”时为 1
    output wire [15:0] leds,       // 16 位 LED，输出时 1 点亮
    output wire [ 7:0] dpy0,       // 数码管低位信号，包括小数点，输出 1 点亮
    output wire [ 7:0] dpy1,       // 数码管高位信号，包括小数点，输出 1 点亮

    // CPLD 串口控制器信号
    output wire uart_rdn,        // 读串口信号，低有效
    output wire uart_wrn,        // 写串口信号，低有效
    input  wire uart_dataready,  // 串口数据准备好
    input  wire uart_tbre,       // 发送数据标志
    input  wire uart_tsre,       // 数据发送完毕标志

    // BaseRAM 信号
    inout wire [31:0] base_ram_data,  // BaseRAM 数据，低 8 位与 CPLD 串口控制器共享
    output wire [19:0] base_ram_addr,  // BaseRAM 地址
    output wire [3:0] base_ram_be_n,  // BaseRAM 字节使能，低有效。如果不使用字节使能，请保持为 0
    output wire base_ram_ce_n,  // BaseRAM 片选，低有效
    output wire base_ram_oe_n,  // BaseRAM 读使能，低有效
    output wire base_ram_we_n,  // BaseRAM 写使能，低有效

    // ExtRAM 信号
    inout wire [31:0] ext_ram_data,  // ExtRAM 数据
    output wire [19:0] ext_ram_addr,  // ExtRAM 地址
    output wire [3:0] ext_ram_be_n,  // ExtRAM 字节使能，低有效。如果不使用字节使能，请保持为 0
    output wire ext_ram_ce_n,  // ExtRAM 片选，低有效
    output wire ext_ram_oe_n,  // ExtRAM 读使能，低有效
    output wire ext_ram_we_n,  // ExtRAM 写使能，低有效

    // 直连串口信号
    output wire txd,  // 直连串口发送端
    input  wire rxd,  // 直连串口接收端

    // Flash 存储器信号，参考 JS28F640 芯片手册
    output wire [22:0] flash_a,  // Flash 地址，a0 仅在 8bit 模式有效，16bit 模式无意义
    inout wire [15:0] flash_d,  // Flash 数据
    output wire flash_rp_n,  // Flash 复位信号，低有效
    output wire flash_vpen,  // Flash 写保护信号，低电平时不能擦除、烧写
    output wire flash_ce_n,  // Flash 片选信号，低有效
    output wire flash_oe_n,  // Flash 读使能信号，低有效
    output wire flash_we_n,  // Flash 写使能信号，低有效
    output wire flash_byte_n, // Flash 8bit 模式选择，低有效。在使用 flash 的 16 位模式时请设为 1

    // USB 控制器信号，参考 SL811 芯片手册
    output wire sl811_a0,
    // inout  wire [7:0] sl811_d,     // USB 数据线与网络控制器的 dm9k_sd[7:0] 共享
    output wire sl811_wr_n,
    output wire sl811_rd_n,
    output wire sl811_cs_n,
    output wire sl811_rst_n,
    output wire sl811_dack_n,
    input  wire sl811_intrq,
    input  wire sl811_drq_n,

    // 网络控制器信号，参考 DM9000A 芯片手册
    output wire dm9k_cmd,
    inout wire [15:0] dm9k_sd,
    output wire dm9k_iow_n,
    output wire dm9k_ior_n,
    output wire dm9k_cs_n,
    output wire dm9k_pwrst_n,
    input wire dm9k_int,

    // 图像输出信号
    output wire [2:0] video_red,    // 红色像素，3 位
    output wire [2:0] video_green,  // 绿色像素，3 位
    output wire [1:0] video_blue,   // 蓝色像素，2 位
    output wire       video_hsync,  // 行同步（水平同步）信号
    output wire       video_vsync,  // 场同步（垂直同步）信号
    output wire       video_clk,    // 像素时钟输出
    output wire       video_de      // 行数据有效信号，用于区分消隐区
);

  /* =========== Demo code begin =========== */

  // PLL 分频示例
  logic locked, clk_10M, clk_100M;
  pll_example clock_gen (
      // Clock in ports
      .clk_in1(clk_50M),  // 外部时钟输入
      // Clock out ports
      .clk_out1(clk_10M),  // 时钟输出 1，频率在 IP 配置界面中设置
      .clk_out2(clk_100M),  // 时钟输出 2，频率在 IP 配置界面中设置
      // Status and control signals
      .reset(reset_btn),  // PLL 复位输入
      .locked(locked)  // PLL 锁定指示输出，"1"表示时钟稳定，
                       // 后级电路复位信号应当由它生成（见下）
  );

  logic reset_of_clk10M;
  logic reset_of_clk50M;
  logic reset_of_clk100M;
  // 异步复位，同步释放，将 locked 信号转为后级电路的复位 reset_of_clk10M
  always_ff @(posedge clk_10M or negedge locked) begin
    if (~locked) reset_of_clk10M <= 1'b1;
    else reset_of_clk10M <= 1'b0;
  end

  // 异步复位，同步释放，将 locked 信号转为后级电路的复位 reset_of_clk10M
  always_ff @(posedge clk_50M or negedge locked) begin
    if (~locked) reset_of_clk50M <= 1'b1;
    else reset_of_clk50M <= 1'b0;
  end

  // 异步复位，同步释放，将 locked 信号转为后级电路的复位 reset_of_clk10M
  always_ff @(posedge clk_100M or negedge locked) begin
    if (~locked) reset_of_clk100M <= 1'b1;
    else reset_of_clk100M <= 1'b0;
  end

  /* =========== Demo code end =========== */

  logic sys_clk;
  logic sys_rst;

  // 是否超时信号
  logic mtime_int;

  assign sys_clk = clk_100M;
  assign sys_rst = reset_of_clk100M;

  // 本实验不使用 CPLD 串口，禁用防止总线冲突
  assign uart_rdn = 1'b1;
  assign uart_wrn = 1'b1;

  /* =========== Master begin =========== */
  logic IF_wbm_cyc_o;
  logic IF_wbm_stb_o;
  logic IF_wbm_ack_i;
  logic [31:0] IF_wbm_adr_o;
  logic [31:0] IF_wbm_dat_o;
  logic [31:0] IF_wbm_dat_i;
  logic [ 3:0] IF_wbm_sel_o;
  logic IF_wbm_we_o;

  logic MEM_wbm_cyc_o;
  logic MEM_wbm_stb_o;
  logic MEM_wbm_ack_i;
  logic [31:0] MEM_wbm_adr_o;
  logic [31:0] MEM_wbm_dat_o;
  logic [31:0] MEM_wbm_dat_i;
  logic [ 3:0] MEM_wbm_sel_o;
  logic MEM_wbm_we_o;

  logic [31:0] satp;

  logic [1:0] mode;

  logic sfence;

  thinpad_master #(
      .ADDR_WIDTH(32),
      .DATA_WIDTH(32)
  ) u_thinpad_master (
      .clk_i(sys_clk),
      .rst_i(sys_rst),

      // wishbone master for IF
      .IF_wb_cyc_o(IF_wbm_cyc_o),
      .IF_wb_stb_o(IF_wbm_stb_o),
      .IF_wb_ack_i(IF_wbm_ack_i),
      .IF_wb_adr_o(IF_wbm_adr_o),
      .IF_wb_dat_o(IF_wbm_dat_o),
      .IF_wb_dat_i(IF_wbm_dat_i),
      .IF_wb_sel_o(IF_wbm_sel_o),
      .IF_wb_we_o(IF_wbm_we_o),

      // wishbone master for MEM
      .MEM_wb_cyc_o(MEM_wbm_cyc_o),
      .MEM_wb_stb_o(MEM_wbm_stb_o),
      .MEM_wb_ack_i(MEM_wbm_ack_i),
      .MEM_wb_adr_o(MEM_wbm_adr_o),
      .MEM_wb_dat_o(MEM_wbm_dat_o),
      .MEM_wb_dat_i(MEM_wbm_dat_i),
      .MEM_wb_sel_o(MEM_wbm_sel_o),
      .MEM_wb_we_o(MEM_wbm_we_o),

      .mtime_int_i(mtime_int),

      .satp_o(satp),

      .mode_o(mode),

      .sfence_o(sfence)
  );

  /* =========== Master end =========== */

  /* =========== Arbiter begin =========== */
  logic        wbm_cyc_o;
  logic        wbm_stb_o;
  logic        wbm_ack_i;
  logic [31:0] wbm_adr_o;
  logic [31:0] wbm_dat_o;
  logic [31:0] wbm_dat_i;
  logic [ 3:0] wbm_sel_o;
  logic        wbm_we_o;
  wb_arbiter_2 u_wb_arbiter_2 (
    .clk(sys_clk),
    .rst(sys_rst),

    // Master interface (to Lab6 master)
    .wbm0_adr_i(IF_wbm_adr_o),
    .wbm0_dat_i(IF_wbm_dat_o),
    .wbm0_dat_o(IF_wbm_dat_i),
    .wbm0_we_i (IF_wbm_we_o),
    .wbm0_sel_i(IF_wbm_sel_o),
    .wbm0_stb_i(IF_wbm_stb_o),
    .wbm0_ack_o(IF_wbm_ack_i),
    .wbm0_err_o(),
    .wbm0_rty_o(),
    .wbm0_cyc_i(IF_wbm_cyc_o),

    .wbm1_adr_i(MEM_wbm_adr_o),
    .wbm1_dat_i(MEM_wbm_dat_o),
    .wbm1_dat_o(MEM_wbm_dat_i),
    .wbm1_we_i (MEM_wbm_we_o),
    .wbm1_sel_i(MEM_wbm_sel_o),
    .wbm1_stb_i(MEM_wbm_stb_o),
    .wbm1_ack_o(MEM_wbm_ack_i),
    .wbm1_err_o(),
    .wbm1_rty_o(),
    .wbm1_cyc_i(MEM_wbm_cyc_o),

    // Slave interface (to address map)
    .wbs_cyc_o(wbm_cyc_o),
    .wbs_dat_i(wbm_dat_i),
    .wbs_dat_o(wbm_dat_o),
    .wbs_we_o (wbm_we_o),
    .wbs_sel_o(wbm_sel_o),
    .wbs_stb_o(wbm_stb_o),
    .wbs_ack_i(wbm_ack_i),
    .wbs_err_i('0),
    .wbs_rty_i('0),
    .wbs_adr_o(wbm_adr_o)
  );
  /* =========== Arbiter end =========== */

  /* =========== Address Map begin =========== */
  logic mapped_cyc_o;
  logic mapped_stb_o;
  logic mapped_ack_i;
  logic [31:0] mapped_adr_o;
  logic [31:0] mapped_dat_o;
  logic [31:0] mapped_dat_i;
  logic [ 3:0] mapped_sel_o;
  logic mapped_we_o;

//   logic page_fault;

  address_map u_address_map (
    .clk_i(sys_clk),
    .rst_i(sys_rst),

    // from arbiter
    .v_wb_cyc_i(wbm_cyc_o),
    .v_wb_stb_i(wbm_stb_o),
    .v_wb_ack_o(wbm_ack_i),
    .v_wb_adr_i(wbm_adr_o),
    .v_wb_dat_i(wbm_dat_o),
    .v_wb_dat_o(wbm_dat_i),
    .v_wb_sel_i(wbm_sel_o),
    .v_wb_we_i (wbm_we_o),

    // to MUX
    .wb_cyc_o(mapped_cyc_o),
    .wb_stb_o(mapped_stb_o),
    .wb_ack_i(mapped_ack_i),
    .wb_adr_o(mapped_adr_o),
    .wb_dat_o(mapped_dat_o),
    .wb_dat_i(mapped_dat_i),
    .wb_sel_o(mapped_sel_o),
    .wb_we_o (mapped_we_o),

    // satp
    .satp_i(satp),

    // mode
    .mode_i(mode),

    // sfence.vma
    .sfence_i(sfence)
  );
  /* =========== Address Map end =========== */

  /* =========== MUX begin =========== */
  logic wbs0_cyc_o;
  logic wbs0_stb_o;
  logic wbs0_ack_i;
  logic [31:0] wbs0_adr_o;
  logic [31:0] wbs0_dat_o;
  logic [31:0] wbs0_dat_i;
  logic [3:0] wbs0_sel_o;
  logic wbs0_we_o;

  logic wbs1_cyc_o;
  logic wbs1_stb_o;
  logic wbs1_ack_i;
  logic [31:0] wbs1_adr_o;
  logic [31:0] wbs1_dat_o;
  logic [31:0] wbs1_dat_i;
  logic [3:0] wbs1_sel_o;
  logic wbs1_we_o;

  logic wbs2_cyc_o;
  logic wbs2_stb_o;
  logic wbs2_ack_i;
  logic [31:0] wbs2_adr_o;
  logic [31:0] wbs2_dat_o;
  logic [31:0] wbs2_dat_i;
  logic [3:0] wbs2_sel_o;
  logic wbs2_we_o;

  logic wbs3_cyc_o;
  logic wbs3_stb_o;
  logic wbs3_ack_i;
  logic [31:0] wbs3_adr_o;
  logic [31:0] wbs3_dat_o;
  logic [31:0] wbs3_dat_i;
  logic [3:0] wbs3_sel_o;
  logic wbs3_we_o;

  logic wbs4_cyc_o;
  logic wbs4_stb_o;
  logic wbs4_ack_i;
  logic [31:0] wbs4_adr_o;
  logic [31:0] wbs4_dat_o;
  logic [31:0] wbs4_dat_i;
  logic [3:0] wbs4_sel_o;
  logic wbs4_we_o;

  wb_mux_3 wb_mux (
      .clk(sys_clk),
      .rst(sys_rst),

      // Master interface (to address map)
      .wbm_adr_i(mapped_adr_o),
      .wbm_dat_i(mapped_dat_o),
      .wbm_dat_o(mapped_dat_i),
      .wbm_we_i (mapped_we_o),
      .wbm_sel_i(mapped_sel_o),
      .wbm_stb_i(mapped_stb_o),
      .wbm_ack_o(mapped_ack_i),
      .wbm_err_o(),
      .wbm_rty_o(),
      .wbm_cyc_i(mapped_cyc_o),

      // Slave interface 0 (to BaseRAM controller)
      // Address range: 0x8000_0000 ~ 0x803F_FFFF
      .wbs0_addr    (32'h8000_0000),
      .wbs0_addr_msk(32'hFFC0_0000),

      .wbs0_adr_o(wbs0_adr_o),
      .wbs0_dat_i(wbs0_dat_i),
      .wbs0_dat_o(wbs0_dat_o),
      .wbs0_we_o (wbs0_we_o),
      .wbs0_sel_o(wbs0_sel_o),
      .wbs0_stb_o(wbs0_stb_o),
      .wbs0_ack_i(wbs0_ack_i),
      .wbs0_err_i('0),
      .wbs0_rty_i('0),
      .wbs0_cyc_o(wbs0_cyc_o),

      // Slave interface 1 (to ExtRAM controller)
      // Address range: 0x8040_0000 ~ 0x807F_FFFF
      .wbs1_addr    (32'h8040_0000),
      .wbs1_addr_msk(32'hFFC0_0000),

      .wbs1_adr_o(wbs1_adr_o),
      .wbs1_dat_i(wbs1_dat_i),
      .wbs1_dat_o(wbs1_dat_o),
      .wbs1_we_o (wbs1_we_o),
      .wbs1_sel_o(wbs1_sel_o),
      .wbs1_stb_o(wbs1_stb_o),
      .wbs1_ack_i(wbs1_ack_i),
      .wbs1_err_i('0),
      .wbs1_rty_i('0),
      .wbs1_cyc_o(wbs1_cyc_o),

      // Slave interface 2 (to UART controller)
      // Address range: 0x1000_0000 ~ 0x1000_FFFF
      .wbs2_addr    (32'h1000_0000),
      .wbs2_addr_msk(32'hFFFF_0000),

      .wbs2_adr_o(wbs2_adr_o),
      .wbs2_dat_i(wbs2_dat_i),
      .wbs2_dat_o(wbs2_dat_o),
      .wbs2_we_o (wbs2_we_o),
      .wbs2_sel_o(wbs2_sel_o),
      .wbs2_stb_o(wbs2_stb_o),
      .wbs2_ack_i(wbs2_ack_i),
      .wbs2_err_i('0),
      .wbs2_rty_i('0),
      .wbs2_cyc_o(wbs2_cyc_o),

      // Slave interface 3 (to Mtime controller)
      // Address range: 0x0200_0000 ~ 0x0200_FFFF
      // #define CLINT 0x2000000
      // #define CLINT_MTIME (CLINT + 0xBFF8)
      // #define CLINT_MTIMECMP (CLINT + 0x4000)
      .wbs3_addr    (32'h0200_0000),
      .wbs3_addr_msk(32'hFFFF_0000),

      .wbs3_adr_o(wbs3_adr_o),
      .wbs3_dat_i(wbs3_dat_i),
      .wbs3_dat_o(wbs3_dat_o),
      .wbs3_we_o (wbs3_we_o),
      .wbs3_sel_o(wbs3_sel_o),
      .wbs3_stb_o(wbs3_stb_o),
      .wbs3_ack_i(wbs3_ack_i),
      .wbs3_err_i('0),
      .wbs3_rty_i('0),
      .wbs3_cyc_o(wbs3_cyc_o),

      // Slave interface 4 (to Block RAM)
      // Address range: 0x0100_0000 ~ 0x0107_52FF (479999d = 752ffx)
      .wbs4_addr    (32'h0100_0000),
      .wbs4_addr_msk(32'hFFF0_0000),

      .wbs4_adr_o(wbs4_adr_o),
      .wbs4_dat_i(wbs4_dat_i),
      .wbs4_dat_o(wbs4_dat_o),
      .wbs4_we_o (wbs4_we_o),
      .wbs4_sel_o(wbs4_sel_o),
      .wbs4_stb_o(wbs4_stb_o),
      .wbs4_ack_i(wbs4_ack_i),
      .wbs4_err_i('0),
      .wbs4_rty_i('0),
      .wbs4_cyc_o(wbs4_cyc_o)
  );

  /* =========== MUX end =========== */

  /* =========== Slaves begin =========== */
  sram_controller #(
      .SRAM_ADDR_WIDTH(20),
      .SRAM_DATA_WIDTH(32)
  ) sram_controller_base (
      .clk_i(sys_clk),
      .rst_i(sys_rst),

      // Wishbone slave (to MUX)
      .wb_cyc_i(wbs0_cyc_o),
      .wb_stb_i(wbs0_stb_o),
      .wb_ack_o(wbs0_ack_i),
      .wb_adr_i(wbs0_adr_o),
      .wb_dat_i(wbs0_dat_o),
      .wb_dat_o(wbs0_dat_i),
      .wb_sel_i(wbs0_sel_o),
      .wb_we_i (wbs0_we_o),

      // To SRAM chip
      .sram_addr(base_ram_addr),
      .sram_data(base_ram_data),
      .sram_ce_n(base_ram_ce_n),
      .sram_oe_n(base_ram_oe_n),
      .sram_we_n(base_ram_we_n),
      .sram_be_n(base_ram_be_n)
  );

  sram_controller #(
      .SRAM_ADDR_WIDTH(20),
      .SRAM_DATA_WIDTH(32)
  ) sram_controller_ext (
      .clk_i(sys_clk),
      .rst_i(sys_rst),

      // Wishbone slave (to MUX)
      .wb_cyc_i(wbs1_cyc_o),
      .wb_stb_i(wbs1_stb_o),
      .wb_ack_o(wbs1_ack_i),
      .wb_adr_i(wbs1_adr_o),
      .wb_dat_i(wbs1_dat_o),
      .wb_dat_o(wbs1_dat_i),
      .wb_sel_i(wbs1_sel_o),
      .wb_we_i (wbs1_we_o),

      // To SRAM chip
      .sram_addr(ext_ram_addr),
      .sram_data(ext_ram_data),
      .sram_ce_n(ext_ram_ce_n),
      .sram_oe_n(ext_ram_oe_n),
      .sram_we_n(ext_ram_we_n),
      .sram_be_n(ext_ram_be_n)
  );

  // 串口控制器模块
  // NOTE: 如果修改系统时钟频率，也需要修改此处的时钟频率参数
  uart_controller #(
      .CLK_FREQ(10_000_000),
      .BAUD    (115200)
  ) uart_controller (
      .clk_i(sys_clk),
      .rst_i(sys_rst),

      .wb_cyc_i(wbs2_cyc_o),
      .wb_stb_i(wbs2_stb_o),
      .wb_ack_o(wbs2_ack_i),
      .wb_adr_i(wbs2_adr_o),
      .wb_dat_i(wbs2_dat_o),
      .wb_dat_o(wbs2_dat_i),
      .wb_sel_i(wbs2_sel_o),
      .wb_we_i (wbs2_we_o),

      // to UART pins
      .uart_txd_o(txd),
      .uart_rxd_i(rxd)
  );

  mtime_controller mtime_controller_1 (
      .clk_i(sys_clk),
      .rst_i(sys_rst),

      .wb_cyc_i(wbs3_cyc_o),
      .wb_stb_i(wbs3_stb_o),
      .wb_ack_o(wbs3_ack_i),
      .wb_adr_i(wbs3_adr_o),
      .wb_dat_i(wbs3_dat_o),
      .wb_dat_o(wbs3_dat_i),
      .wb_sel_i(wbs3_sel_o),
      .wb_we_i (wbs3_we_o),
      
      .mtime_int_o(mtime_int)
  );

  /* =========== Slaves end =========== */


  /* =========== VGA begin =========== */

  assign video_clk = clk_50M;

  logic [15:0] bram_r_addr;
  logic [10:0] real_h, real_v;
  logic [7:0] bram_r_data;

  logic [10:0] hdata;
  logic [10:0] vdata;

  /* Reference: JamesSand                                 */
  /* 我们将分辨率压缩成原来的1/16，新图像的分辨率为200 * 150 */
  /* 原先图像的列每+4，对应的bram地址要加200                */
  /* 故这里50 = 200 / 4，是这么来的                        */ 
  assign real_h = {2'b00, hdata[10:2]};
  assign real_v = {vdata[10:2], 2'b00};
  assign bram_r_addr = real_h + 50 * real_v;

  logic bram_we;
  logic [15:0] bram_w_addr;
  logic [7:0]  bram_w_data;

  bram_controller u_bram_controller (
    .clk_i(sys_clk),
    .rst_i(sys_rst),
    .wb_cyc_i(wbs4_cyc_o),
    .wb_stb_i(wbs4_stb_o),
    .wb_ack_o(wbs4_ack_i),
    .wb_adr_i(wbs4_adr_o),
    .wb_dat_i(wbs4_dat_o),
    .wb_dat_o(wbs4_dat_i),
    .wb_sel_i(wbs4_sel_o),
    .wb_we_i (wbs4_we_o),

    .bram_addr(bram_w_addr),
    .bram_data(bram_w_data),
    .bram_we(bram_we)
  );

  /* a口用于写，b口用于读 */
  blk_mem u_blk_mem (
    .addra(bram_w_addr),
    .clka(sys_clk),
    .dina(bram_w_data),
    .ena(1'b1),
    .wea(bram_we),

    .addrb(bram_r_addr),
    .clkb(clk_50M),
    .doutb(bram_r_data),
    .enb(1'b1)
  );

  // assign video_red = 3'b111;
  // assign video_green = 0;
  // assign video_blue = 0;
  assign video_red = bram_r_data[2:0];
  assign video_green = bram_r_data[5:3];
  assign video_blue = bram_r_data[7:6];

  vga #(
    .WIDTH(11),
    .HSIZE(800),
    .HFP(856),
    .HSP(976),
    .HMAX(1040),
    .VSIZE(600),
    .VFP(637),
    .VSP(643),
    .VMAX(666),
    .HSPP(1),
    .VSPP(1)
  ) u_vga (
    .clk(clk_50M),
    .rst(sys_rst),
    .hsync(video_hsync),
    .vsync(video_vsync),
    .hdata(hdata),
    .vdata(vdata),
    .data_enable(video_de)
  );

  /* =========== VGA end =========== */

endmodule
