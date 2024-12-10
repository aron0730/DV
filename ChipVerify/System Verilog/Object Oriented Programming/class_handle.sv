// Class Handle Example

// Create a new class with a single member called
// count that stores integer values
class Packet;
	int count;
endclass

module tb;
    // Create a "handle" for the class Packet that can point to an
    // object of the class type Packet
    // Note: This "handle" now points to NULL
    Packet pkt;

    initial begin
        if (pkt == null)
            $display("Packet handle 'pkt' is null");

        // Display the class member using the "handle"
        // Expect a run-time error because pkt is not an object
        // yet, and is still pointint to NULL. So pkt is not
        // aware that it should hold a member
        $display("count = %0d", pkt.count);
    end
endmodule
/* sim log :
Packet handle 'pkt' is null
count = ncsim: *E,TRNULLID: NULL pointer dereference. */

// What is a class object?

// Create a new class with a single member called
// count that stores integer values
class Packet;
	int count;
endclass

module tb;
    // Create a "handle" for the class Packet that can point to an
    // object of the class type Packet
    // Note: This "handle" now points to NULL
    Packet pkt;

    initial begin
        if (pkt == null)
            $display("Packet handle 'pkt' is null") ;

        // Call the new() function of this class
        pkt = new();

        if (pkt == null)
            $display("What's wrong, pkt is still null ?");
        else    
            $display("Packet handle 'pkt' is now pointing to an object, and not NULL");
        
        // Display the class member using the "handle"
        $display("count = %0d", pkt.count);
    end
endmodule

// What happens when both handles point to same object?

// Create a new class with a single member called
// count that stores integer values
class Packet;
	int count;
endclass

module tb;
    // Create two "handles" for the class Packet
    // Note: These "handles" now point to NULL
    Packet pkt, pkt2;

    initial begin
        
        // Call the new() function of this class and
        // assign the member some value
        pkt = new();
        pkt.count = 16'habcd;

        // Display the class member using the "pkt" handle
        $display("[pkt] count = 0x%0h", pkt.count);

        // Make pkt2 handle to point to pkt and print member variable
        $display("[pkt2] count = 0x%0h", pkt2.count);
    end
endmodule
/* sim log :
[pkt] count = 0xabcd
[pkt2] count = 0xabcd */
