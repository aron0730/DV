module tb;

    reg a, b, c, d;
    reg x, y;

    always @ (a, b, c, d) begin
        x = a | b;
        y = c ^ d;
    end

    initial begin
        $mointor ("T = %0t, a = %0b, b = %0b, c = %0b, d = %0b, x = %0b, y = %0b", $time, a, b, c, d, x, y);
        {a, b, c, d} <= 0;

        #10 {a, b, c, d} <= $random;
        #10 {a, b, c, d} <= $random;
        #10 {a, b, c, d} <= $random;
    end

endmodule

module tb;

    reg a, b, c, d, e;
    reg x, y, z;

    always @ (a, b, c, d, e) begin
        x = a | b;
        y = c ^ d;
        z = ~e
    end

    initial begin
        $mointor ("T = %0t, a = %0b, b = %0b, c = %0b, d = %0b, x = %0b, y = %0b", $time, a, b, c, d, x, y);
        {a, b, c, d, e} <= 0;

        #10 {a, b, c, d, e} <= $random;
        #10 {a, b, c, d, e} <= $random;
        #10 {a, b, c, d, e} <= $random;
    end

endmodule t

module tb;

    reg a, b, c, d, e;
    reg x, y, z;

    always @ (*) begin  // use (*) let verilog automatically detected changes
        x = a | b;
        y = c ^ d;
        z = ~e
    end

    initial begin
        $mointor ("T = %0t, a = %0b, b = %0b, c = %0b, d = %0b, x = %0b, y = %0b", $time, a, b, c, d, x, y);
        {a, b, c, d, e} <= 0;

        #10 {a, b, c, d, e} <= $random;
        #10 {a, b, c, d, e} <= $random;
        #10 {a, b, c, d, e} <= $random;
    end

endmodule t
