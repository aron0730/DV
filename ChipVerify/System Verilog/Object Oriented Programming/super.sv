// The super keyword is used from within a sub-class to refer to properties and methods of the base class

// Example
class Packet;
    int addr;

    function display();
        $display("[Base] addr=0x%0h", addr);
    endfunction
endclass

class extPacket;        // "extends" keyword missing -> not ad child class
    function new();
        super.new();  // ERROR! 
    endfunction
endclass

module tb;
    Packet p;
    extPacket ep;

    initial begin
        ep = new();
        p = new();
        p.display();
    end
endmodule
/* sim log : 
super.new ();
        |
ncvlog: *E,CLSSPX (testbench.sv,12|8): 'super' can only be used within a class scope that derives from a base class. */


// Example
class Packet;
    int addr;

    function display();
        $display("[Base] addr=0x%0h", addr);
    endfunction
endclass

class extPacket extends Packet;        // extPacket is a child class of Packet
    function new();
        super.new();
    endfunction
endclass

module tb;
    Packet p;
    extPacket ep;

    initial begin
        ep = new();
        p = new();
        p.display();
    end
endmodule
/* sim log :
[Base] addr=0x0 */


// Accessing base class methods
class Packet;
    int addr;

    function display();
        $display("[Base] addr = 0x%0h", addr);
    endfunction
endclass

class extPacket extends Packet;
    function display();
        super.display();        // Call base class display method
        $display("[Child addr=0x%0h]", addr);
    endfunction

    function new();
        super.new();
    endfunction
endclass

module tb;
    Packet p;
    extPacket ep;

    initial begin
        ep = new();
        p = new();
        ep.display();
    end
endmodule
/* sim log :
[Base] addr=0x0
[Child] addr=0x0 */
