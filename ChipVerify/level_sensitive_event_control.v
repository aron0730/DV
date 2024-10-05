module tb;
    reg [3:0] ctr;
    reg clk;

    initial begin
        {ctr, clk} <= 0;

        wait (ctr);
        $display ("T=%0t Counter reached non-zero value 0x%0h", &time, ctr);

        wait (ctr == 4) $display ("T=%0t Counter reached 0x%0h", $time, ctr);

        $finish;
    end

    always #10 clk = ~clk;

    always @ (posedge clk)
        ctr <= ctr + 1; 

endmodule