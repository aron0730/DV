`timescale 1ns/1ps

class generator;
    rand bit [7:0] x, y, z;

endclass

module tb;
    generator g;

    initial begin
        g = new();

        for (int i = 0; i < 20; i++) begin
            assert(g.randomize()) else $display("Failed to randomize");
            $display("[ %0t ] Value of x : %0d, y : %0d, z : %0d", $time, g.x, g.y, g.z);
            #20;
        end
    end
endmodule