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
   
    integer j;

    int input_file;
    int result_file;
    int scanRet_res;
    int scanRet_in;
    
    integer pass_count;
    shortreal err;

    shortreal inputs[];
    integer results[];

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
        
        load_inputs();
        load_results();

        //reset();     // Reset task

        @(posedge clk);

        pass_count = 0;

        for (j = 0; j < $size(results); j = j + 1) begin
            reset();
            softmax_op
            (
                .float_0   ( inputs[(j*10)  ] ),
                .float_1   ( inputs[(j*10)+1] ),
                .float_2   ( inputs[(j*10)+2] ),
                .float_3   ( inputs[(j*10)+3] ),
                .float_4   ( inputs[(j*10)+4] ),
                .float_5   ( inputs[(j*10)+5] ),
                .float_6   ( inputs[(j*10)+6] ),
                .float_7   ( inputs[(j*10)+7] ),
                .float_8   ( inputs[(j*10)+8] ),
                .float_9   ( inputs[(j*10)+9] ),
                .sample_no ( j                )
            );     
            #1;   
        end
        
        $display("-------- Pass count = %5d --------", pass_count);

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
    

    //  +---------------+
    //  |   Test task   |
    //  +---------------+
    //
    task softmax_op(shortreal float_0, float_1, float_2, float_3, float_4, float_5, float_6, float_7, float_8, float_9, integer sample_no);
        shortreal act, max;
        integer i, max_in;
    
        $display("\n\n+---------------------------------------------------+");
        $display("|  softmax_op task invoked for sample number %5d  |", sample_no+1);
        $display("+---------------------------------------------------+");
        $display("|");
        $display("| Input value 1  = %0f", float_0);
        $display("| Input value 2  = %0f", float_1);
        $display("| Input value 3  = %0f", float_2);
        $display("| Input value 4  = %0f", float_3);
        $display("| Input value 5  = %0f", float_4);
        $display("| Input value 6  = %0f", float_5);
        $display("| Input value 7  = %0f", float_6);
        $display("| Input value 8  = %0f", float_7);
        $display("| Input value 9  = %0f", float_8);
        $display("| Input value 10 = %0f", float_9);
        $display("|");

    
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
        
        act = 0;
        max = 0;
        max_in = 0;
        
        for (i = 0; i < IN_OUT_NUM; i = i + 1) begin
            act = bin2float(out[i*16 +: 16]);
            if(max < act) begin
                max = act;
                max_in = i+1;
            end
            #1;
        end
    
        $display("|  image match = %0d, \t expected image match = %0d", max_in, results[sample_no]);
        $display("+---------------------------------------------------+");

        if(max_in == results[sample_no]) begin
            pass_count = pass_count + 1;
        end else begin
            pass_count = pass_count;
        end
        
        @(posedge clk) clear <= 1'b1;
        @(posedge clk) clear <= 1'b0;
    endtask

    //  +--------------------------------+
    //  |    input value loading task    |
    //  +--------------------------------+
    
    task load_inputs();
        begin
            input_file = $fopen("test_images_softmax_input.txt", "r");
    
            if (input_file == 0) begin
                $display("Cannot find the input file");
                $finish();
            end else begin
                while (!$feof(input_file)) begin
                    inputs = new [$size(inputs)+1] ( inputs );
                    scanRet_in = $fscanf(input_file, "%f", inputs[$size(inputs)-1]);
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
            result_file = $fopen("test_images_expected_output.txt", "r");
    
            if (result_file == 0) begin
                $display("Cannot find the result file");
                $finish();
            end else begin
                while (!$feof(result_file)) begin
                    results = new [$size(results)+1] ( results );
                    scanRet_res = $fscanf(result_file, "%d", results[$size(results)-1]);
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
