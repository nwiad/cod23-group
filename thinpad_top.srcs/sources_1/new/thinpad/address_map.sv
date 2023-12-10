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

  output reg page_fault_o
);

  typedef enum logic { 
    BARE = 0, // no translation
    SV32 = 1 // 32-bit sv32
  } mode_t;

  typedef enum logic [3:0] {
    STAND_BY   = 0,
    MAP_1      = 1,
    MAP_1_DONE = 2,
    MAP_2      = 3,
    MAP_2_DONE = 4,
    REQUEST    = 5,
    DONE       = 6
  } state_t;
  state_t state;

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

  logic page_fault;
  logic user_code, user_data, kernel_code_1, kernel_code_2;

  logic mode;
  logic [31:0] page_table_1;
  logic [31:0] vpn_1, vpn_0; // virtual page number
  logic [31:0] vpo; // virtual page offset
  logic [31:0] ppo; // physical page offset
  logic [31:0] pte_addr_1, pte_addr_2;

  reg [31:0] page_table_2;
  reg [31:0] ppn;
  reg [31:0] sram_data;

  always_comb begin
    mode = satp_i[31];
    page_table_1 = satp_i[19:0] << 12;
    vpn_1 = v_wb_adr_i[31:22];
    vpn_0 = v_wb_adr_i[21:12];
    vpo = v_wb_adr_i[11:0]; // unused
    ppo = v_wb_adr_i[11:0];
    pte_addr_1 = page_table_1 + (vpn_1 << 2);
    pte_addr_2 = page_table_2 + (vpn_0 << 2) ;

    user_code = (v_wb_adr_i >= `MIN_USER_CODE_ADDR && v_wb_adr_i <= `MAX_USER_CODE_ADDR);
    user_data = (v_wb_adr_i >= `MIN_USER_DATA_ADDR && v_wb_adr_i <= `MAX_USER_DATA_ADDR);
    kernel_code_1 = (v_wb_adr_i >= `MIN_KERNEL_CODE_ADDR_1 && v_wb_adr_i <= `MAX_KERNEL_CODE_ADDR_1);
    kernel_code_2 = (v_wb_adr_i >= `MIN_KERNEL_CODE_ADDR_2 && v_wb_adr_i <= `MAX_KERNEL_CODE_ADDR_2);
    page_fault = v_wb_cyc_i && v_wb_stb_i && (mode == SV32) && !(user_code || user_data || kernel_code_1 || kernel_code_2);

    page_fault_o = page_fault;

    if (mode == BARE) begin // no translation
      wb_cyc_o = v_wb_cyc_i;
      wb_stb_o = v_wb_stb_i;
      wb_adr_o = v_wb_adr_i;
      wb_dat_o = v_wb_dat_i;
      wb_sel_o = v_wb_sel_i;
      wb_we_o = v_wb_we_i;
      v_wb_ack_o = wb_ack_i;
      v_wb_dat_o = wb_dat_i;
    end else if (mode == SV32) begin // 32-bit sv32
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
      endcase
    end else begin // won't happen
      wb_cyc_o = 1'b0;
      wb_stb_o = 1'b0;
      wb_adr_o = 32'h0000_0000;
      wb_dat_o = 32'h0000_0000;
      wb_sel_o = 4'b0000;
      wb_we_o = 1'b0;
      v_wb_ack_o = 1'b0;
      v_wb_dat_o = 32'h0000_0000;
    end
  end

  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      page_table_2 <= 32'h0000_0000;
      sram_data <= 32'h0000_0000;
      state <= STAND_BY;
    end else begin
      case (state)
        STAND_BY: begin
          if (mode == SV32 && v_wb_cyc_i == 1'b1 && v_wb_stb_i == 1'b1 && !page_fault) begin
            state <= MAP_1;
          end
        end

        MAP_1: begin
          if (v_wb_cyc_i == 1'b0 || v_wb_stb_i == 1'b0) begin // interrupt
            state <= STAND_BY;
          end else begin
            if (wb_ack_i == 1'b1) begin
              page_table_2 <= wb_dat_i[31:12] << 12;
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
              ppn <= wb_dat_i[31:12];
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
      endcase
    end
  end
endmodule