module mtime_controller(
  // clk and reset
  input wire clk_i,
  input wire rst_i,
  
  // wishbone slave interface
  input wire wb_cyc_i,
  input wire wb_stb_i,
  output reg wb_ack_o,
  input wire [31:0] wb_adr_i,
  input wire [31:0] wb_dat_i,
  output reg [31:0] wb_dat_o,
  input wire [3:0] wb_sel_i,
  input wire wb_we_i,  
  
  // mtime exceeded signal
  output reg mtime_int_o
);

  // 注意高32位和低32位要分别操作
  // #define CLINT 0x2000000
  // #define CLINT_MTIME (CLINT + 0xBFF8)
  // #define CLINT_MTIMECMP (CLINT + 0x4000)
  reg [63:0] mtime_reg;
  reg [63:0] mtime_cmp_reg;

  typedef enum logic {
    STATE_IDLE = 0,
    STATE_DONE = 1
  } state_t;
  state_t state;  

  always_ff @ (posedge clk_i) begin
    if (rst_i) begin
      state <= STATE_IDLE;
      mtime_reg <= 0;
      mtime_cmp_reg <= 64'hffff_ffff_ffff_ffff;
      wb_ack_o <= 0;
      wb_dat_o <= 0;
      mtime_int_o <= 0;
    end else begin
      case (state)
        STATE_IDLE: begin
          if (wb_cyc_i && wb_stb_i) begin
            if(wb_we_i) begin
              //     lw t1, 0(t0)        // 读取 mtime 低 32 位
              // 80000298:	0002a303          	lw	t1,0(t0)
              //     lw t2, 4(t0)        // 读取 mtime 高 32 位
              // 8000029c:	0042a383          	lw	t2,4(t0)
              if (wb_adr_i == 32'h0200_4000) begin // mtimecmp low 32
                mtime_cmp_reg[31:0] <= wb_dat_i;
              end else if (wb_adr_i == 32'h0200_4004) begin // mtimecmp high 32
                mtime_cmp_reg[63:32] <= wb_dat_i;
              end else if (wb_adr_i == 32'h0200_BFF8) begin  // mtime low 32
                mtime_reg[31:0] <= wb_dat_i;
              end else if (wb_adr_i == 32'h0200_BFFc) begin // mtime high 32
                mtime_reg[63:32] <= wb_dat_i;
              end
            end else begin
              if (wb_adr_i == 32'h0200_4000) begin // mtimecmp low 32
                wb_dat_o <= mtime_cmp_reg[31:0];
              end else if (wb_adr_i == 32'h0200_4004) begin // mtimecmp high 32
                wb_dat_o <= mtime_cmp_reg[63:32];
              end else if (wb_adr_i == 32'h0200_BFF8) begin  // mtime low 32
                wb_dat_o <= mtime_reg[31:0];
              end else if (wb_adr_i == 32'h0200_BFFc) begin // mtime high 32
                wb_dat_o <= mtime_reg[63:32];
              end
            end
            wb_ack_o <= 1;
            state <= STATE_DONE;
          end else begin
            if ( mtime_reg >= mtime_cmp_reg ) begin
              mtime_int_o <= 1;
            end else begin
              mtime_int_o <= 0;
            end
            mtime_reg <= mtime_reg + 64'd1;
            // mtime_reg <= mtime_reg + 64'd10000;
            // mtime_reg <= mtime_reg + 64'd500;
          end
        end
        STATE_DONE: begin
          wb_ack_o <= 0;
          state <= STATE_IDLE;
        end
      endcase
    end
  end

endmodule
