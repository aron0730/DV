class Packet;
    int addr;

    function new(int addr);
        this.addr = addr;
    endfunction

    function display();
        $display("[Base] addr=0x%0h", addr);
    endfunction
endclass

// A subclass called 'ExtPacket' is derived from the base class 'Packet' using
// 'extends' keyword which makes 'EthPacket' a child of the parent class 'Packet'
// The child class inherits all variables and methods from the parent class
class ExtPacket extends Packet;
    
    // This is a new variable only available in child class
    int data;

    function new(int addr, data);
        super.new(addr);        // Calls 'new' method of parent class
        this.data = data;
    endfunction

    function display();
        $display("[Child] addr=0x%0h , data=0x%0h", addr, data);
    endfunction
endclass

// Parent and Child Assignment
// Assign Child Class to Base Class
module tb;
    Packet      bc;     // bc stands for BaseClass
    ExtPacket   sc;     // sc stands for SubClass

    initial begin
        sc = new(32'hfeed_feed, 32'h1234_5678);

        // Assign sub-class to base-class handle
        bc = sc;

        bc.display();
        sc.display();
    end
endmodule
/* sim log :
[Base] addr=0xfeedfeed
[Child] addr=0xfeedfeed data=0x12345678 */

module tb;
    Packet      bc;     // bc stands for BaseClass
    ExtPacket   sc;     // sc stands for SubClass

    initial begin
        sc = new(32'hfeed_feed, 32'h1234_5678);
        bc = sc;

        // Print variable in sub-class that is pointed to by
        // base class handle
        $display("data=0x%0h", bc.data);    // Error; Base handle can't access Child handle arrtibutes
    end
endmodule



// Assign Base Class to Child Class
module
    Packet      bc;     // bc stands for BaseClass
    ExtPacket   sc;     // sc stands for SubClass

    initial begin
        bc = new(32'hface_cafe);

        // Assign base class object to sub-class handle
        sc = bc;  // ERROR

        bc.display();
    end
    
endmodule

module
    Packet      bc;     // bc stands for BaseClass
    ExtPacket   sc;     // sc stands for SubClass

    initial begin
        bc = new(32'hface_cafe);

        // Dynamic cast base class object to sub-class type
        $case(sc, bc);  // ERROR

        bc.display();
    end
endmodule

initial begin
    ExtPacket sc2;
    bc = new (32'hface_cafe);
    sc = new (32'hfeed_feed, 32'h1234_5678);
    bc = sc;

    // Dynamic cast sub class object in base class handle to sub-class type
    $cast (sc2, bc);

    sc2.display ();
    $display ("data=0x%0h", sc2.data);
end


// Virtual Methods
class Base;
    rand bit [7:0] addr;
    rand bit [7:0] data;

    // Parent class has a method called 'display' declared as virtual
    virtual function void display(string tag="Thread1");
        $display("[Base] %s: addr=0x%0h data=0x%0h", tag, addr, data);
    endfunction
endclass

class Child extends Base;
    rand bit en;

    // Child class redefines the method to also print 'en' variable
    function void display(string tag = "Thread1");
        $display("[Child] %s: addr=0x%0h data=0x%0h en=%0d", tag, addr, data, en);
    endfunction
endclass


// Rules to follow
// Assignment of derived class handle to base class handle is allowed.
// Assignment of base class handle to derived class handle is NOT allowed and results in compilation error.

base b = new;
child c = new;

b = c; // Allowed
c = b; // Compilation Error

// $cast returns 0 if the cast failed, so use the return type to throw an error. Use if or assert to ensure that the cast is successful.
base b = new;
child c = new;
if (!cast(c, b))
    $error("Cast failed!");

assert($cast(c, b)) else
    $error("Cast failed!");