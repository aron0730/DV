// Static Arrays
module tb;
    bit [7:0] m_data;       // A vector or 1D packed array

    initial begin
        // 1. Assign a value to the vector
        m_data = 8'A2;

        // 2. Iterate through each bit of the vector and print value
        for (int i = 0; i < $size(m_data); i++) begin
            $display("m_data[%0d] = %b", i, m_data[i]);
        end
    end
endmodule

bit [2:0][7:0]  m_data;         // Packed
bit [15:0]      m_mem[10:0]     // Unpacked

bit [3:0]       data;           // Packed array or vector
lobic           queue [9:0]     // Unpacked array

/********************Packed Arrays********************/
// Single Dimensional Packed Arrays
module tb;
    bit [7:0] m_data;       // A vector or 1D packed array

    initial begin
        // 1. Assign a value to the vector
        m_data = 8'hA2;

        // 2. Iterate through each bit of the vector and print value
        for (int i = 0; i < $size(m_data); i++) begin
            $display("m_data[%0d] = %b", i, m_data[i]);
        end
    end
endmodule
/*
sim log :
m_data[0] = 0
m_data[1] = 1
m_data[2] = 0
m_data[3] = 0
m_data[4] = 0
m_data[5] = 1
m_data[6] = 0
m_data[7] = 1
*/

// Multidimensional Packed Arrays
module tb;
    bit [3:0][7:0] m_data       // A MDA, 4 bytes

    initial begin
        // 1. Assign a value to the MDA
        m_data = 32'hface_cafe;
        $display("m_data = 0x%0h", m_data);

        // 2. Iterate through each segment of the MDA and print value
        for(int i = 0; i < $size(m_data); i++) begin
            $display("m_data[%0d] = %b (0x%0h)", i, m_data[i], m_data[i]);
        end
    end
endmodule
/*
sim log :
m_data = 0xfacecafe
m_data[0] = 11111110 (0xfe)
m_data[1] = 11001010 (0xca)
m_data[2] = 11001110 (0xce)
m_data[3] = 11111010 (0xfa)
*/

// 3D packed array
module tb;
    bit [2:0][3:0][7:0] m_data;     // An MDA, 12 Bytes

    initial begin
        // 1. Assign a value to the MDA
        m_data[0] = 32'hface_cafe;
        m_data[1] = 32'h1234_5678;
        m_data[2] = 32'hc0de_fade;

        // m_data gets a packed value
        $display("m_data = 0x%0h", m_data);

        // 2. Iterate through each segment of the MDA and print value
        foreach(m_data[i])begin
            $display("m_data[%0d] = 0x%0h", i, m_data[i]);
            foreach(m_data[i][j]) begin
                $display("m_data[%0d][%0d] = 0x%0h", i, j, m_data[i][j]);
            end
        end

    end
endmodule

/*
sim log :
m_data = 0xc0defade12345678facecafe
m_data[0] = 0xfacecafe
m_data[0][0] = 0xfe
m_data[0][1] = 0xca
m_data[0][2] = 0xce
m_data[0][3] = 0xfa
m_data[1] = 0x12345678
m_data[1][0] = 0x78
m_data[1][1] = 0x56
m_data[1][2] = 0x34
m_data[1][3] = 0x12
m_data[2] = 0xc0defade
m_data[2][0] = 0xde
m_data[2][1] = 0xfa
m_data[2][2] = 0xde
m_data[2][3] = 0xc0
*/

/********************Unpacked Arrays********************/
module tb;
    byte stack[8];      // depth = 8, 1 byte wide variable

    initial begin
        // Assign random values to each slot of the stack
        foreach (stack[i]) begin
            stack[i] = $random;
            $display("Assign 0x%0h to index %0d", stack[i], i);
        end

        // Print contents of the stack
        $display("stack = %p", stack);
    end
endmodule

/*sim log : 
Assign 0x24 to index 0
Assign 0x81 to index 1
Assign 0x9 to index 2
Assign 0x63 to index 3
Assign 0xd to index 4
Assign 0x8d to index 5
Assign 0x65 to index 6
Assign 0x12 to index 7
stack = '{'h24, 'h81, 'h9, 'h63, 'hd, 'h8d, 'h65, 'h12} */

// Multidimensional Unpacked Array
module tb;
    byte stack [2][4];      // 2 rows, 4 columns

    initial begin
        // Assign random values to each slot of the stack
        foreach(stack[i]) begin
            foreach(stack[i][j]) begin
                stack[i][j] = $random & 8'hFF;
                $display("stack[%0d][%0d] = 0x%0h", i, j, stack[i][j]);
            end

            // Print contents of the stack
            $display("stack = %p", stack);
        end
    end
endmodule

/*sim log : 
stack[0][0] = 0x24
stack[0][1] = 0x81
stack[0][2] = 0x9
stack[0][3] = 0x63
stack[1][0] = 0xd
stack[1][1] = 0x8d
stack[1][2] = 0x65
stack[1][3] = 0x12
stack = '{'{'h24, 'h81, 'h9, 'h63}, '{'hd, 'h8d, 'h65, 'h12}} */

// Packed + Unpacked Array
module tb;
    bit [3:0][7:0] stack[2][4];     // 2 rows, 4 columns;

    initial begin
        // Assign random values to each slot of the stack
        foreach (stack[i]) begin
            foreach (stack[i][j]) begin
                stack[i][j] = $random &32'hFFFF_FFFF;
                $display("stack[%0d][%0d] = 0x%0h", i, j, stack[i][j]);
            end
        end

        // Print contents of the stack
        $display("stack = %p", stack);

        // Print contents of a given index
        $display("stack[0][0][2] = 0x%0h", stack[0][0][2]);
    end
endmodule

/* sim log:
stack[0][0] = 0x12153524
stack[0][1] = 0xc0895e81
stack[0][2] = 0x8484d609
stack[0][3] = 0xb1f05663
stack[1][0] = 0x6b97b0d
stack[1][1] = 0x46df998d
stack[1][2] = 0xb2c28465
stack[1][3] = 0x89375212
stack = '{'{'h12153524, 'hc0895e81, 'h8484d609, 'hb1f05663}, '{'h6b97b0d, 'h46df998d, 'hb2c28465, 'h89375212}}
stack[0][0][2] = 0x15 */

/********************Dynamic Array********************/
bit [7:0] stack[];      // A dynamic array of 8-bit vector
string      names[];    // A dynamic array that can contain strings

module tb;
    // Create a dynamic array that can hold elements of type int
    int array[];

    initial begin
        // Create a size for the dynamic array -> size here is 5
        // So that it can hold 5 values
        array = new[5];

        // Initialize the array with five values
        array = '{31, 67, 10, 4, 99};

        // Loop through the array and print their values
        foreach(array[i])
            $display("array[%0d] = %0d", i, array[i]);
    end
endmodule

/* sim log :
array[0] = 31
array[1] = 67
array[2] = 10
array[3] = 4
array[4] = 99 */


module tb;
    // Create a dynamic array that can hold elements of type string
    string fruits[];

    initial begin
        // Create a size for the dynamic array -> size here is 3
        // so that it can hold 3 values
        fruits = newe[3]

        // Initialize the array with three values
        fruits = '{"apple", "orange", "mango"};

        // Print size of the dynamic array
        $display("fruits.size() = %0d", fruits.size());

        // Empty the dynamic array by deleting all items
        fruits.delete();
        $display("fruits.size() = %0d", fruits.size());
    end
endmodule

/* sim log :
fruits.size() = 3
fruits.size() = 0 */

// How to add new items to a dynamic array?
int array[];
array = new[10];

// This creates one more slot in the array, while keeping old contents
array = new[array.size() + 1] (array);

// Copying dynamic array example
module tb;
    // Create two dynamic arrays of type int
    int array[];
    int id[];

    initial begin
        // Allocate 5 memory locations to "array" and initialize with values
        array = new[5];
        array = '{1, 2, 3, 4, 5};

        // Point "id" to "array"
        id = array;

        // Display contents of "id"
        $display("id = %p", id);

        // Grow size by 1 and copy existing elements to the new dyn.Array "id"
        id = new[id.size() + 1] (id);

        // Assign value 6 to the newly added location [index 5]
        id [id.size() - 1] = 6;

        // Display contents of new "id"
        $display("New id = %p", id);

        // Display size of both arrays
        $display("array.size() = %0d, id.size() = %0d", array.size(), id.size());
    end
endmodule

/* sim log :
id = '{1, 2, 3, 4, 5}
New id = '{1, 2, 3, 4, 5, 6}
array.size() = 5, id.size() = 6 */


/********************Associative Array********************/

// Value    Array_Name  [ Key ];
data_type   array_identifier    [index_type];

module tb;
    int     array1[int];        // An integer array with integer index
    int     array2[string];     // An integer array with string index
    string  array3[string];     // A string array with string index

    initial begin
        // Initialize each dynamic array with some values
        array1 = '{1 : 22,
                   6 : 34};

        array2 = '{"Ross" : 100,
                   "Joey" : 60};

        array3 = '{"Apples" : "Oranges",
                    "Pears" : "44"};

        // Print each array
        $display("array1 = %p", array1);
        $display("array2 = %p", array2);
        $display("array3 = %p", array3);
    end
endmodule

/* sim log :
array1 = '{1:22, 6:34}
array2 = '{"Joey":60, "Ross":100}
array3 = '{"Apples":"Oranges", "Pears":"44"} */

/*
num()
    功能：返回關聯式陣列中的條目數量。
    說明：可以用來查看陣列中存儲了多少個元素，對於檢查是否有元素存入陣列很有用。

size()
    功能：返回陣列中條目的數量，若陣列為空則返回 0。
    說明：size() 與 num() 的效果相同，用來確認陣列中當前的元素數量。

delete([index])
    功能：當指定 index 時，刪除該索引位置的條目；如果不指定索引，則刪除整個陣列。
    說明：用來清除特定索引的值或清空整個關聯式陣列。

exists(input index)
    功能：檢查指定索引位置是否存在條目，若存在則返回 1，否則返回 0。
    說明：在訪問特定索引之前，可以用來確保該索引存在，防止意外訪問空位置。

first(ref index)
    功能：將陣列中的第一個索引值賦給 index 變數，若陣列為空則返回 0。
    說明：用於獲取陣列中最小的索引值，適合用來遍歷從最小到最大的索引。

last(ref index)
    功能：將陣列中的最後一個索引值賦給 index 變數，若陣列為空則返回 0。
    說明：用於獲取陣列中最大的索引值，可搭配 first() 和 next() 來遍歷陣列。

next(ref index)
    功能：從給定索引開始，查找陣列中比該索引大的最小索引值。
    說明：適合用來從小到大遍歷陣列的索引值，通常配合 first() 一起使用來逐個訪問陣列。

prev(ref index)
    功能：從給定索引開始，查找陣列中比該索引小的最大索引值。
    說明：可以用來從大到小反向遍歷陣列，適合需要逆序訪問陣列的場景。 */

// Associative Array Methods Example
module tb;
    int fruits_l0[string];

    initial begin
        fruits_l0 = '{"apple"  : 4,
                      "orange" : 10,
                      "plum"   : 9,
                      "guava"  : 1};

        // size() : Print the number of items in the given dynamic array
        $display("fruits_l0.size() = %0d", fruits_l0.size());

        // num() : Another function to print number of items in given array
        $display("fruits_l0.num() = %0d", fruits_l0.num());

        // exists() : Check if a particular key exists in this dynamic array
        if (fruits_l0.exists("orange"))
            $display("Found %0d orange !", fruits_l0["orange"]);

        if (!fruits.exists["apricots"])
            $display("Sorry, season for apricots is over ...");

        // Note: String indices are taken in alphabetical order
        // first() : Get the first element in the array
        begin
            string f;
            // This function returns true if it succeeded and first key is stored
            // in the provided string "f"
            if (fruits_l0.first(f))
                $display("fruits_l0.first [%s] = %0d", f, fruits_l0[f]);
        end

        // last() : Get the last element in the array
        begin
            string f;
            if (fruits_l0.last(f))
                $display("fruits_l0.last [%s] = %0d", f, fruits_l0[f]) ;
        end

        // prev() : Get the previous element in the array
        begin
            string f = "orange";
            if (fruits_l0.prev(f))
                $display("fruit_l0.prev [%s] = %0d", f, fruit_l0[f]);
        end

        // next() : Get the next item in the array
        begin
            string f = "orange";
            if (fruits_l0.next (f))
            $display ("fruits_l0.next [%s] = %0d", f, fruits_l0[f]);
        end
    end
endmodule

/* sim log :
fruits_l0.size() = 4
fruits_l0.num() = 4
Found 10 orange !
Sorry, season for apricots is over ...
fruits_l0.first [apple] = 4
fruits_l0.last [plum] = 9
fruits_l0.prev [guava] = 1
fruits_l0.next [plum] = 9 */

// Dynamic array of Associative arrays
module tb;
    // Create an associative array with key of type string and value of type int
    // for each index in a dynamic array
    int fruits [] [string];
    fruits = new [2];

    // Initialize the associative array inside each dynamic array index
    fruits[0] = '{ "apple" : 1, "grape" : 2 };
    fruits[1] = '{ "melon" : 3, "cherry" : 4 };

    // Iterate through each index of dynamic array
    foreach (fruits[i])
        // Iterate through each key of the current index in dynamic array
        foreach (fruits[i][fruit])
            $display("fruits[%0d][%s] = %0d", i, fruit, fruits[i][fruit]);
endmodule

/* sim log : 
fruits[0][apple] = 1
fruits[0][grape] = 2
fruits[1][cherry] = 4
fruits[1][melon] = 3 */

// Dynamic array within each index of an Associative array
// Create a new typedef that represents a dynamic array
typedef int int_da [];

module tb;
    // Create an associative array where key is a string
    // and value is a dynamic array
    int_da fruits [string];

    initial begin
        // For key "apple", create a dynamic array that can hold 2 items
        fruits ["apple"] = new[2];

        // Initialize the dynamic array with some values
        fruits["apple"] = '{4, 5};

        // Iterate through each key, where key represented by str1
        foreach (fruits[str1])
            foreach(fruit[str1][i])
                $display("fruit[%s][%0d] = %0d", str1, i, fruit[str1][i]);
    end
endmodule
/* sim log :
fruits[apple][0] = 4
fruits[apple][1] = 5 */