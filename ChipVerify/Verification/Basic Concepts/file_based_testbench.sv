module tb_and;
    
    // Declare input and output signals
    reg [3:0] A, B;
    wire [3:0] C;

    // Instantiate the circuit under test
    and_4bit dut (.A(A), .B(B), .C(C));

    // Open the input/output file
    integer test_file;
    initial begin
        test_file = $fopen("test_data.txt", "r");
        if (test_file == 0) begin
            $fatal("ERROR: Could not open test_data.txt");
        end
    end

    // Read and apply the input vectors and expected output values
    integer line_num = 0;
    integer errors = 0;
    initial begin
        while(!$feof(test_file)) begin
            line_num++;
            $fscanf(test_file, "%b,%b,%b", A, B, C);
            #1;
            if (C !== A & B) begin
                $display("ERROR in line %d: Expected C=%b, but got C=%b", line_num, A&B, C);
                errors++;
            end
        end

        if (errors == 0) begin
            $display("All tests passed!");
        end else begin
            $display("%d errors found in %d tests", errors, line_nus);
        end

    end

    // Close the input/output file
    initial begin
        $fclose(test_file);
    end

endmodule


module tb_and1;
    // Declare input and output signals
    reg [3:0] A, B;
    wire [3:0] C;

    // Instantiate the device under test (DUT)
    and_4bit dut (
        .A(A),
        .B(B),
        .C(C)
    );

    // Open the input/output file
    integer test_file;
    initial begin
        test_file = $fopen("test_data.txt", "r");
        if (test_file == 0) begin
            $fatal("ERROR: Could not open test_data.txt");
        end
    end

    // Read and apply input vectors and expected output values
    integer line_num = 0;
    integer errors = 0;
    reg [3:0] expected_C; // Store the expected C value

    initial begin
        while (!$feof(test_file)) begin
            line_num++;
            // Read A, B values and expected C value from the file
            $fscanf(test_file, "%b,%b,%b", A, B, expected_C);
            #1; // Wait for one time unit to allow DUT to process inputs

            // Compare DUT output C with the expected C value
            if (C !== expected_C) begin
                $display("ERROR in line %d: Expected C=%b, but got C=%b", line_num, expected_C, C);
                errors++;
            end
        end

        if (errors == 0) begin
            $display("All tests passed!");
        end else begin
            $display("%d errors found in %d tests", errors, line_num);
        end
    end

    // Close the file
    initial begin
        #100;
        $fclose(test_file);
    end
endmodule
