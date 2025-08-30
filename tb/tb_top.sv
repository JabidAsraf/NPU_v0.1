`timescale 1ns/1ps

`include "../include/npu_params.v"

module tb_top;

integer test_dump;
integer test_num;

logic   npu_clk;
logic   npu_reset_b;
logic   npu_spi_sclk;
logic   npu_spi_ss;
logic   npu_spi_mosi;
logic   npu_spi_miso;
logic   npu_done_int;
logic   npu_err_int;

npu_top DUT (
    // global signals
    .npu_clk      (npu_clk     ),
    .npu_reset_b  (npu_reset_b ),
    
    // SPI slave signals
    .npu_spi_sclk (npu_spi_sclk),
    .npu_spi_ss   (npu_spi_ss  ),
    .npu_spi_mosi (npu_spi_mosi),
    .npu_spi_miso (npu_spi_miso),

    // Interrupts
    .npu_done_int (npu_done_int),
    .npu_err_int  (npu_err_int )
);

always begin
    #1 npu_clk = ~npu_clk;
end

initial begin: main_thread
    $write("%c[1;34m",27);
    
    test_dump = $value$plusargs("TEST=%0d", test_num);
    
    reset_all();

    if(test_num == 0) begin: full_test_thread

        print_headline("Full NPU test");
            
    end else if(test_num == 1) begin: reg_int_test_thread

        print_headline("NPU SPI test");   
        write_register(`NPU_IN_NUM_REG_ADDR, 16'h00ff);
        read_register(`NPU_IN_NUM_REG_ADDR);
        
    end
    
    $write("%c[0m",27);
    
    #10 $stop;
end

task reset_all();
    begin
        npu_clk = 0;
        npu_reset_b = 0;
        npu_spi_ss = 1;
        npu_spi_sclk = 0;
        npu_spi_mosi = 0;
        @ (posedge npu_clk) npu_reset_b = 1;
    end
endtask

task spi_8b_tx(logic [7:0] data);
    integer i;
    begin
        @(posedge npu_clk);
        npu_spi_ss = 0;
        for (int i = 0 ; i < 8; i = i + 1) begin
            npu_spi_mosi = data[0];
            @(posedge npu_clk);
            @(posedge npu_clk);
            npu_spi_sclk = 1 ;
            @(posedge npu_clk);
            @(posedge npu_clk);
            npu_spi_sclk = 0 ;
            data = {1'b0,data[7:1]};
        end
        @(posedge npu_clk);
        @(posedge npu_clk);
        npu_spi_ss = 1;
        @(posedge npu_clk);
        @(posedge npu_clk);
     end
endtask 

task spi_16b_tx(logic [15:0] data_16b);
    begin
        spi_8b_tx(data_16b[7:0]);
        spi_8b_tx(data_16b[15:8]);
    end
endtask


logic [15:0] listener_reg;

always @(posedge (~npu_spi_ss & npu_spi_sclk)) begin
    listener_reg <= {npu_spi_miso, listener_reg[15:1]};
end


task write_register(logic [7:0]addr, logic [15:0]data);
    begin
        $display("-------------------- Register Write operation -------------------\n");
        $display("SPI write operation --> Config header write     --> *DATA: 0xffff");
        spi_16b_tx(16'hffff);
        $display("SPI write operation --> Config register address --> *DATA: 0x%2h", addr);
        spi_16b_tx({8'hff, addr});
        $display("SPI write operation --> Config data             --> *DATA: 0x%4h", data);
        spi_16b_tx(data);
        $display("-----------------------------------------------------------------\n");
    end
endtask

task read_register(logic [7:0]addr);
    begin
        $display("-------------------- Register Read operation --------------------\n");
        $display("SPI write operation --> Config header write     --> *DATA: 0xffff");
        spi_16b_tx(16'hffff);
        $display("SPI write operation --> Config register address --> *DATA: 0x%2h", addr);
        spi_16b_tx({8'h00, addr});
        $display("SPI write operation --> dummy write             --> *DATA: 0x0000");
        spi_16b_tx(16'h0000);
        wait(npu_spi_ss);
        $display("SPI miso listener   --> read data               --> *DATA: 0x%4h", listener_reg);    
        $display("-----------------------------------------------------------------\n");
    end
endtask

/*
task write_bram();
    begin
        spi_16b_tx(16'hffff);
        spi_16b_tx();
        spi_16b_tx(16'h00ff);
    end
endtask
*/

task print_headline (string headline);
    integer i, j, length;
    string temp, temp1, temp2;
    begin
        temp = {" # ", headline, " #"};
        temp1 = " #";
        length = headline.len();
        $display("\n\n");
        for (i = 0; i < (length + 3); i = i + 1) begin    
            temp1 = {temp1, "#"};
        end
        $display("%s", temp1);
        $display("%s", temp);
        $display("%s\n\n", temp1);
    end
endtask

endmodule
