// Example 1
module tb;
    bit a, b;
    bit clk;

    always #10 clk = ~clk;

    initial begin
        for (int i = 0; i < 10; i++) begin
            @(posedge clk);
            a <= $random;
            b <= $random;
            $display("[%0t] a=%0b b=%0b", $time, a, b);
        end

        #10 $finish;
    end

    // This assertion runs for entire duration of simulation
    // Ensure that both signals are high at posedge clk
    assert property (@(posedge clk) a & b);  // 斷言：檢查 a 和 b 在時鐘正緣前是否為高電平
endmodule

// Example 2
module tb;
    bit a, b;
    bit clk;

    always #10 clk = ~clk;

    initial begin
        for (int i = 0; i < 10; i++) begin
            @(posedge clk);
            a <= $random;
            b <= $random;
            $display("[%0t] a=%0b b=%0b", $time, a, b)
        end

        #10 $finish;
    end

    // This assertion runs for entire duration of simulation
    // Ensure that atleast 1 of the two signals is high on every clk
    assert property (@(posedge clk) a | b);

endmodule

// Example 3
module tb;
    bit a, b;
    bit clk;

    always #10 clk = ~clk;

    initial begin
        for (int i = 0; i < 10; i++) begin
            @(posedge clk);
            a <= $random;
            b <= $random;
            $display("[%0t] a=%0b b=%0b", $time, a, b);
        end
        #10 $finish;
    end

    // This assertion runs for entire duration of simulation
    // Ensure that atleast 1 of the two signals is high on every clk
    assert property (@(posedge clk) !(!a ^ b));

endmodule

