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


// What are fixed size arrays?
module tb;
    // The following two representations of fixed arrays are the same
    // myFIFO and urFIFO have 8 locations where each location can hold an integer value
    // 0, 1 | 0, 2 | 0, 3 | ... | 0, 7
    int myFIFO [0:7];
    int urFIFO [8];

    // Multi-dimensional arrays
    // 0,0 | 0,1 | 0,2
    // 1,0 | 1,1 | 1,2
    int myArray [2][3];

    initial begin
        myFIFO[5] = 32'hface_cafe;  // Assign value to location 5 in 1D array
        myArray [1][1] = 7;         // Assign to location 1,1 in 2D array

        // Iterate through each element in the array
        foreach (myFIFO[i])
            $display ("myFIFO[%0d] = 0x%0h", i, myFIFO[i]);

        // Iterate through each element in the multidimensional array
        foreach (myArray[i])
            foreach (myArray[i][j])
                $display ("myArray[%0d][%0d] = %0d", i, j, myArray[i][j]);
    end 
endmodule

// void data-type
function void display();
    $display ("Am not going to return any value");
endfunction

task void display();
    #10 $display("Me neither");
endtask

// Conversion of real to int
// Casting will perform rounding(四捨五入)
int'(2.0 * 3.0)
shortint'({8'hab, 8'hef});

// Using system tasks will truncate
integer $rtoi(real_val);
real    $itor(int_val);


/*
類型轉換如 int'() 和 shortint'() 會進行四捨五入。
系統任務 $rtoi 用於截斷小數部分，而 $itor 用於將整數轉換為實數。 這種靈活性讓設計者可以根據需要選擇四捨五入或截斷來進行數據轉換。
*/