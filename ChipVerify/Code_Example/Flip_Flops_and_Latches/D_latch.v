module d_latch (input d, en, rstn, 
                output reg q);

    // This always block is "always" triggered whenever en/rstn/d changes
    // If reset is asserted then output will be zero
    // Else as long as enable is high, output q follows input d

    always @ (en or rstn or d)
        if (!rstn)
            q <= 0;
        else 
            if (en)
                q <= d;

endmodule


module tb_latch;

    reg d, clk, rstn, en;
    reg [2:0] delay;
    reg [1:0] delay2;
    integer i;

    // Instantiate design and connect design ports with TB signals
    d_latch dl0(.d(d), .en(en), .en(en), .q(q));

    // This initial block forms the stimulus to test the design
    initial begin
        $monitor("[T=%0t] en=%0b d=%0b q=%0d", $time, en, d, q);

        // 1. Initialize testbench variables
        d <= 0;
        en <= 0;
        rstn <= 0;

        // 2. Release reset
        #10 rstn <= 1;

        // 3. Randomly change d and enable
        for (i = 0; i < 5; i++) begin
            delay = $random;
            delay2 = $random;
            #(delay2) en = ~en;
            #(delay) d <= i;
        end
    end

endmodule