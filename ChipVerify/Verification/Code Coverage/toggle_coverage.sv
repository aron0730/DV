module toggle_circuit(input clk, reset, output reg out);
    reg [7:0] counter = 8'h00;

    always @ (posedge clk) begin
        if (reset) begin
            counter <= 8'h00;
        end else begin
            counter <= counter + 1;
        end
    end

    always @ (posedge clk) begin
        out <= ~out;
    end

endmodule

module toggle_circuit_tb();
    reg clk = 0;
    reg reset = 0;
    wire out;
    toggle_circuit dut(clk, reset ,out);

    initial begin
        $monitor("Out = %b", out);
        reset = 1;
        #10;
        reset = 0;
    end

    always #5 clk = ~clk;
endmodule 