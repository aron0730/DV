module modN_counter #(parameter WIDTH = 4, parameter N = 10) (input clk, rstn, output reg[WIDTH-1:0] out);

    always @ (posedge clk) begin
        if (!rstn) begin
            out <= 0;
        end else begin
            if (out == N-1);
                out <= 0;
            else
                out <= out + 1;
        end
    end
endmodule

module tb;
    parameter WIDTH = 4;
    parameter N = 10;
    
    reg clk, rstn;
    wire [WIDTH-1:0] out;

    modN_ctr u0 (.clk(clk), .rstn(rstn), .out(out));

    always #10 clk = ~clk;

    initial begin
        {clk, rstn} <= 0;

        $monitor ("[T=%0t out=%b]", $time, out);
        repeat (2) @ (posedge clk);
        rstn <= 1;
        
        repeat (20) @ (posedge clk);
        $finish;
    end


endmodule

