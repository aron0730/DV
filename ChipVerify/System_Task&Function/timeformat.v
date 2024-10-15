`timescale 1ns/1ps
// $timeformat (<unit_number>, <precision>, <suffix_string>, <minimum field width>);

module tb;
    bit a;

    initial begin
        #10.512351

        $display("[T=%0t] a=%0b", $realtime, a);
        // log : [T=10512] a=0

        $timeformat(-9, 2, " ns");
        $display("[T=%0t] a=%0b", $realtime, a);
        // log : [T=10.51 ns] a=0

        $timeformat(-9, 5, "ns");
        $display("[T=%0t] a=%0b", $realtime, a);
        // log : [T=10.51200ns] a=0

        $timeformat(-12, 3, " ns");
        $display("[T=%0t] a=%0b", $realtime, a);
        // log : [T=10512.000 ns] a=0

        $timeformat(-12, 2, " ps");
        $display("[T=%0t] a=%0b", $realtime, a);
        // log : [T=10512.00 ps] a=0
    end
endmodule

`timescale 1ns/100ps
// $timeformat (<unit_number>, <precision>, <suffix_string>, <minimum field width>);

module tb;
    bit a;

    initial begin
        #10.512351

        $display("[T=%0t] a=%0b", $realtime, a);
        // log : [T=105] a=0

        $timeformat(-9, 2, " ns");
        $display("[T=%0t] a=%0b", $realtime, a);
        // log : [T=10.50 ns] a=0

        $timeformat(-9, 5, "ns");
        $display("[T=%0t] a=%0b", $realtime, a);
        // log : [T=10.50000ns] a=0

        $timeformat(-12, 3, " ns");
        $display("[T=%0t] a=%0b", $realtime, a);
        // log : [T=10500.000 ns] a=0

        $timeformat(-12, 2, " ps");
        $display("[T=%0t] a=%0b", $realtime, a);
        // log : [T=10500.00 ps] a=0
    end
endmodule