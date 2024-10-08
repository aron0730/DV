module gates (input a, b, c, d, 
               output, x, y, z);

    and (x, a, b, c, d);  // x is the output, a, b, c, d are inputs
    or  (y, a, b, c, d);  // y is the output, a, b, c, d are inputs
    nor (z, a, b, c, d);  // z is the output, a, b, c, d are inputs
endmodule


module tb;
    {a, b, c, d} = 0;

    $monitor ("[T=%0t a=%0b b=%0b c=%0b d=%0b e=%0b x=%0b y=%0b z=%0b]", $time, a, b, c, d, e, x, y, z);

    initial begin

        for (i = 0; i < 10; i = i + 1) begin
            #1
            a <= $random;
            b <= $random;
            c <= $random;
            d <= $random;    
        end
    end
endmodule