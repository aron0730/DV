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