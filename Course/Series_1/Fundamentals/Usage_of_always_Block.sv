`timescale 1ns/1ps

module tb();

    reg clk;  // x
    reg rst;

    reg clk50;  // for 50MHz clock
    reg clk25;  // for 25MHz clock

    initial begin
        clk = 1'b0;
        rst = 1'b0;
        clk50 = 0;
        clk25 = 0;
    end

    always #5 clk = ~clk;  // 100 MHz

    always #10 clk50 = ~clk50;  // 50 MHz

    always #20 clk25 = ~clk25;  // 25 MHz
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end

    initial begin
        #200;
        $finish;
    end
endmodule