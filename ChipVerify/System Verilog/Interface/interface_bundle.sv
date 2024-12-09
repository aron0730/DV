// Example using a named bundle
module myDesign (myInterface if0, input logic clk);
    always @ (posedge clk)
        if (if0.ack)
            if0.gnt <= 1;
    // ...
endmodule

module yourDesign (myInterface if0, input logic clk);
    // ...
endmodule

module tb;
    logic clk = 0;
    myInterface _if;

    myDesign    md0 (_if, clk);
    yourDesign  yd0 (_if, clk);
endmodule

// Example using a generic bundle
module myDesign  ( interface  a,
                   input logic  clk);

	always @ (posedge clk)
		if (if0.ack)
			if0.gnt <= 1;

	...
endmodule

module yourDesign (  interface 		b,
					 input logic 	clk);
	...

endmodule

module tb;
    logic clk = 0;

    myInterface  _if;

    myDesign 	md0 ( .*, .a(_if));   // use partial implicit port connections
    yourDesign	yd0 ( .*, .b(_if));

endmodule