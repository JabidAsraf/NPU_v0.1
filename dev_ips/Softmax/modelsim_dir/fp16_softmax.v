module fp16_softmax #(
    parameter IN_OUT_NUM = 10
) (
    input  wire                        clk,
    input  wire                        reset_b,
    input  wire                        start_op,
    input  wire                        clear,
    input  wire [(IN_OUT_NUM*16)-1:0]  input_neuron_val,
    output wire [(IN_OUT_NUM*16)-1:0]  output_neuron_val,
    output wire                        valid
);

    wire   [(IN_OUT_NUM*16)-1:0]    exp_out;

    wire                            start_exp;
    wire   [IN_OUT_NUM-1:0]         valid_ind_exp;
    wire                            valid_exp;
    wire                            start_addition;
    wire                            valid_addition;
    wire                            start_division;
    wire   [IN_OUT_NUM-1:0]         valid_ind_division;
    wire                            valid_division;

    wire   [15:0]                   divisor_buff_d;
    wire   [15:0]                   divisor_buff_q;

    wire   [15:0]                   adder_buff_d;
    wire   [15:0]                   adder_buff_q;
    wire   [3:0]                    add_count;
    wire                            add_count_match;

    wire   [15:0]                   adder_out;
    wire                            clear_exp;
    wire                            clear_adder;
    wire                            clear_division;
    wire                            clear_counter;

    // +-----------------------------+
    // |  fp16_exp module generator  |
    // +-----------------------------+
    //
    genvar exp_gen;
    //
    generate
        for (exp_gen = 0; exp_gen < IN_OUT_NUM ; exp_gen = exp_gen + 1) begin
            fp16_exp u_fp16_exp
            (
                .clk        ( clk                                                  ),
                .reset_b    ( reset_b                                              ),
                .start_exp  ( start_exp                                            ),
                .input_val  ( input_neuron_val[((exp_gen*16) + 16)-1:(exp_gen*16)] ),
                .result     ( exp_out[((exp_gen*16) + 16)-1:(exp_gen*16)]          ),
                .valid      ( valid_ind_exp[exp_gen]                               ),
                .clear      ( clear_exp                                            )
            );
        end
    endgenerate
    //
    assign valid_exp = &valid_ind_exp;
    assign clear_exp = clear;
    //
    //--------------------------------


    // +----------------------+
    // |  Adder Buffer Logic  |
    // +----------------------+
    //
    wire vexp_posedge;
    wire vexp_edge_det_temp;
    wire valid_addition_delayed;
    //
    dff
    # (
        .FLOP_WIDTH  ( 16           ),
        .RESET_VALUE ( 16'd0        )
    ) u_dff_adder_buffer (
        .clk         ( clk          ),
        .reset_b     ( reset_b      ),
        .en          ( 1'b1         ),
        .d           ( adder_buff_d ),
        .q           ( adder_buff_q )
    );
    //
    // ------------------------
    
    dff
    # (
        .FLOP_WIDTH  ( 1                  ),
        .RESET_VALUE ( 1'b0               )
    ) u_dff_vexp_edge_det (
        .clk         ( clk                ),
        .reset_b     ( reset_b            ),
        .en          ( 1'b1               ),
        .d           ( valid_exp          ),
        .q           ( vexp_edge_det_temp )
    );
    
    dff
    # (
        .FLOP_WIDTH  ( 1                      ),
        .RESET_VALUE ( 1'b0                   )
    ) u_dff_vadd_delay (
        .clk         ( clk                    ),
        .reset_b     ( reset_b                ),
        .en          ( 1'b1                   ),
        .d           ( valid_addition         ),
        .q           ( valid_addition_delayed )
    );
    //
    assign vexp_posedge        = (vexp_edge_det_temp ^ valid_exp) & valid_exp;
    assign adder_buff_d [15:0] = ((valid_addition_delayed & ~add_count_match) | (vexp_posedge)) ? exp_out[add_count*16 +: 16] : adder_buff_q;
    //
    //---------------------------


    // +------------------------+
    // |  Divisor Buffer Logic  |
    // +------------------------+
    //
    dff
    # (
        .FLOP_WIDTH  ( 16             ),
        .RESET_VALUE ( 16'd0          )
    ) u_dff_divisor_buffer (
        .clk         ( clk            ),
        .reset_b     ( reset_b        ),
        .en          ( 1'b1           ),
        .d           ( divisor_buff_d ),
        .q           ( divisor_buff_q )
    ); 
    //
    assign divisor_buff_d  [15:0] = valid_addition ? adder_out [15:0] : divisor_buff_q [15:0]; 
    //
    // --------------------------


    // +--------------------+
    // |  Addition Counter  |
    // +--------------------+
    //
    counter_m # (
        .FLOP_WIDTH    ( 4              ),
        .RESET_VALUE   ( 4'd0           )
    ) u_counter_m_addition_counter (
        .clk           ( clk            ),
        .reset_b       ( reset_b        ),
        .enable        ( valid_addition ),
        .direction     ( 1'b1           ),
        .preload       ( 1'b0           ),
        .preload_value ( 4'd0           ),
        .clear         ( clear_counter  ),
        .count         ( add_count      )
    );
    //
    assign add_count_match = (add_count == (IN_OUT_NUM));
    assign clear_counter   = clear | (valid_addition & add_count_match);
    //
    // ----------------------
    

    // +---------+
    // |  Adder  |
    // +---------+
    //
    fp16_adder u_fp16_adder
    (
        .clk            ( clk            ),
        .reset_b        ( reset_b        ),
        .start_addition ( start_addition ),
        .input_a        ( adder_buff_q   ),
        .input_b        ( divisor_buff_q ),
        .clear          ( clear_adder    ),
     
        .valid          ( valid_addition ),
        .result         ( adder_out      )
    );
    //
    // -----------

    
    // +-----------+
    // |  Divider  |
    // +-----------+
    //
    genvar div_gen;
    //
    generate
        for (div_gen = 0; div_gen < IN_OUT_NUM ; div_gen = div_gen + 1) begin
            fp16_divider u_fp16_divider
            (
                .clk            ( clk                                                   ),
                .reset_b        ( reset_b                                               ),
                .input_a        ( exp_out[((div_gen*16) + 16)-1:(div_gen*16)]           ),
                .input_b        ( divisor_buff_q                                        ),
                .start_divider  ( start_division                                        ),
                .clear          ( clear_division                                        ),

                .valid          ( valid_ind_division[div_gen]                           ),
                .result         ( output_neuron_val[((div_gen*16) + 16)-1:(div_gen*16)] )
            );
        end
    endgenerate
    //
    assign valid_division = &valid_ind_division;
    assign clear_division = clear;
    //
    // -------------


    // +----------------------------+
    // |  Softmax Flow Control FSM  |
    // +----------------------------+
    //
    localparam  IDLE             = 0,
                EXP_PHASE_1      = 1,
                EXP_PHASE_2      = 2,
                ADDITION_PHASE_1 = 3,
                ADDITION_PHASE_2 = 4,
                DIVISION_PHASE_1 = 5,
                DIVISION_PHASE_2 = 6,
                VALID_PHASE      = 7;
    //
    wire [2:0] pstate;
    reg  [2:0] nstate;
    //
    // PSR
    dff
    # (
        .FLOP_WIDTH  ( 3           ),
        .RESET_VALUE ( 3'd0        )
    ) u_dff_psr (
        .clk         ( clk         ),
        .reset_b     ( reset_b     ),
        .en          ( 1'b1        ),
        .d           ( nstate[2:0] ),
        .q           ( pstate[2:0] )
    );
    //
    // NSL
    always @(*) begin
        casez (pstate[2:0])
            IDLE: begin
                nstate [2:0] = start_op          ? EXP_PHASE_1                                             : IDLE;
            end

            EXP_PHASE_1: begin
                nstate [2:0] = EXP_PHASE_2;
            end

            EXP_PHASE_2: begin
                nstate [2:0] = vexp_posedge      ? ADDITION_PHASE_1                                        : EXP_PHASE_2;
            end

            ADDITION_PHASE_1: begin
                nstate [2:0] = ADDITION_PHASE_2;
            end

            ADDITION_PHASE_2: begin
                nstate [2:0] = valid_addition_delayed    ? (add_count_match ? DIVISION_PHASE_1 : ADDITION_PHASE_1) : ADDITION_PHASE_2;
            end

            DIVISION_PHASE_1: begin
                nstate [2:0] = DIVISION_PHASE_2;
            end

            DIVISION_PHASE_2: begin
                nstate [2:0] = valid_division    ? VALID_PHASE                                             : DIVISION_PHASE_2;
            end

            VALID_PHASE: begin
                nstate [2:0] = IDLE;
            end

            default: begin
                nstate [2:0] = 'bx;
            end
        endcase
    end
    //
    // OL
    assign start_exp      = (pstate[2:0] == EXP_PHASE_1);
    assign start_addition = (pstate[2:0] == ADDITION_PHASE_1);
    assign start_division = (pstate[2:0] == DIVISION_PHASE_1);
    assign clear_adder    = ((pstate[2:0] == ADDITION_PHASE_2) & valid_addition & ~add_count_match) | clear;
    assign valid          = (pstate[2:0] == VALID_PHASE);
    //
    // ------------------------------
  
endmodule
