`timescale 1ns/1ps

module tb;

    reg [7:0] a;
    reg [7:0] b;
    int c;
    int d;

    initial begin
        a = 12;
        b = 34;
        c = 67;
        d = 255;
    end

    initial begin
        #12
        $display("a : %0d, b : %0d, c : %0d, d : %0d", a, b, c, d);
    end
endmodule