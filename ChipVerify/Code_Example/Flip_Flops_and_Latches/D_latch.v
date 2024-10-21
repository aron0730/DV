module d_latch (input d, clk, rstn, 
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

    reg d, clk, rstn

endmodule