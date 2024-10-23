module counter (input clk, rstn, 
                output reg [3:0] out);

    // This alywas block will be triggered at the rising edge of clk (0->1)
    // Once inside this block, it checks if the reset is 0, if yes then change out to zero
    // If reset is 1, then design should be allowed to count up, so increment counter

    always @ (posedge clk) begin
        if (!rstn)
            out <= 0;
        else 
            out <= out + 1;
    end
endmodule

module tb;
    reg clk, rstn;
    wire [3:0] out;

    // Instantiate counter design and connect with Testbench variables
    counter c0(.clk(clk), .rstn(rstn), .out(out));

    // Generate a clock that should be driven to design
    // This clock will flip its value every 5ns -> time period = 10ns -> freq = 100Hz
    always #5 clk = ~clk;

    // This initial block forms the stimulus of the testbench
    initial begin
        // 1. Initialize testbench variables to 0 at start of simulation
        {clk, rstn} <= 0;

        // 2. Drive rest of the stimulus, reset is asserted in between
        #20 rstn <= 1;
        #80 rstn <= 0;
        #50 rstn <= 1;

        // 3. Finish the stimulus after 200ns
        #20 $finish;
    end
endmodule