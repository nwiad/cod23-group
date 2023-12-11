// 全映射

`default_nettype none

module TLB (
  input wire clk_i,
  input wire rst_i,

  input wire [31:0] satp_i,

  // Read
  input wire [19:0] vpn_i,
  output reg [19:0] ppn_o,
  output reg TLB_hit_o,

  // Write
  input wire TLB_we_i,
  input wire [19:0] ppn_i
);

  typedef enum logic { 
    BARE = 0,
    SV32 = 1
  } satp_mode_t;

  logic satp_mode;

  logic [19:0] tlb_ppn [0:63];
  logic [19:0] tlb_vpn [0:63];
  logic [0:63] tlb_valid;
  logic [0:5] current_index;

  assign satp_mode = satp_i[31];

  // read
  always_comb begin
    TLB_hit_o = 1'b0;
    if (satp_mode == BARE) begin
      ppn_o = vpn_i;
    end else begin
      for (int i = 0; i < 64; i = i + 1) begin
        if (tlb_vpn[i] == vpn_i && tlb_valid[i]) begin
          ppn_o = tlb_ppn[i];
          TLB_hit_o = 1'b1;
        end
      end
    end
  end


  // write
  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      for (int i = 0; i < 64; i = i + 1) begin
        tlb_ppn[i] <= 20'h0000_0000;
        tlb_vpn[i] <= 20'h0000_0000;
        tlb_valid[i] <= 1'b0;
        current_index <= 6'h00;
      end
    end else if (TLB_we_i) begin
      tlb_ppn[current_index] <= ppn_i;
      tlb_vpn[current_index] <= vpn_i;
      tlb_valid[current_index] <= 1'b1;
      if (current_index == 6'h3f) begin
        current_index <= 6'h00;
      end else begin
        current_index <= current_index + 1;
      end
    end
  end


endmodule