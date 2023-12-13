`default_nettype none

module address_map (
  input wire clk_i,
  input wire rst_i,

  // from wb_arbiter_2
  input wire v_wb_cyc_i,
  input wire v_wb_stb_i,
  output reg v_wb_ack_o,
  input wire [31:0] v_wb_adr_i,
  input wire [31:0] v_wb_dat_i,
  output reg [31:0] v_wb_dat_o,
  input wire [3:0] v_wb_sel_i,
  input wire v_wb_we_i,

  // to wb_mux_3
  output reg wb_cyc_o,
  output reg wb_stb_o,
  input wire wb_ack_i,
  output reg [31:0] wb_adr_o,
  output reg [31:0] wb_dat_o,
  input wire [31:0] wb_dat_i,
  output reg [3:0] wb_sel_o,
  output reg wb_we_o,

  input wire [31:0] satp_i, // satp register

  input wire [1:0] mode_i, // mode

  input wire sfence_i // sfence.vma
);

  typedef enum logic [1:0] {
    U_MODE = 2'b00,
    M_MODE = 2'b11 // no translation
  } mode_t;

  typedef enum logic { 
    BARE = 0, // no translation
    SV32 = 1 // 32-bit sv32
  } satp_mode_t;

  typedef enum logic [3:0] {
    STAND_BY   = 0,
    MAP_1      = 1,
    MAP_1_DONE = 2,
    MAP_2      = 3,
    MAP_2_DONE = 4,
    REQUEST    = 5,
    DONE       = 6,
    BARE_WB    = 7
  } state_t;
  state_t state;

  logic is_serial;
  logic is_vga;

  logic satp_mode;
  logic [31:0] page_table_1;
  logic [31:0] vpn_1, vpn_0; // virtual page number
  logic [31:0] vpo; // virtual page offset
  logic [31:0] ppo; // physical page offset
  logic [31:0] pte_addr_1, pte_addr_2;

  reg [31:0] page_table_2;
  reg [31:0] ppn;
  reg [31:0] sram_data;

  logic [19:0] TLB_vpn_o;
  logic [19:0] TLB_ppn_i;
  logic [19:0] TLB_ppn_o;
  logic TLB_hit;
  logic TLB_we_o;

  TLB u_TLB (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .satp_i(satp_i),
    .vpn_i(TLB_vpn_o),
    .ppn_o(TLB_ppn_i),
    .TLB_hit_o(TLB_hit),
    .TLB_we_i(TLB_we_o),
    .ppn_i(TLB_ppn_o),
    .sfence_i(sfence_i)
  );

  always_comb begin
    satp_mode = satp_i[31];
    page_table_1 = satp_i[19:0] << 12;
    vpn_1 = v_wb_adr_i[31:22];
    vpn_0 = v_wb_adr_i[21:12];
    vpo = v_wb_adr_i[11:0]; // unused
    ppo = v_wb_adr_i[11:0];
    pte_addr_1 = page_table_1 + (vpn_1 << 2);
    pte_addr_2 = page_table_2 + (vpn_0 << 2) ;

    is_serial = (v_wb_adr_i == 32'h1000_0000 || v_wb_adr_i == 32'h1000_0005);
    is_vga    = (v_wb_adr_i >= 32'h0100_0000 && v_wb_adr_i <= 32'h0107_52FF);
    TLB_we_o = 1'b0;
    TLB_vpn_o = v_wb_adr_i[31:12];

    if (mode_i == M_MODE || satp_mode == BARE || is_serial || is_vga) begin // no translation
      wb_cyc_o = v_wb_cyc_i;
      wb_stb_o = v_wb_stb_i;
      wb_adr_o = v_wb_adr_i;
      wb_dat_o = v_wb_dat_i;
      wb_sel_o = v_wb_sel_i;
      wb_we_o = v_wb_we_i;
      v_wb_ack_o = wb_ack_i;
      v_wb_dat_o = wb_dat_i;
    end else if (TLB_hit) begin 
      wb_cyc_o = v_wb_cyc_i;
      wb_stb_o = v_wb_stb_i;
      wb_adr_o = {TLB_ppn_i, v_wb_adr_i[11:0]};
      wb_dat_o = v_wb_dat_i;
      wb_sel_o = v_wb_sel_i;
      wb_we_o = v_wb_we_i;
      v_wb_ack_o = wb_ack_i;
      v_wb_dat_o = wb_dat_i;
    end else begin // mode_i == S_MODE && satp_mode == SV32 && !is_serial
      wb_cyc_o = 1'b0;
      wb_stb_o = 1'b0;
      wb_adr_o = 32'h0000_0000;
      wb_dat_o = 32'h0000_0000;
      wb_sel_o = 4'b0000;
      wb_we_o = 1'b0;
      v_wb_ack_o = 1'b0;
      v_wb_dat_o = 32'h0000_0000;
      case (state)
        STAND_BY: begin // once wishbone request is received, start transition
          wb_cyc_o = 1'b0;
          wb_stb_o = 1'b0;
        end

        MAP_1: begin
          wb_cyc_o = 1'b1;
          wb_stb_o = 1'b1;
          wb_adr_o = pte_addr_1; //
          wb_dat_o = 32'h0000_0000;
          wb_sel_o = 4'b1111;
          wb_we_o = 1'b0;
          v_wb_ack_o = 1'b0; // becomes 1 when STATE_MAP_2 is over
          v_wb_dat_o = 32'h0000_0000;
        end

        MAP_1_DONE: begin
          wb_cyc_o = 1'b0;
          wb_stb_o = 1'b0;
        end

        MAP_2: begin
          wb_cyc_o = 1'b1;
          wb_stb_o = 1'b1;
          wb_adr_o = pte_addr_2; //
          wb_dat_o = 32'h0000_0000;
          wb_sel_o = 4'b1111;
          wb_we_o = 1'b0;
          v_wb_ack_o = 1'b0; // becomes 1 when STATE_MAP_2 is over
          v_wb_dat_o = 32'h0000_0000;
        end

        MAP_2_DONE: begin
          wb_cyc_o = 1'b0;
          wb_stb_o = 1'b0;
          TLB_we_o = 1'b1;
        end

        REQUEST: begin
          wb_cyc_o = 1'b1;
          wb_stb_o = 1'b1;
          wb_adr_o = (ppn << 12) + ppo; //
          wb_dat_o = v_wb_dat_i;
          wb_sel_o = v_wb_sel_i;
          wb_we_o = v_wb_we_i;
          v_wb_ack_o = 1'b0; // becomes 1 when STATE_MAP_2 is over
          v_wb_dat_o = 32'h0000_0000;
        end

        DONE: begin
          wb_cyc_o = 1'b0;
          wb_stb_o = 1'b0;
          v_wb_ack_o = 1'b1; // becomes 1 when STATE_MAP_2 is over
          v_wb_dat_o = v_wb_we_i ? 32'h0000_0000 : sram_data;
        end

        BARE_WB: begin
          wb_cyc_o = v_wb_cyc_i;
          wb_stb_o = v_wb_stb_i;
          wb_adr_o = v_wb_adr_i;
          wb_dat_o = v_wb_dat_i;
          wb_sel_o = v_wb_sel_i;
          wb_we_o = v_wb_we_i;
          v_wb_ack_o = wb_ack_i;
          v_wb_dat_o = wb_dat_i;
        end
      endcase
    end
  end

  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      page_table_2 <= 32'h0000_0000;
      sram_data <= 32'h0000_0000;
      // state <= STAND_BY;
      state <= BARE_WB;
      TLB_ppn_o <= 20'h0000_0000;
    end else begin
      case (state)
        STAND_BY: begin // transit to MAP_1 only when necessary
          if (mode_i == U_MODE && satp_mode == SV32 && v_wb_cyc_i == 1'b1 && v_wb_stb_i == 1'b1 && !is_serial && !is_vga) begin // no page fault
            state <= MAP_1;
          end
        end

        MAP_1: begin
          if (v_wb_cyc_i == 1'b0 || v_wb_stb_i == 1'b0) begin // interrupt
            state <= STAND_BY;
          end else begin
            if (wb_ack_i == 1'b1) begin
              page_table_2 <= wb_dat_i[31:10] << 12;
              state <= MAP_1_DONE;
            end
          end
        end

        MAP_1_DONE: begin
          if (v_wb_cyc_i == 1'b0 || v_wb_stb_i == 1'b0) begin // interrupt
            state <= STAND_BY;
          end else begin
            state <= MAP_2;
          end
        end

        MAP_2: begin
          if (v_wb_cyc_i == 1'b0 || v_wb_stb_i == 1'b0) begin // interrupt
            state <= STAND_BY;
          end else begin
            if (wb_ack_i == 1'b1) begin
              TLB_ppn_o <= wb_dat_i[31:10];
              ppn <= wb_dat_i[31:10];
              state <= MAP_2_DONE;
            end
          end
        end

        MAP_2_DONE: begin
          if (v_wb_cyc_i == 1'b0 || v_wb_stb_i == 1'b0) begin // interrupt
            state <= STAND_BY;
          end else begin
            state <= REQUEST;
          end
        end

        REQUEST: begin
          if (v_wb_cyc_i == 1'b0 || v_wb_stb_i == 1'b0) begin // interrupt
            state <= STAND_BY;
          end else begin
            if (wb_ack_i == 1'b1) begin
              if (v_wb_we_i == 1'b0) begin // load
                sram_data <= wb_dat_i;
              end
              state <= DONE;
            end
          end
        end

        DONE: begin
          state <= STAND_BY;
        end

        BARE_WB: begin // once paging is enabled, transit to STAND_BY after last wishbone request is done
          if (wb_cyc_o == 1'b1 && wb_stb_o == 1'b1) begin // wishbone requestc on-going
            if (satp_mode == SV32 && wb_ack_i == 1'b1) begin // don't interrupt
              state <= STAND_BY;
            end
          end else if (satp_mode == SV32) begin
            state <= STAND_BY;
          end
        end
      endcase
    end
  end
endmodule