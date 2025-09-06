module full_adder #(
    parameter ADDER_WIDTH = 1
) (
    input  wire [ADDER_WIDTH-1:0] input_a,
    input  wire [ADDER_WIDTH-1:0] input_b,
    input  wire                   carry_in,
    output wire [ADDER_WIDTH-1:0] result,
    output wire                   carry_out
);

wire [ADDER_WIDTH-1:0] carry_chain;

genvar i;

generate 
    for (i = 0; i <= ADDER_WIDTH; i = i + 1) begin
        FA_1 u_FA_1(
            .input_a   (input_a[i]),
            .input_b   (input_b[i]),
            .carry_in  (),
            .result    (),
            ,carry_out ()
        );
    end
endgenerate
    
endmodule


module full_subtractor #(
    parameter SUBTRACTOR_WIDTH = 1
) (
    input  wire [SUBTRACTOR_WIDTH-1:0] input_a,
    input  wire [SUBTRACTOR_WIDTH-1:0] input_b,
    input  wire                        borrow_in,
    input  wire [SUBTRACTOR_WIDTH-1:0] result,
    output wire                        borrow_out
);

wire [SUBTRACTOR_WIDTH:0] temp_a;
wire [SUBTRACTOR_WIDTH:0] temp_b;
wire [SUBTRACTOR_WIDTH:0] temp_res;
    
endmodule


module FA_1 (
    input  wire input_a,
    input  wire input_b,
    input  wire carry_in,
    output wire result,
    output wire carry_out
);

assign result    = input_a ^ input_b ^ carry_in;
assign carry_out = (input_a & input_b) | (input_b & carry_in) | (carry_in & input_a);

endmodule


module FS_1 (
    input  wire input_a,
    input  wire input_b,
    input  wire borrow_in,
    output wire result,
    output wire borrow_out
);

assign result     = input_a ^ input_b ^ borrow_in;
assign borrow_out = (~input_a & input_b) | (~input_a & borrow_in) | (borrow_in & borrow_out);

endmodule
