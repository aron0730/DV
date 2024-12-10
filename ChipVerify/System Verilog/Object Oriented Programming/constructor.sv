// When class constructor is explicity defined
// Define a class called "Packet" with a 32-bit variable to store address
// Initialize "addr" to 32'hfade_cafe in the new function, also called constructor
class Packet;
    bit [31:0] addr;

    function new();
        addr = 32'hfade_cafe;
    endfunction
endclass

module tb;

    // Create a class handle called "pkt" and instantiate the class object
    initial begin
        // The class's constructor new() fn is called when the object is instantiated
        Packet pkt = new();

        // Display the class variable - Because constructor was called during
        // instantiation, this variable is expected to have 32'hfade_cafe;
        $display("addr=0x%0h", pkt.addr);
    end
endmodule
/* sim log :
addr=0xfadecafe */

// When class constructor is implicitly called
// Define a simple class with a variable called "addr"
// Note that the new() function is not defined here
class Packet;
    bit [31:0] addr;
endclass

module tb;

  	// When the class object is instantiated, then the constructor is
  	// implicitly defined by the tool and called
	initial begin
		Packet pkt = new;
		$display ("addr=0x%0h", pkt.addr);
	end
endmodule
/* sim log :
addr=0x0 */

// Behavior of inherited classes
// Define a simple class and initialize the class member "data" in new() function
class baseClass;
    bit [15:0] data;

    function new ();
        data = 16'hface;
    endfunction
endclass

// Define a child class extended from the above class with more members
// The constructor new() function accepts a value as argument, and by default is 2
class subClass extends baseClass;
    bit [3:0] id;
    bit [2:0] mode = 3;

    function new (int val = 2);
        // The new() function in child class calls the new function in
        // the base class using the "super" keyword
        super.new();

        // Assign the value obtained through the argument to the class member
        id = val;
    endfunction
endclass

module tb;
    initial begin
        // Create two handles for the child class
        subClass sc1, sc2;

        // Instantiate the child class and display member variable values
        sc1 = new();
        $display("data=0x%0h id=%0d mode=%0d", sc1.data, sc1.id, sc1.mode);

        // Pass a value as argument to the new function in this case and print
        sc2 = new(4);
        $display("data=0x%0h id=%0d mode=%0d", sc2.data, sc2.id, sc2.mode);
    end
endmodule
/* sim log :
data=0xface id=2 mode=3
data=0xface id=4 mode=3 */

// When the new function is declared as static or virtual
class ABC;
    string fruit;

    // Note that the constructor is defined as "virtual" which is not allowed
    // in SystemVerilog. Class constructor cannot be "static" either
    virtual function new();  // ERROR!
        fruit = "Apple";
    endfunction
endclass

// Instantiate the class object and print its contents
module tb;
    initial begin
        ABC abc = new();
        $display("fruit = %s", abc.fruit);
    end
endmodule

// Typed constructors
class C;
    // ...
endclass

class D extends C;
    // ...
endclass

module tb;
    initial begin
        C c = D::new;  // Same as below
    end
endmodule

module tb;
	initial begin
		D d = new;
		C c = d;
	end
endmodule