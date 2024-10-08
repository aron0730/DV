module tb;
    reg d, clk;
    reg [1:0] dly;
    wire q;
    integer i;

    d_flop u_flop(q, clk, d);

    $monitor ("[T=%0t] clk=%0b d=%0b q=%0b", $time, clk, d, q);

    #10;  // To see the effect of X

    for (i = 0; i < 20; i = i + 1) begin
        dly = $random;
        repeat (dly) @ (posedge clk);
        d <= $random;
    end

    #20 $finish;
endmodule

primitive d_flop (q, clk, d);
    output reg q;
    input  clk, q;

    table
        //  clk     d       q       q+
            (01)    0   :   ?   :   0;
            (01)    1   :   ?   :   1;
            (0?)    1   :   1   :   1;
            (0?)    0   :   0   :   0;

            (?0)    ?   :   ?   :   -;

            ?       (??):   ?   :   -;
    endtable
endprimitive