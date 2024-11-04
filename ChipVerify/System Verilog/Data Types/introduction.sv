// How to write floating point

module tb;
    real pi;    // Declared to be of type real
    real freq;

    initial begin
        pi = 3.14;      // Store floating point number
        freq = 1e6;     // Store exponential number

        $display ("Value of pi = %f", pi);
        $display ("Value of pi = %0.3f", pi);
        $display ("Value of freq = %0d", freq);
    end
endmodule

/* Sim log */
/*
Value of pi = 3.140000
Value of pi = 3.140
Value of freq = 1000000.000000
*/

// Strings can be split into multiple lines [for visual appeal] by the using "" character
// This does not split the string into multiple lines in the output
// Result: New York is an awesome place. So energetic and vibrant.
$display("New York is an awesome place.
So energetic and vibrant.");

// Strings can be split to be displayed in multiple lines using ""
$display("New York is an awesome place.\nSo energetic and vibrant.");

// To store a string literal in an integral type, each character will require 8 bits
byte myLetter = "D";
bit [7:0] myNewLine = "";

// "Hello World" has 11 characters and each character requires 8-bits
bit [8*17:1] myMessage = "Hello World";
string       myMessage2 = "Hello World";  // Uses "string" data type


// What are structures?
// Create a structure to store "int" and "real" variables
// A name is given to the structure and declared to be a data type so
// that this name "s_money" can be used to create structure variables
typedef struct {
    int coins;
    real dollars;
} s_money;

// Create a structure variable of type s_money
s_money wallet;

wallet = '{5, 19.75}                    // Assign direct values to a structure variable
wallet = '{coins:5, dollars:19.75}      // Assign values using member names
wallet = '{default:0}                   // Assign all elements of structure to 0
wallet = s_money'{int:1, dollars:2};    // Assign default values to all members of that type

// Create a structure that can hold 3 varialbes and initialize them with 1
struct {
    int A, B, C;
} ABC = '{3{1}};        // A = B = C = 1

// Assigning an array of structures
s_money purse [1:0] = '{'{2, 4.25}, '{7, 1.5}};