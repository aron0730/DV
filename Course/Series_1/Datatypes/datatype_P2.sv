`timescale 1ns/1ps

module tb;
    byte var1 = -126;  // -128 to 127
    bit [7:0] var2 = 130;  // 0 to 255

    initial begin
        #10;
        $display("value of VAR1 : %0d", var1);
        $display("value of VAR2 : %0d", var2);
    end

    shorting var3 = 0;



endmodule