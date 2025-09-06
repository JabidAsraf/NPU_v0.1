module fp16_multiplier_n (
    input  wire        clk,
    input  wire        reset_b,
    input  wire [15:0] input_a,
    input  wire [15:0] input_b,
    input  wire        clear,
    input  wire        start,
    
    output wire        valid,
    output wire [15:0] result
);

localparam    MAIN_ECT      = 10'b00001_01110;

wire          dff_in;

// +------------------+
// |  Unpacking FP16  |
// +------------------+
//
wire          sign_bit_a;
wire          sign_bit_b;
//
wire  [5:0]   exponent_a;
wire  [5:0]   exponent_b;
//
wire  [9:0]   mantisa_a;
wire  [9:0]   mantisa_b;
wire  [10:0]  mantisa_a_fple;
wire  [10:0]  mantisa_b_fple;
wire  [10:0]  mantisa_adder_out;
//
wire          sign_bit_out;
wire  [9:0]   mantisa_out;
wire  [5:0]   exponent_out;
wire          zcheck;
//
assign sign_bit_a                = input_a[15];
assign sign_bit_b                = input_b[15];
assign exponent_a         [5:0]  = {1'b0, input_a[14:10]};
assign exponent_b         [5:0]  = {1'b0, input_b[14:10]};
assign mantisa_a          [9:0]  = input_a[9:0];
assign mantisa_b          [9:0]  = input_b[9:0];
//
// --------------------

// +------------------------+
// |  Multiplication Logic  |
// +------------------------+
//
assign mantisa_a_fple     [10:0] = mantisa_a[9] ? {1'b1, 1'b1, mantisa_a[9:1]} : {1'b0, mantisa_a[9:0]};
assign mantisa_b_fple     [10:0] = mantisa_b[9] ? {1'b1, 1'b1, mantisa_b[9:1]} : {1'b0, mantisa_b[9:0]};
assign mantisa_adder_out  [10:0] = mantisa_a_fple[10:0] + mantisa_b_fple[10:0];
assign mantisa_out        [9:0]  = mantisa_adder_out[10] ? {mantisa_adder_out[8:0], 1'b0} : {mantisa_adder_out[9:0]};
//
assign sign_bit_out              = sign_bit_a ^ sign_bit_b;
//
assign exponent_adder_cin        = ~((~(mantisa_a[9] & mantisa_b[9])) & (mantisa_adder_out[10] | (~(mantisa_a[9] | mantisa_b[9]))));
assign exponent_out       [5:0]  = exponent_a[5:0] + exponent_b[5:0] - 6'b001111 + {5'b00000, exponent_adder_cin};
//  
assign zcheck                    = (input_a == 16'b0) | (input_b == 16'b0);
//
assign result                    = zcheck ? 16'b0 : {sign_bit_out, exponent_out[4:0], mantisa_out[9:0]};
//
// --------------------------

// +-------------------------------------------------------------------+
// |  Validity Logic (For compatilibility with other external blocks)  |
// +-------------------------------------------------------------------+
//
assign dff_in = start ? 1'b1 : (clear ? 1'b0 : valid);
//
dff #(
    .FLOP_WIDTH  ( 1       ),
    .RESET_VALUE ( 1'b0    )
) u_valid_reg (
    .clk         ( clk     ),
    .reset_b     ( reset_b ),
    .en          ( 1'b1    ),
    .d           ( dff_in  ),
    .q           ( valid   )
);
//
// ---------------------------------------------------------------------

endmodule
