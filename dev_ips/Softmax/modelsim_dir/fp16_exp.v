module fp16_exp (
    input          clk,
    input          reset_b,
    input          start_exp,
    input  [15:0]  input_val,
    input          clear,
    output         valid,
    output [15:0]  result
);

    wire        signbit;
    wire [4:0]  exponent;
    wire [9:0]  mantisa;
    
    wire [15:0] range;
    
    wire        sbit_eq_1;
    wire        sbit_eq_0;
    
    wire        expo_eq_17;
    wire        expo_gt_17;
    wire        expo_eq_16;
    wire        expo_eq_15;
    wire        expo_lt_15;
    
    wire        mant_le_1023;
    wire        mant_ge_512;
    wire        mant_ge_0;
    wire        mant_lt_512;
    wire        mant_eq_0;
    wire        mant_gt_0;
    wire        mant_le_256;
    wire        mant_gt_256;
    wire        mant_le_512;
    wire        mant_gt_512;
    wire        mant_le_768;
    wire        mant_gt_768;

    reg  [15:0] intercept;
    reg  [15:0] slope;

    wire        multiplier_valid;
    wire        adder_valid;

    wire        start_multiplier;
    wire        start_adder;
    
    wire        adder_clear;

    wire [15:0] m_to_a;

    assign signbit        = input_val [15];
    assign exponent [4:0] = input_val [14:10];
    assign mantisa  [9:0] = input_val [9:0];
    
    // +--------------------------+
    // |  Range Estimation Logic  |
    // +--------------------------+
    //
    assign sbit_eq_0    = (signbit == 0);
    assign sbit_eq_1    = (signbit == 1);
    //
    assign expo_eq_17   = (exponent[4:0] == 5'd17);
    assign expo_gt_17   = (exponent[4:0] >  5'd17);
    assign expo_eq_16   = (exponent[4:0] == 5'd16);
    assign expo_eq_15   = (exponent[4:0] == 5'd15);
    assign expo_lt_15   = (exponent[4:0] <  5'd15);
    //
    assign mant_eq_0    = (mantisa[9:0] == 10'd0);
    assign mant_gt_0    = (mantisa[9:0] >  10'd0);
    assign mant_ge_0    = (mantisa[9:0] >= 10'd0);
    assign mant_le_256  = (mantisa[9:0] <= 10'd256);
    assign mant_lt_256  = (mantisa[9:0] <  10'd256);
    assign mant_gt_256  = (mantisa[9:0] >  10'd256);
    assign mant_ge_256  = (mantisa[9:0] >= 10'd256);
    assign mant_le_512  = (mantisa[9:0] <= 10'd512);
    assign mant_lt_512  = (mantisa[9:0] <  10'd512);
    assign mant_gt_512  = (mantisa[9:0] >  10'd512);
    assign mant_ge_512  = (mantisa[9:0] >= 10'd512);
    assign mant_le_768  = (mantisa[9:0] <= 10'd768);
    assign mant_lt_768  = (mantisa[9:0] <  10'd768);
    assign mant_gt_768  = (mantisa[9:0] >  10'd768);
    assign mant_ge_768  = (mantisa[9:0] >= 10'd768);
    assign mant_le_1023 = (mantisa[9:0] <= 10'd1023);
    //
    assign range[0]     = (sbit_eq_1 & expo_gt_17) | (sbit_eq_1 & expo_eq_17 & mant_ge_768 & mant_le_1023);
    assign range[1]     = (sbit_eq_1 & expo_eq_17 & mant_ge_512 & mant_lt_768);
    assign range[2]     = (sbit_eq_1 & expo_eq_17 & mant_ge_256 & mant_lt_512);
    assign range[3]     = (sbit_eq_1 & expo_eq_17 & mant_ge_0 & mant_lt_256);
    assign range[4]     = (sbit_eq_1 & expo_eq_16 & mant_ge_512 & mant_le_1023);
    assign range[5]     = (sbit_eq_1 & expo_eq_16 & mant_ge_0 & mant_lt_512);
    assign range[6]     = (sbit_eq_1 & expo_eq_15 & mant_ge_0 & mant_le_1023);
    assign range[7]     = (~(|input_val[15:0]))                | (sbit_eq_1 & expo_lt_15 & (exponent != 0));    
    assign range[8]     = (sbit_eq_0 & expo_eq_15 & mant_eq_0) | (sbit_eq_0 & expo_lt_15 & (exponent != 0));
    assign range[9]     = (sbit_eq_0 & expo_eq_16 & mant_eq_0) | (sbit_eq_0 & expo_eq_15 & mant_gt_0 & mant_le_1023);
    assign range[10]    = (sbit_eq_0 & expo_eq_16 & mant_gt_0 & mant_le_512);
    assign range[11]    = (sbit_eq_0 & expo_eq_17 & mant_eq_0) | (sbit_eq_0 & expo_eq_16 & mant_gt_512 & mant_le_1023);
    assign range[12]    = (sbit_eq_0 & expo_eq_17 & mant_gt_0 & mant_le_256);
    assign range[13]    = (sbit_eq_0 & expo_eq_17 & mant_gt_256 & mant_le_512);
    assign range[14]    = (sbit_eq_0 & expo_eq_17 & mant_gt_512 & mant_le_768);
    assign range[15]    = (sbit_eq_0 & expo_gt_17) | (sbit_eq_0 & expo_eq_17 & mant_le_1023 & mant_gt_768);
    //
    // ----------------------------

    // +------------------------------------+
    // |  slope and intercept select logic  |
    // +------------------------------------+
    //
    always @(*) begin
        casez(range[15:0])
            16'b0000_0000_0000_0001: begin // range 0
                slope     [15:0] = 16'h10e8; //alt_16'h10c2;
                intercept [15:0] = 16'h1d38;  
            end
            16'b0000_0000_0000_0010: begin // range 1
                slope     [15:0] = /*16'h169d;*/ 16'h168d;
                intercept [15:0] = 16'h2222; //alt_16'h2231; 
            end     
            16'b0000_0000_0000_0100: begin // range 2
                slope     [15:0] = 16'h1c67;
                intercept [15:0] = 16'h2728; //alt_16'h273e; 
            end     
            16'b0000_0000_0000_1000: begin // range 3
                slope     [15:0] = /*16'h2219;*/ 16'h21f0;
                intercept [15:0] = 16'h2c16; //alt_16'h2c24; 
            end     
            16'b0000_0000_0001_0000: begin // range 4
                slope     [15:0] = 16'h2808;
                intercept [15:0] = 16'h308c; //alt_16'h309e; 
            end    
            16'b0000_0000_0010_0000: begin // range 5
                slope     [15:0] = /*16'h2dc2;*/ 16'h2d78;
                intercept [15:0] = 16'h34cc; //alt_16'h34e6; 
            end   
            16'b0000_0000_0100_0000: begin // range 6
                slope     [15:0] = /*16'h338d;*/ 16'h3370;
                intercept [15:0] = 16'h38ac; //alt_16'h38cd; 
            end  
            16'b0000_0000_1000_0000: begin // range 7
                slope     [15:0] = /*16'h3999;*/ 16'h390e;
                intercept [15:0] = 16'h3ba5; //alt_16'h3c00; 
            end 
            16'b0000_0001_0000_0000: begin // range 8
                slope     [15:0] = 16'h3edf;
                intercept [15:0] = /*16'h3ae1;*/ 16'h3b0f; //alt_16'h3c00;
            end 
            16'b0000_0010_0000_0000: begin // range 9
                slope     [15:0] = 16'h44ab;
                intercept [15:0] = /*16'hc099;*/ 16'hc085; //alt_16'hbfcf;
            end 
            16'b0000_0100_0000_0000: begin // range 10
                slope     [15:0] = 16'h4a59;
                intercept [15:0] = /*16'hcc96;*/ 16'hccba; //alt_16'hcc80;
            end 
            16'b0000_1000_0000_0000: begin // range 11
                slope     [15:0] = 16'h5050;
                intercept [15:0] = /*16'hd570;*/ 16'hd560; //alt_16'hd537;
            end 
            16'b0001_0000_0000_0000: begin // range 12 -----------
                slope     [15:0] = 16'h55dd;
                intercept [15:0] = /*16'hdd22;*/ 16'hdd1c; //alt_16'hdd02; 
            end 
            16'b0010_0000_0000_0000: begin // range 13
                slope     [15:0] = 16'h5bf8;
                intercept [15:0] = /*16'he4b0;*/ 16'he478; //alt_16'he466; 
            end 
            16'b0100_0000_0000_0000: begin // range 14
                slope     [15:0] = /*16'h61c8;*/ 16'h616a;
                intercept [15:0] = /*16'heb8a;*/ 16'heb6c; //alt_16'heb55;
            end 
            16'b1000_0000_0000_0000: begin // range 15
                slope     [15:0] = 16'h675c;
                intercept [15:0] = /*16'hf223;*/ 16'hf1f7; //alt_16'hf1e7;
            end 
            default: begin
                slope     [15:0] = 'bx;
                intercept [15:0] = 'bx;
            end
        endcase
    end
    //
    // --------------------------------------

    //  +-------------------+
    //  |    softmax FSM    |
    //  +-------------------+
    //
    localparam STATE_WIDTH = 3;
    //
    wire [STATE_WIDTH-1:0] pstate; 
    reg  [STATE_WIDTH-1:0] nstate;
    //
    localparam [STATE_WIDTH-1:0] IDLE             = 3'b000,
                                 MULTIPLIER_START = 3'b001,
                                 WAIT_1           = 3'b010,
                                 ADDER_START      = 3'b011,
                                 WAIT_2           = 3'b100,
                                 VALID            = 3'b101;
    //
    // Present state register
    //
    dff # (
        .FLOP_WIDTH  ( STATE_WIDTH ),
        .RESET_VALUE ( IDLE        )
    ) u_psr (
        .clk         ( clk         ),
        .reset_b     ( reset_b     ),
        .en          ( 1'b1        ),
        .d           ( nstate      ),
        .q           ( pstate      )
    );
    //
    // Next state logic
    //
    always @(*) begin
        casez( pstate )
            IDLE             : nstate[STATE_WIDTH-1:0] = start_exp        ? MULTIPLIER_START : IDLE;
            MULTIPLIER_START : nstate[STATE_WIDTH-1:0] = WAIT_1;
            WAIT_1           : nstate[STATE_WIDTH-1:0] = multiplier_valid ? ADDER_START      : WAIT_1;
            ADDER_START      : nstate[STATE_WIDTH-1:0] = WAIT_2;
            WAIT_2           : nstate[STATE_WIDTH-1:0] = adder_valid      ? VALID            : WAIT_2;
            VALID            : nstate[STATE_WIDTH-1:0] = clear            ? IDLE             : VALID;
            default          : nstate[STATE_WIDTH-1:0] = 'bx;
        endcase
    end
    //
    // Output logic
    // 
    assign adder_clear      = clear & adder_valid;
    assign clear_multiplier = clear & multiplier_valid;
    
    assign start_multiplier = (pstate == MULTIPLIER_START);
    assign start_adder      = (pstate == ADDER_START);
    
    assign valid            = (pstate == VALID);
    //
    // --------------------

    // +--------+
    // |  PWFs  |
    // +--------+
    //
    fp16_multiplier_alt slope_multiplier
    (
        .clk            ( clk                      ),
        .reset_b        ( reset_b                  ),
        .input_a        ( input_val [15:0]         ),
        .input_b        ( slope [15:0]             ),
        .start          ( start_multiplier         ),

        .valid          ( multiplier_valid         ),
        .result         ( m_to_a [15:0]            )
    );
    
    fp16_adder intercept_adder
    (
        .clk            ( clk                      ),
        .reset_b        ( reset_b                  ),
        .start_addition ( start_adder              ),
        .input_a        ( m_to_a [15:0]            ),
        .input_b        ( intercept [15:0]         ),
        .clear          ( adder_clear              ),

        .valid          ( adder_valid              ),
        .result         ( result [15:0]            )
    );    
    //
    // ----------

endmodule
