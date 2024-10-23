module mux_2x1 (input a, b, sel,
                output out);

    wire sel_n;
    wire out_0, out_1;

    not (sel_n, sel);

    and (out_0, a, sel);
    and (out_1, b, sel_n);

    or (out, out_0, out_1);
endmodule

module tb;
    reg a, b, sel;
    wire out;
    integer i;

    mux_2x1 u0 (.a(a), .b(b), .sel(sel), .out(out));

    initial begin
        $monitor("T=%0t a=%0b b=%0b sel=%0b out=%0b", $time, a, b, sel, out);

        for (i = 0; i < 10; i = i + 1) begin
            #1;
            a <= $random;
            b <= $random;
            sel <= $random;
        end
    end
endmodule