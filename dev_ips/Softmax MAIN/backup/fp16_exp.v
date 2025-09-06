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
    
    wire [9:0] range;
    
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
    assign range[0]     = (sbit_eq_1 & expo_gt_17) | (sbit_eq_1 & expo_eq_17 & mant_le_1023 & mant_ge_512);
    assign range[1]     = (sbit_eq_1 & expo_eq_17 & mant_ge_0 & mant_lt_512);
    assign range[2]     = (sbit_eq_1 & expo_eq_16 & mant_ge_0 & mant_le_1023);
    assign range[3]     = (sbit_eq_1 & expo_lt_15) | (sbit_eq_1 & expo_eq_15 & mant_ge_0 & mant_le_1023) | (~(|input_val[15:0]));
    assign range[4]     = (sbit_eq_0 & expo_eq_16 & mant_eq_0) | (sbit_eq_0 & expo_eq_15 & mant_ge_0 & mant_le_1023)
															   | (sbit_eq_0 & expo_lt_15 & (exponent != 0));
    assign range[5]     = (sbit_eq_0 & expo_eq_17 & mant_eq_0) | (sbit_eq_0 & expo_eq_16 & mant_gt_0 & mant_le_1023);
    assign range[6]     = (sbit_eq_0 & expo_eq_17 & mant_gt_0 & mant_le_256);
    assign range[7]     = (sbit_eq_0 & expo_eq_17 & mant_gt_256 & mant_le_512);
    assign range[8]     = (sbit_eq_0 & expo_eq_17 & mant_gt_512 & mant_le_768);
    assign range[9]     = (sbit_eq_0 & expo_gt_17) | (sbit_eq_0 & expo_eq_17 & mant_le_1023 & mant_gt_768);
    //
    // ----------------------------

    // +------------------------------------+
    // |  slope and intercept select logic  |
    // +------------------------------------+
    //
    always @(*) begin
        casez(range[9:0])
            10'b00000_00001: begin
                slope     [15:0] = 16'h13c8; //16'h1418;
                intercept [15:0] = 16'h2018; 
            end 
            10'b00000_00010: begin
                slope     [15:0] = 16'h1fd5; //16'h2018;
                intercept [15:0] = 16'h2a24; //16'h2a87; 
            end 
            10'b00000_00100: begin
                slope     [15:0] = 16'h2aec; //16'h2b8d;
                intercept [15:0] = 16'h334b; //16'h340c;
            end 
            10'b00000_01000: begin
                slope     [15:0] = 16'h3785; //16'h36e9;
                intercept [15:0] = 16'h3c00; //16'h3bfd;
            end 
            10'b00000_10000: begin
                slope     [15:0] = 16'h4000; //16'h4263;
                intercept [15:0] = 16'h3c66; //16'h3bfd;
            end 
            10'b00001_00000: begin
                slope     [15:0] = 16'h4de6;
                intercept [15:0] = 16'hd190; //16'hd0fa; 
            end 
            10'b00010_00000: begin
                slope     [15:0] = 16'h55dd;
                intercept [15:0] = 16'hdd02; 
            end 
            10'b00100_00000: begin
                slope     [15:0] = 16'h5bf8;
                intercept [15:0] = 16'he492; //16'he466; 
            end 
            10'b01000_00000: begin
                slope     [15:0] = 16'h61c8;
                intercept [15:0] = 16'heb6c; //16'heb55; 
            end 
            10'b10000_00000: begin
                slope     [15:0] = 16'h675c;
                intercept [15:0] = 16'hf223; //16'hf1e7; 
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
    fp16_multiplier slope_multiplier
    (
        .clk            ( clk                      ),
        .reset_b        ( reset_b                  ),
        .input_a        ( input_val [15:0]         ),
        .input_b        ( slope [15:0]             ),
        .start          ( start_multiplier         ),
        .clear          ( clear_multiplier         ),
        
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
