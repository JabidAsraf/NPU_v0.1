module tdp (
    input  wire       clk_a,
    input  wire       wen_a,
    input  wire [14:0]addr_a,
    input  wire [15:0]din_a,
    output wire [15:0]dout_a,
    
    input  wire       clk_b,
    input  wire       wen_b,
    input  wire [14:0]addr_b,
    input  wire [15:0]din_b,
    output wire [15:0]dout_b
);

reg [15:0] mem [20479:0];

always @(posedge clk_a) begin
    if (wen_a) begin
        mem [addr_a] <= din_a[15:0];
    end
end

always @(posedge clk_b) begin
    if (wen_b) begin
        mem [addr_b] <= din_b[15:0];
    end
end

assign dout_a = mem [addr_a];
assign dout_b = mem [addr_b];

endmodule
