[data_type] [name_of_queue] [$:N];

int bouded_queue [$:10];    // Depth 10  表示一個初始為空但最多可以擴展到 10 個元素的動態陣列。

int unbounded_queue [$];    // Unlimited entries



string name_list [$];   // A queue of string elements
bit [3:0] data[$];      // A queue of 4-bit elements

logic [7:0] elements [$:127];   // A bounded queue of 8-bits with maximum size of 128 slots

int q1 [$] = {1, 2, 3, 4, 5};     // Integer queue, initialize elements
int q2 [$];                       // Integer queue, empty
int tmp;                          // Temporary variable to store values

tmp = q1 [0];                     // Get first item of q1 (index 0) and store in tmp
tmp = q1 [$];                     // Get last item of q1 (index 4) and store in tmp
q2 = q1;                          // Copy all elements in q1 into q2
q1 = {};                          // Empty the queue (delete all items)

q2[2] = 15;                       // Replace element at index 2 with 15
q2.insert (2, 15);                // Inserts value 15 to index 2
q2 = {q2, 22};                    // Append 22 to q2
q2 = {99, q2};                    // Put 99 as the first element of q2
q2 = q2 [1:$];                    // Delete first item
q2 = q2 [0:$-1];                  // Delete last item
q2 = q2 [1:$-1];                  // Delete first and last item

module tb;
    // Create a queue that can store "string" values
    string fruits[$] = {"orange", "apple", "kiwi"};

    initial begin
        // Iterate and access each queue element
        foreach (fruits[i])
            $display("fruits[%0d] = %s", i, fruits[i]);

        // Display elements in a queue
        $display("fruits = %p", fruits);

        // Delete all elements in the queue
        fruits = {};
        $display("After deletion, fruits = %p", fruits);
    end
endmodule
/* sim log :
fruits[0] = orange
fruits[1] = apple
fruits[2] = kiwi
fruits = '{"orange", "apple", "kiwi"}
After deletion, fruits = '{}  */

module tb;
    // Create a queue that can store "string" values
    string fruits[$] = {"orange", "apple", "lemon", "kiwi"};

    initial begin
        // Select a subset of the queue
        $display("fruits = %p, fruits[1:2]");

        // Get elements from index 1 to end of queue
        $display("fruits = %p", fruits[1:$]);

        // Add element to the end of queue
        fruits[$+1] = "pineapple";
        $display("fruits = %p", fruits);

        // Delete first element
        fruits = fruits[1:$];
        $display("fruits = %p", fruits);
    end
endmodule
