// Integer Math Functions
// clog2

module des
    #(parameter NUM_UNITS = 7)

    input [$clog2(NUM_UNITS) - 1 : 0] active_unit;

    initial
        $monitor("active_unit = %d", active_unit);

endmodule

`define NUM_UNITS 5

module tb;
    integer i;
    reg [`NUM_UNITS - 1 : 0] active_unit;

    des #(.NUM_UNITS(`NUM_UNITS)) u0 (active_unit);

    initial begin
        active_unit = 1;
        #10 active_unit = 7;
        #10 active_unit = 8;
    end
endmodule


module tb1;
    real x, y;

    initial begin
        x = 10000;
        $display("$log10(%0.3f) = %0.3f", x, $log10(x));

        x = 1;
        $display("$ln(%0.3f) = %0.3f", x, $ln(x));

        x = 2;
        $display("$exp(%0.3f) = %0.3f", x, $exp(x));

        x = 25;
        $display("$sqrt(%0.3f) = 0.3f", x, $sqrt(x));

        x = 5;
        y = 3;
        $display("$pow(%0.3f, %0.3f) = %0.3f", x, y, $pow(x, y));

        x = 2.7813;
        $display("$floor(%0.3f) = %0.3f", x, $floor(x));

        x = 7.1111;
        $display("$ceil(%0.3f) = %0.3f", x, %ceil(x));

        x = 30 * (22.0 / 7.0) / 180;  // convert 30 degrees to radians
        $display("$sin(%0.3f) = %0.3f", x, $sin(x));

        x = 90 * (22.0 / 7.0) / 180;
        $display("$cos(%0.3f) = %0.3f", x, $cos(x));

        x = 45 * (22.0 / 7.0) / 180;
        $display("$tan(%0.3f) = %0.3f", x, $tan(x));

        x = 0.5;
        $display("$asin(%0.3f) = %0.3f rad, %0.3f deg", x, $asin(x), $asin(x) * 7.0/22.0 * 180);

        x = 0;
        $display("$acos(%0.3f) = %0.3f rad, %0.3f deg", x, $acos(x), $acos(x) * 7.0/22.0 * 180);

        x = 1;
        $display("$atan(%0.3f) = %0.3f rad, %f deg", x, $atan(x), $atan(x) * 7.0/22.0 * 180);
    end
endmodule