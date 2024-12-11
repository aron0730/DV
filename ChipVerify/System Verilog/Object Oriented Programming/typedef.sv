class ABC;
	DEF 	def; 	// Error: DEF has not been declared yet
endclass

class DEF;
	ABC 	abc;
endclass

/* Compilation Error */


typedef class DEF;  // Inform compiler that DEF might be
                    // used before actual class definition

typedef DEF;  // Also legel

class ABC;
	DEF 	def;      // Okay: Compiler knows that DEF
	                // declaration will come later
endclass

class DEF;
	ABC 	abc;
endclass


// Using typedef with parameterized classes
typedef XYZ;

module top;
    XYZ #(8'h3f, real)              xyz0;   // positional parameter override
    XYZ #(.ADDR(8'h60), .T(real))   xyz1;   // named parameter override   
endmodule

class XYZ #(parameter ADDR = 8'h00, type T = int);
endclass