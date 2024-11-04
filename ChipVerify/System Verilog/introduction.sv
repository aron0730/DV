module d_ff (input clk, rstn, d, 
             output reg q);

    always @ (posedge clk) begin
        if (!rstn) begin
            q <= 0;
        end else begin
            q <= d;
        end
    end

endmodule

module tb_top();
    reg clk, rstn, d;
    wire q;

    d_ff dut (.clk(clk), .rstn(rstn), .d(d), .q(q));
    
    always #5 clk = ~clk;

    initial begin
        {clk, rstn, d} <= 0;
        #10 rstn <= 1;
        #5  d <= 1;
        #8  d <= 0;
        #2  d <= 1;
        #10 d <= 0;
    end
endmodule