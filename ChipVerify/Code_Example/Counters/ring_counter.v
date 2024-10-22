module ring_counter #(parameter WIDTH = 4) (input clk, rstn, output reg [WIDTH - 1 : 0] out);

    always @ (posedge clk) begin
        if (!rstn)
            out <= 1;
        else begin
            out[WIDTH - 1] <= out[0];
            for (int i = 0; i < WIDTH - 1; i++) begin
                out[i] <= out[i + 1];
            end
        end
    end
endmodule

module tb;
    parameter WIDTH = 4;

    reg clk, rstn;
    wire [WIDTH - 1 : 0] out;

    ring_counter u1 (.clk(clk), .rstn(rstn), .out(out));

    always #5 clk = ~clk;

    initial begin
        clk <= 0;
        rstn <= 0;

        $monitor ("T = %0t out=%0b", $time, out);
        repeat (2) @(posedge clk);
        rstn <= 1;
        repeat (15)@(posedge clk);
        $finish;
    end


endmodule