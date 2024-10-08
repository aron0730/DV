// 4x2 Encoder
module enc_4x2 (input a, b, c, d, output x, y);

    or (x, b, d);
    or (y, c, d);
endmodule

module tb;
    reg a, b, c, d;
    wire x, y;
    integer i;

    enc_4x2 u0 (.a(a). .b(b), .c(c), .d(d), .x(x), .y(y));

    initial begin
        {a, b, c, d} <= 0;

        $monitor("[T=%0t] a=%0b b=%0b c=%0b d=%0b x=%0b y=%0b", $time, a, b, c, d, x, y);

        for (i = 0; i <= 16; i++) begin
            #1;
            {a, b, c, d} <= i;
        end
    end
endmodule
