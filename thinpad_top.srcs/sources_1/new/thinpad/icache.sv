`default_nettype none

module icache (
    input wire clk_i,
    input wire rst_i,
    input wire write_i,
    input wire [31:0] write_pc_i,
    input wire [31:0] write_inst_i,
    input wire [31:0] pc_i,
    output reg [31:0] inst_o,
    output reg hit_o,

    // fence.i
    input wire clear_icache_i
);
reg valid [0:63];
reg [25:0] tag [0:63];
reg [31:0] cache [0:63];
logic [5:0] index_comb;
logic [25:0] pc_tag_comb;
logic [5:0] write_index_comb;
logic [25:0] write_pc_tag_comb;

always_comb begin
    index_comb = pc_i[5:0];
    pc_tag_comb = pc_i[31:6];
    hit_o = valid[index_comb] && (tag[index_comb] == pc_tag_comb) && cache[index_comb] != 32'h0000_0000; // 防止存入失败
    inst_o = hit_o ? cache[index_comb] : 32'h0000_0000;

    write_index_comb = write_pc_i[5:0];
    write_pc_tag_comb = write_pc_i[31:6];
end

always_ff @(posedge clk_i) begin
    if (rst_i || clear_icache_i) begin
        for (int i = 0; i < 64; i = i + 1) begin
            cache[i] <= 32'h0000_0000;
            valid[i] <= 1'b0;
            tag[i] <= 26'h0000_0000;
        end
    end else begin
        if (write_i) begin
            if (write_inst_i != 32'h0000_0000) begin // 防止存入失败
                valid[write_index_comb] <= 1'b1;
                tag[write_index_comb] <= write_pc_tag_comb;
                cache[write_index_comb] <= write_inst_i;
            end
        end
    end
end

endmodule