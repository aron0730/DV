// Simple Sequence
module tb;
    bit a;
    bit clk;

    // This sequence states that a should be high on every posedge clk
    sequence s_a;
        @(posedge clk) a;
    endsequence

    // When the above sequence is asserted, the assertion fails if 'a'
    // is found to be not high on any posedge clk
    assert property (s_a);

    always #10 clk = ~clk;

    initial begin
        for (int i = 0; i < 10; i++) begin
            a = $random;
            @(posedge clk);

            // Assertion is evaluated in the preponed reginon and
            // use $display to see the value of 'a' in that region
            $display("[%0t] a=%0d", $time, a);
        end

        #20 $finish;
    end
endmodule


// $rose
module tb;
  	bit a;
  	bit clk;

	// This sequence states that 'a' should rise on every posedge clk
  	sequence s_a;
        @(posedge clk) $rose(a);
    endsequence

  	// When the above sequence is asserted, the assertion fails if
  	// posedge 'a' is not found on every posedge clk
  	assert property(s_a);


	// Rest of the testbench stimulus
endmodule


// $fell
module tb;
  	bit a;
  	bit clk;

	// This sequence states that 'a' should fall on every posedge clk
  	sequence s_a;
        @(posedge clk) $fell(a);
    endsequence

  	// When the above sequence is asserted, the assertion fails if
  	// negedge 'a' is not found on every posedge clk
  	assert property(s_a);


	// Rest of the testbench stimulus
endmodule


// $stable
module tb;
  	bit a;
  	bit clk;

	// This sequence states that 'a' should be stable on every clock
	// and should not have posedge/negedge at any posedge clk
  	sequence s_a;
        @(posedge clk) $stable(a);
    endsequence

  	// When the above sequence is asserted, the assertion fails if
  	// 'a' toggles at any posedge clk
  	assert property(s_a);


	// Rest of the testbench stimulus
endmodule

/*
https://www.chipverify.com/systemverilog/systemverilog-sequence-rose-fell-stable 
*/
