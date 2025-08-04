`timescale 1ns/1ps

module tb();
    //global signal clk, rst
    reg clk;
    reg rst;

    reg [3:0] temp;

    // 1. Initialized Global Variable
    initial begin
        clk = 1'b0;
        rst = 1'b0;
    end

    // 2. Random signal for data / control
    initial begin
        rst = 1'b1;
        #30;
        rst = 1'b0;
    end

    initial begin
        temp = 4'b0011;
        #10;
        temp = 4'b1111;
        #10;
        temp = 4'b1100;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end

    initial begin
        #200;
        $finish;
    end
endmodule