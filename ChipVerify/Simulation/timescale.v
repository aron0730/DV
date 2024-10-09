`timescale 1ns/1ns
// `timescale 10ns/1ns
// `timescale 1ns/1ps

module tb;
    reg val;

    initial begin

        val <= 0;

        #1  $display ("T=%0t At time #1", $realtime);
        val <= 1;

        #0.49   $display ("T=%0t At time #0.49", $realtime);
        val <= 0;

        #0.50   $display ("T=%0t At time #0.50", $realtime);
        val <= 1;

        #0.51   $display ("T=%0t At time #0.51", $realtime);
        val <= 0;

        #5 $display ("T=%0t End of simulation", $realtime);
    end
endmodule















// `timescale <time_unit> / <time_precision>

// // Example
// `timescale 1ns / 1ps
// `timescale 10us / 100ns
// `timescale 10ns / 1ns

