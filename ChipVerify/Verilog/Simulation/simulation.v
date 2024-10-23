module tb;
    reg clk;
    reg sig;

    always clk = ~clk;

    initial begin
        $monitor ("Time=%0t clk=%0d sig=%0d", $time, clk, sig);

        sig = 0;
        #5 clk = 0;   // Assign clk to 0 at time 5ns
        #15 sig = 1;  // Assign sig to 1 at time 20ns (#5 + #15)
        #20 sig = 0;  // Assign sig to 0 at time 40ns (#5 + #15 + #20)
        #15 sig = 1;  // Assign sig to 1 at time 55ns (#5 + #15 + #20 + #15)
        #10 sig = 0;  // Assign sig to 0 at time 65ns (#5 + #15 + #20 + #15 + #10)
        #20 $finish;  // Finish simulation at time 85ns
    end
endmodule