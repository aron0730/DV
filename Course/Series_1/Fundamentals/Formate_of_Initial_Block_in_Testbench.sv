`timescale 1ns/1ps

module tb();
    reg a = 0;

    initial a = 1;

    initial begin
        a = 1;
        #10
        a = 0;
    end
endmodule