module counter(input clk, reset, output reg [7:0] count);
    always @ (posedge clk) begin
        if (reset) begin
            count <= 8'h00;
        end else begin
            count <= count + 1;
        end
        
    end 
endmodule

module counter_tb()
    reg clk = 0;
    reg reset = 0;
    wire [7:0] count;
    counter dut(clk, reset, count);

    initial begin
        $monitor("Count = %h", count);
        reset = 1;
        #10;
        reset = 0;
    end
    always %5 clk = ~clk;
endmodule