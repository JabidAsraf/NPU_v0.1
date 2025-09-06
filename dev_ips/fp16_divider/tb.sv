module fp16_divider_tb;
  
reg                clk;
reg                reset_b;
reg         [15:0] a;
reg         [15:0] b;
reg                start;
reg                clear;
wire               valid;
wire        [15:0] out; 
  
shortreal i, j;
shortreal max_err = 0;

fp16_divider dut(
    .clk(clk),
    .reset_b(reset_b),
    .input_a(a),
    .input_b(b),
    .start(start),
    .clear(clear),
    .valid(valid),
    .result(out)
);  

initial begin
    clk <= 0;
    forever #5 clk <= ~clk;
end
  
initial begin
    $write("%c[1;34m",27);

    reset();
    for(i = 1; i <= 512; i = i + 2) begin
        for(j = 1; j <= 512; j = j + 2) begin
            div_op(i, j);
        end
    end

    $write("%c[0m",27);

    #20 $stop;
end
  
initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
end

task reset();
    reset_b   <=  1'b0;
    a         <=  16'd0;
    b         <=  16'd0;
    start     <=  1'b0;
    clear     <=  1'b0;
    @(posedge clk) reset_b <= 1'b1;
endtask

task div_op(shortreal float_a, shortreal float_b);
    shortreal exp, act, err;
    a         <=  float2bin(float_a);
    b         <=  float2bin(float_b);
    start     <=  1'b1;
    @(posedge clk) start <= 1'b0;
    wait(valid);
    @(posedge clk) clear <= 1'b1;
    @(posedge clk) clear <= 1'b0;
    exp = (float_a/float_b);
    act = bin2float(out);
    err = (exp > act) ? (exp - act) : (act - exp);
    if (((err/exp)*100) > 12.4) begin
        $display("-------------------------------------------------------------------------------------------------------------");
        $display("input a in binary         = %16b :: input a in float         = %0f",   a,              float_a);
        $display("input b in binary         = %16b :: input b in float         = %0f",   b,              float_b);
        //$display("mantisa of input a        = %0d  :: mantisa off input b      = %0d",   a[9:0],         b[9:0] );
        $display("expected output in binary = %16b :: expected output in float = %0f",   float2bin(exp), exp);
        $display("actual output in binary   = %16b :: actual output in float   = %0f\n",   out,            act);
        $display("error absolute            = %0f", err);    
        $display("error percentage          = %0f", ((err/exp)*100));    
        $display("-------------------------------------------------------------------------------------------------------------\n\n");
    end
endtask

function [15:0] float2bin (shortreal float_a);
    logic [31:0] fp32;
    logic [7:0]  exp_temp;
    logic [22:0] man_temp;

    fp32     [31:0] = $shortrealtobits(float_a);
    exp_temp [7:0]  = fp32[30:23] - 8'd127 + 8'd15;
    man_temp [22:0] = fp32[22:0];

    return {fp32[31], exp_temp[4:0], man_temp[22:13]};
endfunction

function shortreal bin2float (logic [15:0] fp16);
    logic [31:0] fp32;
    logic [7:0]  exp_temp;
    logic [22:0] man_temp;

    exp_temp [7:0]  = {3'd0, fp16[14:10]} - 8'd15 + 8'd127;
    man_temp [22:0] = {fp16[9:0],13'd0};
    fp32     [31:0] = {fp16[15], exp_temp[7:0], man_temp[22:0]};

    return $bitstoshortreal(fp32[31:0]);
endfunction
  
endmodule
