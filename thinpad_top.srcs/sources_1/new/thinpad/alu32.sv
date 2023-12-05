`default_nettype none
`include "utils.svh"

module alu32 (
    input wire [31:0] alu_a,
    input wire [31:0] alu_b,
    input wire [3:0] alu_op,
    output reg [31:0] alu_y
);

logic [31:0] num_bits;
always_comb begin
    integer bit_counter = 0;
    num_bits = 0;
    if( alu_op == `ALU_PCNT) begin
        for (bit_counter = 0; bit_counter < 32; bit_counter++) begin
          num_bits = num_bits + alu_a[bit_counter];
        end
    end
end

always_comb begin
    case (alu_op)
        `ALU_ADD: alu_y = alu_a + alu_b;
        `ALU_SUB: alu_y = alu_a - alu_b;
        `ALU_AND: alu_y = alu_a & alu_b;
        `ALU_OR:  alu_y = alu_a | alu_b;
        `ALU_XOR: alu_y = alu_a ^ alu_b;
        `ALU_NOT: alu_y = ~alu_a;
        `ALU_SLL: alu_y = alu_a << (alu_b & 32'b11111);
        `ALU_SRL: alu_y = alu_a >> (alu_b & 32'b11111);
        `ALU_SRA: alu_y = $signed(alu_a) >>> (alu_b & 32'b11111);
        `ALU_ROL: alu_y = (alu_a << (alu_b & 32'b11111)) | (alu_a >> (32'h20 - (alu_b & 32'b11111)));
        `ALU_PCNT: alu_y = num_bits;
        `ALU_MIN: alu_y = (alu_a < alu_b) ? alu_a : alu_b;
        `ALU_SBCLR: alu_y = alu_a & ~(32'b1 << (32'b11111 & alu_b));
        default:  alu_y = 32'b0;
    endcase
end
endmodule