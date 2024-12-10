bc = sc;            // Base class handle is pointed to a sub class

bc.display ();      // This calls the display() in base class and
                    // not the sub class as we might think

// Without virtual keyword
// Without declaring display() as virtual
class Packet;
    int addr;

    function new (int addr);
        this.addr = addr;
    endfunction

    // This is a normal function definition which
    // starts with the keyword "function"
    function void display();
        $display("[Base] addr=0x%0h", addr);
    endfunction
endclass

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

module tb;
    Packet      bc;
    ExtPacket   sc;

    initial begin
        sc = new(32'hfeed_feed, 32'h1234_5678);

        bc = sc;
        bc.display();
    end
endmodule
/* sim log :
[Base] addr=0xfeedfeed */

// With virtual keyword
class Packet;
    int addr;

    function new (int addr);
        this.addr = addr;
    endfunction

    // This is a normal function definition which
    // starts with the keyword "function"
    virtual function void display();
        $display("[Base] addr=0x%0h", addr);
    endfunction
endclass

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

module tb;
    Packet      bc;
    ExtPacket   sc;

    initial begin
        sc = new(32'hfeed_feed, 32'h1234_5678);

        bc = sc;
        bc.display();
    end
endmodule
/* sim log : 
[Child] addr=0xfeedfeed data=0x12345678 */