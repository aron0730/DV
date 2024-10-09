module gates (input a, 
              output c, d);

    buf (c, a);  // c is the output, a is input
    not (d, a);  // d is the output, a is input
endmodule

module tb;
    reg a;
    wire c, d;

    initial begin
        a = 0;
        $monitor ("[T=%0t] a=%0b c(buf)=%0b d(not)=%0b", $time, a, c, d);

        for (i = 0; i < 10; i = i + 1) begin
            #1;
            a <= $random;
        end
    end
endmodule