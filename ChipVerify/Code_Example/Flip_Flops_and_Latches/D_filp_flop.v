module dff (input d, rstn ,clk, 
            output reg q)

    always @ (posedge clk or negedge rstn) begin
        if (!rstn)
            q <= 0;
        else
            q <= d;
    end
endmodule


module dff1 (input d, rstn ,clk, 
             output reg q)

    always @ (posedge clk) begin
        if (!rstn)
            q <= 0;
        else
            q <= d;
    end
endmodule


module tb_dff;
    reg d, rstn, clk;
    reg [2:0] delay;
    wire q;

    dff dff0 (.d(d), .rstn(rstn), .clk(clk), .q(q));

    // Generate clock
    always #10 clk = ~clk;

    // Testcase
    initial begin
        clk <= 0;
        d <= 0;
        rstn <= 0;

        #15 d <= 1;
        #10 rstn <= 1;

        for (int i = 0; i < 5; i++) begin
            delay = $random;
            #(delay) d <= i;
        end
    end
endmodule

/*
dff 是非同步重置：
當 rstn 變低時，無論時鐘的狀態如何，q 都會立即被清零。
dff1 是同步重置：
rstn 的狀態變化只有在時鐘的上升沿被檢測到，q 只有在時鐘上升沿時才會根據 rstn 的值決定是否清零。
*/