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

// Systemverilog Queue Methods
size()
    用途:返回隊列中元素的數量,若隊列為空則返回0。
    範例: int len = queue.size();

insert(index, item)
    用途:將item插入到隊列中的指定索引位置index,並將後面的元素往後移動。
    範例:queue.insert(2, value); // 插入到索引2的位置

delete(index)
    用途:刪除隊列中指定索引位置的元素。如果不提供index,則刪除所有元素,清空隊列。
    範例:queue.delete(1); // 刪除索引1的元素

pop_front()
    用途：移除並返回隊列中的第一個元素。
    範例:int first = queue.pop_front();

pop_back()
    用途：移除並返回隊列中的最後一個元素。
    範例:int last = queue.pop_back();

push_front(item)
    用途:將item插入到隊列的開頭,使其成為隊列中的第一個元素。
    範例:queue.push_front(value); // 插入到隊列開頭

push_back(item)
    用途:將item插入到隊列的末尾,使其成為隊列中的最後一個元素。
    範例:queue.push_back(value); // 插入到隊列末尾

module tb;
    string fruits[$] = {"apple", "pear", "mango", "banana"};

    initial begin
        // size() : Gets size of the given queue
        $display("Number of fruits=%0d fruits=%p", fruits.size(), fruits);

        // insert() : Insert an element to the given index
        fruits.insert(1, "peach");
        $display("Insert peach, size=%0d fruits=%p", fruits.size(), fruits);

        // delete() : Delete element at given index
        fruits.delete(3);
        $display("Delete mango, size=%0d fruits=%p", fruits.size(), fruits);

        // pop_front() : Pop out element at the front
        $display("Pop %s, size=%0d fruits=%p", fruits.pop_front(), fruits.size(), fruits);

        // push_front() : Push a new element to front of the queue
        fruits.push_front("apricot");
        $display("Push apricot, size=%0d fruit=%p", fruits.size(), fruits);

        // pop_back() : Pop out element from the back
        $display("Pop %s, size=%0d fruits=%p", fruits.pop_back(), fruits.size(), fruits);

        // push_back() : Push element to the back
        $display("Push plum, size=%0d fruits=%p", fruits.size(), fruits);
    end
endmodule

// How to create a queue of classes in SystemVerilog
// Define a class with a single string member called "name"
class Fruit;
    string name;

    function new (string name = "Unknown");
        this.name = name;
    endfunction
endclass


module tb;
    // Create a queue that can hold values of data type "Fruit"
    Fruit list [$];

    initial begin
        // Create a new class object and call it "Apple"
        // and push into the queue
        Fruit f = new("Apple");
        list.push_back(f);

        // Create another class object and call it "Banana" and
        // push into the queue
        f = new("Banana");
        list.push_back(f);

        // Iterate through queue and access each class object
        foreach(list[i])
            $display("list[%0d] = %s", i, list[i].name);
        
        // simply print the whole queue, note that class handles are printed
        // and not class object contents
        $display("list = %p", list);

    end
endmodule

// Declare a dynamic array to store strings as a datatype
typedef string str_da [];

module tb;
    // This is a queue of dynamic arrays
    str_da list [$];

    initial begin
        // Initialize separate dynamic arrays with some values
        str_da marvel = '{"Spiderman", "Hulk", "Captain America", "Iron Man"};
        str_da dcWorld = '{"Batman", "Superman"};

        // Push the previously created dynamic arrays to queue
        list.push_back (marvel);
        list.push_back (dcWorld);

        // Iterate through the queue and access dynamic array elements
        foreach (list[i])
            foreach (list[i][j]);
                $display("list[%0d][%0d] = %s", i, j, list[i][j]);

        // Simply print the queue
        $display("list = %p", list);
    end
endmodule

/* sim log :
list[0][0] = Spiderman
list[0][1] = Hulk
list[0][2] = Captain America
list[0][3] = Iron Man
list[1][0] = Batman
list[1][1] = Superman
list = '{'{"Spiderman", "Hulk", "Captain America", "Iron Man"}, '{"Batman", "Superman"}} */