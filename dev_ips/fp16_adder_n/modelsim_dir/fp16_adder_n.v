module fp16_divider (
    input  wire        clk,
    input  wire        reset_b,
    input  wire [15:0] input_a,
    input  wire [15:0] input_b,
    input  wire        start,
    input  wire        clear,
    
    output wire        valid,
    output wire [15:0] result
);

wire          sign_bit;
wire  [10:0]  mantisa;
wire  [5:0]   exponent;
wire          valid_reg_d_temp;



assign valid_reg_d_temp = start ? 1'b1 : (clear ? 1'b0 : valid);

dff #(
    .FLOP_WIDTH  ( 1                ),
    .RESET_VALUE ( 1'b0             )
) u_valid_reg (
    .clk         ( clk              ),
    .reset_b     ( reset_b          ),
    .en          ( 1'b1             ),
    .d           ( valid_reg_d_temp ),
    .q           ( valid            )
);

endmodule

module dff # (
    parameter FLOP_WIDTH = 1,
    parameter RESET_VALUE = 1'b0
)(
    input  wire                  clk,
    input  wire                  reset_b,
    input  wire                  en,
    input  wire [FLOP_WIDTH-1:0] d,
    output reg  [FLOP_WIDTH-1:0] q
);

    always @(posedge clk or negedge reset_b) begin
        if(~reset_b) begin
            q [FLOP_WIDTH-1:0] <= RESET_VALUE;
        end
        else begin
            q [FLOP_WIDTH-1:0] <= en ? d [FLOP_WIDTH-1:0] : q [FLOP_WIDTH-1:0];
        end
    end

endmodule

