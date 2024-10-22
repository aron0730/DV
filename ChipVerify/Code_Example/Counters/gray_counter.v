module gray_counter #(parameter N = 4) (input clk, rstn, output reg [N-1:0] out);

    reg [N-1:0] q;

    always @ (posedge clk) begin
        if (!rstn) begin
            q <= 0;
            out <= 0;
        end else begin
            q <= q + 1;
        
`ifdef FOR_LOOP
            for (int i = 1; i < N-1; i++) begin
                out[i] <= q[i+1]^ q[i];
            end
            out[N-1] <= q[N-1];
`else
            out <= {q[N-1], q[N-1:1] ^ q[N-2:0]};
`endif
          
        end
    end
endmodule


module tb;
    parameter N = 4;
    reg clk, rstn;
    wire [N-1:0] out;

    gray_counter u0 (.clk(clk), .rstn(rstn), .out(out));

    always #5 clk = ~clk;

    initial begin
        $monitor ("[T=%0t rstn=%b out=%b]", $time, rstn, out);

        repeat (2) @ (posedge clk);
        rstn <= 1;

        repeat (20) @ (posedge clk);
        $finish;
    end
endmodule