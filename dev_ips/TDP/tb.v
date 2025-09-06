`timescale 1ns/1ps

module tb;

reg          clk;
reg          wea;
reg  [14:0]  addra;
reg  [15:0]  dina;
reg          web;
reg  [14:0]  addrb;
reg  [15:0]  dinb;

wire [15:0]  douta;
wire [15:0]  doutb;

dummy_tdp tdp 
(  
    .clka  (  clk   ),
    .wea   (  wea   ),
    .addra (  addra ),
    .dina  (  dina  ),
    .douta (  douta ),
    .clkb  (  clk   ),
    .web   (  web   ),
    .addrb (  addrb ),
    .dinb  (  dinb  ),
    .doutb (  doutb )
);

initial begin
    clk = 0; addra = 0; addrb = 0; dina = 0; dinb = 0; wea = 0; web = 0;
    forever #5 clk = ~clk;
end

initial begin
    @(posedge clk) addra = 15'd10; dina = 16'd232; wea = 1'b1; addrb = 15'd0;  dinb = 16'd0;   web = 1'b0;
    @(posedge clk) addra = 15'd0;  dina = 16'd0;   wea = 1'b0; addrb = 15'd9;  dinb = 16'd332; web = 1'b1; 
    @(posedge clk) addra = 15'd0;  dina = 16'd0;   wea = 1'b0; addrb = 15'd0;  dinb = 16'd0;   web = 1'b0;
    repeat(10) begin
        @(posedge clk);
    end 
    @(posedge clk) addrb = 15'd10; addra = 15'd9;
    @(posedge clk);
end

initial begin
    $monitor("time: %6t,\taddra: %d,\taddrb: %d,\tdina: %d,\tdinb: %d,\twea: %b,\tweb: %b,\t\tdouta: %d,\tdoutb: %d", $time, addra, addrb, dina, dinb, wea, web, douta, doutb);
    $dumpfile("dump.vcd");
  	$dumpvars;
    #200 $finish;
end

endmodule
