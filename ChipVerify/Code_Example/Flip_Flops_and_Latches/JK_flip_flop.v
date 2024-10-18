module jk_ff (input j, k, clk, 
              output q);

    reg q;

    always @ (posedge clk) begin
        case ({j, k})

            2'b00 : q <= q;
            2'b01 : q <= 0;
            2'b10 : q <= 1;
            2'b11 : q <= ~q;
        endcase
    end
endmodule


module tb;
    reg j, k, clk;
    wire q;
    integer i;

    always #5 clk = ~clk;

    jk_ff jk0 (.j(j), .k(k), .clk(clk), .q(q));

    initial begin
        j <= 0;
        k <= 0;
        clk <= 0;  // initial clock

        for (i = 0; i < 4; i++) begin
            {j, k} <= i;
            #10;
        end

        #15;
        $finish;
    end

    initial begin
        $monitor ("j=%0d k=%0d q=%0d", j, k, q);
    end
endmodule


module tb;
    reg j, k, clk;
    wire q;
    integer i;

    always #5 clk = ~clk;

    jk_ff jk0 (.j(j), .k(k), .clk(clk), .q(q));

    initial begin
        j <= 0;
        k <= 0;
        clk <= 0;  // initial clock

        #5;
        j <= 0;
        k <= 1;

        #20;
        j <= 1;
        k <= 0;

        #30;
        j <= 1;
        k <= 1;

        #15;
        $finish;

    end

    initial begin
        $monitor ("j=%0d k=%0d q=%0d", j, k, q);
    end
endmodule