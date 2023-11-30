`default_nettype none
`include "utils.svh"

module imm_gen (
    input wire [31:0] inst,
    input wire [2:0]  inst_type,
    output reg [31:0] imm
);
    always_comb begin
        case (inst_type)
            `TYPE_I: imm = $signed(inst[31:20]);
            `TYPE_S: imm = $signed({inst[31], inst[31:25], inst[11:7]});
            `TYPE_B: imm = $signed({inst[31], inst[7], inst[31:25], inst[11:8], 1'b0});
            `TYPE_U: imm = $signed({inst[31:12], 12'b0});
            `TYPE_J: imm = $signed({inst[31], inst[19:12], inst[20], inst[30:21], 1'b0});
            default: imm = 32'b0;
        endcase
    end
endmodule