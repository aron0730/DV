module gates (input a, b,
              output c, d, e);

    nand (c, a, b);  // c is the output, a and b are inputs
    nor  (d, a, b);  // d is the output, a and b are inputs
    xnor (e, a, b);  // e is the output, a and b are inputs
endmodule

module tb;
    reg a, b;
    wire c, d, e;

    gates u0 (.a(a), .b(b), .c(c), .d(d), .e(e));

    initial begin
        {a, b} = 0;
        
        $monitor ("[T=%0t a=%0b b=%0b c=%0b d=%0b e=%0b]", $time, a, b, c, d, e);

        for (i = 0; i < 10' i = i + 1) begin
            #1;
            a <= $random;
            b <= $random;
        end
    end

endmodule