`timescale 1ns/1ps

module tb;
  
    parameter IN_OUT_NUM = 10;
    
    reg                         clk;
    reg                         reset_b;
    reg   [(IN_OUT_NUM*16)-1:0] a;
    reg                         start;
    reg                         clear;
    wire                        valid;
    wire  [(IN_OUT_NUM*16)-1:0] out; 
      
    shortreal j,i;
    shortreal max_err = 0;
    shortreal min_err = 0;
    shortreal total = 0;
    
    int input_file;
    int result_file;
    int scanRet;

    logic [15:0] inputs[];
    logic [15:0] results[];

    //  +----------------------------+
    //  |    Softmax intantiation    |
    //  +----------------------------+
    //
    fp16_softmax #(
        .IN_OUT_NUM(IN_OUT_NUM)
    ) DUT (
        .clk               ( clk     ),
        .reset_b           ( reset_b ),
        .start_op          ( start   ),
        .clear             ( clear   ),
        .input_neuron_val  ( a       ),
        .output_neuron_val ( out     ),
        .valid             ( valid   )
    );
    //
    //  ------------------------------
    

    //  +-----------------------+
    //  |   Clock Generation    |
    //  +-----------------------+
    //
    initial begin
        clk <= 0;
        forever #5 clk <= ~clk;
    end
    //
    //  -------------------------

    
    //  +-----------------------------+
    //  |    Test task invocations    |
    //  +-----------------------------+
    //
    initial begin
        $write("%c[1;34m",27);
    
        reset();     // Reset task
        @(posedge clk);
        
        /*        
        softmax_op(  // Main task
            .float_0 ( 1.2740 ),
            .float_1 ( -4.1152 ),
            .float_2 ( 0.4165 ),
            .float_3 ( -0.5530 ),
            .float_4 ( -1.2913 ),
            .float_5 ( -0.3039 ),
            .float_6 ( -1.9179 ),
            .float_7 ( -2.0567 ),
            .float_8 ( 1.7657 ),
            .float_9 ( -3.2469 )
        );*/
    
        for (i = 0; i < $size(inputs); i = i + 1) begin
            test(inputs[i], i);
        end

        $write("%c[0m",27);
    
        #20 $stop;
    end


    //  +-----------------------+
    //  |   Clock Generation    |
    //  +-----------------------+
    //
    task reset();
        reset_b   <=  1'b0;
        a         <=  16'd0;
        start     <=  1'b0;
        clear     <=  1'b0;
        @(posedge clk) reset_b <= 1'b1;
    endtask
    //
    //  -------------------------
   
    
    function shortreal expo(shortreal in);
        return 2.71828**in;
    endfunction
    
    task softmax_op(shortreal float_0, float_1, float_2, float_3, float_4, float_5, float_6, float_7, float_8, float_9);
        shortreal exp, act, err, err_p, max;
        shortreal exp_total;
        shortreal act_total;
        shortreal exp_out[9:0];
        shortreal divisor;
        integer i, max_in;
    
        $display("softmax_op task invoked");

        divisor = expo(float_0) + expo(float_1) + expo(float_2) + expo(float_3) + expo(float_4) + expo(float_5) + expo(float_6) + expo(float_7) + expo(float_8) + expo(float_9);
        exp_out[0]  = (expo(float_0)/divisor);
        exp_out[1]  = (expo(float_1)/divisor);
        exp_out[2]  = (expo(float_2)/divisor);
        exp_out[3]  = (expo(float_3)/divisor);
        exp_out[4]  = (expo(float_4)/divisor);
        exp_out[5]  = (expo(float_5)/divisor);
        exp_out[6]  = (expo(float_6)/divisor);
        exp_out[7]  = (expo(float_7)/divisor);
        exp_out[8]  = (expo(float_8)/divisor);
        exp_out[9]  = (expo(float_9)/divisor);
    
        a          <= {float2bin(float_9), 
                       float2bin(float_8),
                       float2bin(float_7),
                       float2bin(float_6),
                       float2bin(float_5),
                       float2bin(float_4),
                       float2bin(float_3),
                       float2bin(float_2),
                       float2bin(float_1),
                       float2bin(float_0)};
                   
        @(posedge clk) start <= 1'b1;
        @(posedge clk) start <= 1'b0;
        
        wait(valid);
        
        exp_total = 0;
        act_total = 0;
        max = 0;
        max_in = 0;
        
        for (i = 0; i < IN_OUT_NUM; i = i + 1) begin
            exp       = exp_out[i];
            act       = bin2float(out[i*16 +: 16]);
            if(max < act) begin
                max = act;
                max_in = i+1;
            end
            err       = (exp - act);
    	    err_p     = ((err/exp)*100);
            exp_total = exp + exp_total;
            act_total = act + act_total; 
            $display("-------------------------------------------------------------------------------------------------------------");
            $display("expected output in binary = %16b :: expected output in float = %0f"  , float2bin(exp)  , exp);
            $display("actual output in binary   = %16b :: actual output in float   = %0f\n", out[i*16 +: 16] , act);
            //$display("dividend = %0f", bin2float(DUT.exp_out[i*16 +: 16]));
            //$display("divisor  = %0f", bin2float(DUT.divisor_buff_q));
            $display("error absolute            = %0f"                                     , err);    
            $display("error percentage          = %0f"                                     , err_p);    
            $display("-------------------------------------------------------------------------------------------------------------\n\n");
            #1;
            err   = 0;
    	    err_p = 0;
        end
    
        $display("max output value = %0d"  , max_in);
    	
        @(posedge clk) clear <= 1'b1;
        @(posedge clk) clear <= 1'b0;
    endtask

    //  +--------------------------------+
    //  |    input value loading task    |
    //  +--------------------------------+
    
    task load_inputs();
        begin
            input_file = $fopen("demo_image_softmax_in.txt", "r");
    
            if (input_file == 0) begin
                $display("Cannot find the input file");
                $finish();
            end else begin
                while (!$feof(input_file)) begin
                    inputs = new [$size(inputs)+1] ( inputs );
                    scanRet = $fscanf(input_file, "%b", inputs[$size(inputs)-1]);
                end
            end
            
            $fclose(input_file);
        end
    endtask
    
    //  +---------------------------------+
    //  |    result value loading task    |
    //  +---------------------------------+
    
    task load_results();
        begin
            result_file = $fopen("demo_image_softmax_res.txt", "r");
    
            if (result_file == 0) begin
                $display("Cannot find the result file");
                $finish();
            end else begin
                while (!$feof(result_file)) begin
                    results = new [$size(results)+1] ( results );
                    scanRet = $fscanf(result_file, "%b", results[$size(results)-1]);
                end
            end
            
            $fclose(result_file);
        end
    endtask


    function [15:0] float2bin (shortreal float_a);
        logic [31:0] fp32;
        logic [7:0]  exp_temp;
        logic [22:0] man_temp;
        fp32     [31:0] = $shortrealtobits(float_a);
        exp_temp [7:0]  = fp32[30:23] - 8'd127 + 8'd15;
        man_temp [22:0] = fp32[22:0];
        return ((float_a == 0) ? 16'd0 : {fp32[31], exp_temp[4:0], man_temp[22:13]});
    endfunction
    
    function shortreal bin2float (logic [15:0] fp16);
        logic [31:0] fp32;
        logic [7:0]  exp_temp;
        logic [22:0] man_temp;
    
        exp_temp [7:0]  = {3'd0, fp16[14:10]} - 8'd15 + 8'd127;
        man_temp [22:0] = {fp16[9:0],13'd0};
        fp32     [31:0] = {fp16[15], exp_temp[7:0], man_temp[22:0]};
    
        return (~(|fp16[15:0]) ? 0 : $bitstoshortreal(fp32[31:0]));
    endfunction
  
endmodule
