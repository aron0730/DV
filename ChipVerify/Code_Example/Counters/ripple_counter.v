module dff (input d, clk, rstn, 
            output reg q, qn);

    always @ (posedge clk or negedge rstn)
        if (!rstn) begin
            q <= 0;
            qn <= 1;
        end else begin
            q <= d;
            qn <= ~d;
        end

endmodule

module ripple (input clk, rstn, 
               output [3:0] out);

    wire q0, qn0, q1, qn1, q2, qn2, q3, qn3;

    dff dff0(.d(qn0), .clk(clk), .rstn(rstn), .q(q0), .qn(qn0));
    dff dff1(.d(qn1), .clk(q0), .rstn(rstn), .q(q1), .qn(qn1));
    dff dff2(.d(qn2), .clk(q1), .rstn(rstn), .q(q2), .qn(qn2));
    dff dff3(.d(qn3), .clk(q2), .rstn(rstn), .q(q3), .qn(qn3));

    assign out = {qn3, qn2, qn1, qn0};

endmodule

module tb_ripple;


endmodule


module tb_ripple;

    reg clk;
    reg rstn;
    wire [3:0] out;

    // 實例化 ripple counter
    ripple uut (.clk(clk), .rstn(rstn), .out(out));

    // 時鐘信號生成
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 周期為10時間單位
    end

    // 復位信號生成
    initial begin
        rstn = 0;
        #20 rstn = 1;  // 20個時間單位後釋放復位
    end

    // 监控信号变化
    initial begin
        $monitor("Time: %0t | out = %b", $time, out);
    end

    // 模擬結束控制
    initial begin
        #200 $finish;  // 在200個時間單會後結束模擬
    end

endmodule