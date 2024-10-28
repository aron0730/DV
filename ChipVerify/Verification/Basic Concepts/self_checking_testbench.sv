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

    // Test data
    int test_data[4] = '{0, 1, 2, 3};  //System Verilog語法, 這樣初始話更好

    // Test loop
    initial begin
        // Reset DUT
        rst = 1;
        @(posedge clk);
        rst = 0;

        // Loop over test data
        for (int i = 0; i < 4; i++) begin
            // Set input data
            data_in = test_data[i];

            // Wait for output data
            @(posedge clk); // Wait for one clock cycle

            // Check output data
            if (data_out !== (test_data[i])) begin
                $error("Incorrect output data");
            end
        end

        // Finish test
        $display("Test passed");
        $finish;
    end
endmodule