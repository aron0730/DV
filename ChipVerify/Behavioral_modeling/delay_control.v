`timescale 1ns/1ps

module tb;
    reg [3:0] a, b;

    initial begin
        {a, b} <= 0;
        $display("T=%0t, a=%0d b=%0d", $realtime, a, b);

        #10;
        a <= $random;
        $display("T=%0t, a=%0d b=%0d", $realtime, a, b);

        #10 b <= $random;
        $display("T=%0t, a=%0d b=%0d", $realtime, a, b);

        #(a) $display("T=%0t After a delay of a=%0d units", $realtime, a);
        #(a+b) $display("T=%0t After a delay of a=%0d + b=%0d units", $realtime, a, b);
        #((a+b)*10ps) $display("T=%0t After a delay of %0d * 10ps", $realtime, a+b);
        #(b-a) $display("T=%0t Expr evaluates to a negative delay", $realtime);
        #('h10) $display("T=%0t Delay in hex", $realtime);

        a='hX;
        #(a) $display("T=%0t Delay is unknown, taken as zero a=%h", $realtime, a);

        a='hZ;
        #(a) $display("T=%0t Delay is in high impedance, taken as zero a=%h", $realtime, a);

        #10ps $display("T=%0t Delay of 10ps", $realtime);

    end
endmodule