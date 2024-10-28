module dut(input logic clk, rst, [7:0] data_in, 
           output logic [7:0] data_out);
    
    // Simple DUT that just passes the input data to the output data
    always_ff @(posedge clk) begin
        if (rst) begin
            data_out <= 8'b0;
        end else begin
            data_out <= data_in;
        end
    end
endmodule

module tb();
    // Declare inputs and outputs
    logic clk;
    logic rst;
    logic [7:0] data_in;
    logic [7:0] data_out;

    // Clock generator
    always #(5ns) clk = ~clk;

    // Instantiate DUT
    dut u_dut(clk, rst, data_in, data_out);

    // Random input generator
    initial begin
        // Reset DUT
        rst = 1;
        @ (posedge clk); // @(posedge clk); 讓程式等到 clk 的正邊沿發生時才繼續執行，這是 SystemVerilog 同步設計中常用的技巧，用來確保各種操作與時鐘信號保持同步。
        rst = 0;

        // Loop over a set number of test iterations
        for (int i = 0; i < 100; i++) begin
            // Generate random input data
            data_in = $random;

            // Wait a few clock cycles
            repeat (10) @ (posedge clk);

            // Check that DUT output matches input data
            if (data_out !== data_in) begin
                $error("DUT output does not match input data");
            end
        end
    end 
endmodule