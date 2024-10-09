module counter (input           up_down,
                                clk,
                                rstn,
                output reg[2:0] out);
    
    always @(posedge clk) begin
        if (!rstn) 
            out <= 0
        else begin
            if (up_down)
                out <= out + 1;
            else 
                out <= out - 1;
        end
    end
endmodule
