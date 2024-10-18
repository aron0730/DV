module tff (input t, rstn, clk, 
            output reg q);

    always @ (posedge clk) begin
        if (!rstn)
            q <= 0;
        else
            if (t)
                q <= ~q;
            else
                q <= q;  // can ignore
    end
endmodule


module tb;
    reg t, rstn, clk;
    wire q;
    reg [4:0] delay;

    tff u0 (.t(t), .rstn(rstn), .clk(clk), .q(q));

    always #5 clk = ~clk;

    initial begin
        {t, rstn, clk} = 0;
        
        $monitor("T=%0t rstn=%0b t=%0d q=%0d", $time, rstn, t, q);
        repeat(2) @ (posedge clk);
        rstn <= 1;

        for (integer i = 0; i < 20; i++) begin
            delay = $random % 32;
            #(delay) t <= $random % 2;
        end
        #20 $finish;
    end
endmodule