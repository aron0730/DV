// Syntax
constraint [name_of_constraint] { [expression 1]; 
                                  [expression N]; }

constraint valid_addr { addr [1:0] == 2'b0; 
                        addr <= 32'hfaceface;
                        addr >= 32'hf0000000; }

constraint fast_burst { vurst >= 3;
                        len >= 64;
                        size >= 128; }

// Error - valid_addr already declared
constraint valid_addr { ... }

// Runtime error - solver fails due to conflict on addr
constraint valid { addr >= 32'hfaceffff; }

// Valid because solver can find an address that satisfies all conditions
// eg :- f200_0000 is below f400_0000 and face_face; and above f000_0000
constraint valid2 { addr <= 32'hf4000000; }

// An empty constraint - does not affect randomization
constraint c_empty;



// In-class Constraint Example
// Let's declare a new class called "ABC" with a single variable
class ABC;
    rand bit [3:0] mode;

    // This constraint block ensures that the randomized
    // value of "mode" meets the condition 2 < mode <= 6;
    constraint c_mode { mode > 2;
                        mode <= 6;
                        };

endclass

module tb;
    ABC abc;

    initial begin
        // Create a new object with this handle
        abc = new();

        // In a for loop, lets randomize this class handle
        // 5 times and see how the value of mode changes
        // A class can be randomized by calling its "randomize()"
        for (int i = 0; i < 5; i++) begin
            abc.randomize();
            $display("mode = 0x%0h", abc.mode);
        end
    end
endmodule
/* sim log :
mode = 0x6
mode = 0x6
mode = 0x5
mode = 0x4
mode = 0x5 */


// External Constraint Example
