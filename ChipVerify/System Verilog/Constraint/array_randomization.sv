class Packet;
    rand bit [3:0] s_array[7];      // Declare a static array with "rand"
endclass

module tb;
    Packet pkt;

    // Create a new packet, randomize it and display contents
    initial begin
        pkt = new();
        pkt.randomize();
        $display("queue = %p", pkt.s_array);
    end
endmodule
/* sim log :
queue = '{'hf, 'hf, 'h2, 'h9, 'he, 'h4, 'ha} */

// Dynamic Arrays
class Packet;
    rnad bit [3:0] d_array[];  // Declare a dynamic array with "rand"

    // Constrain size of dynamic array between 5 and 10
    constraint c_array { d_array.size() > 5; d_array.size() < 10; }

    // Constrain value at each index to be equal to the index itself
    constraint c_val { foreach(d_array[i]) d_array[i] == i; }

    // Utility function to display dynamic array contents
    function void display();
        foreach(d_array[i])
            $display("d_array[%0d] = 0x%0h", i, d_array[i]);
    endfunction
endclass

module tb;
    Packet pkt;

    // Create a new packet, randomize it and display contents
    initial begin
        pkt = new();
        pkt.randomize();
        pkt.display();
    end
endmodule
/* sim log :
d_array[0] = 0x0
d_array[1] = 0x1
d_array[2] = 0x2
d_array[3] = 0x3
d_array[4] = 0x4
d_array[5] = 0x5
d_array[6] = 0x6
d_array[7] = 0x7
d_array[8] = 0x8 */

// Queue randomization
class Packet;
    rand bit [3:0] queue[$];        // Declare a queue with "rand"

    // Constrain size of queue between 5 and 10
    constraint c_array { queue.size() == 4; }
endclass

module tb;
    Packet pkt;

    // Create a new packet, randomize it and display contents
    initial begin
        pkt = new();
        pkt.randomize();

        // Tip : Use %p to display arrays
        $display("queue = %p", pkt.queue);
    end
endmodule
/* sim log :
queue = '{'hf, 'hf, 'h2, 'h9}*/


