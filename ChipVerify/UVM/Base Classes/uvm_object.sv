// Class Definition
virtual class uvm_object extends uvm_void;

    // Create a new uvm_object with the given name, empty by default
    function new(string name="");

    // Utility functions
    function void print (uvm_printer printer=null);
    function void copy (uvm_object rhs, uvm_copier copier=null);
    function bit compare (uvm_object rhs, uvm_comparer comparer=null);
    function void record (uvm_recorder recorder=null);
    ....

    // These two functions have to be redefined by child classes
    virtual function uvm_object create (string name""); 
        return null;
    endfunction

    virtual function string get_type_name();
        return "";
    endfunction

endclass

// Classes that derive from uvm_object must implement the pure virtual methods such as create and get_type_name
class my_object extends uvm_object;
    ...
    // Implementation : Create an object of the new class type and return it
    virtual function uvm_object create (string name = "my_object");
        my_object obj = new(name);
        return obj;
    endfunction
endclass

class my_object extends uvm_object;

    // This static method is used to access via scope operator ::
    // without having to create an object of the class
    static function string type_name();  // 類級別的方法，與物件實例無關。 用於工廠註冊
        return "my_object";
    endfunction

            /*靜態方法：不需要創建物件即可使用，可以直接通過類名調用，例如：
            string type = my_object::type_name(); */

    virtual function string get_type_name();  // 物件級別的方法，需要創建物件實例後才能調用。支援子類覆蓋，允許多態行為。
        return type_name;
    endfunction

            /*虛擬方法：需要創建物件，並且可以在子類中覆蓋。支援多態性，允許子類覆蓋以返回不同的類型名稱。
            my_object obj = new();
            string type = obj.get_type_name(); */

endclass


// Override example
class my_object extends uvm_object;
    `uvm_object_utils(my_object)

    virtual function string get_type_name();
        return "my_object";
    endfunction
endclass

class child_object extends my_object;
    `uvm_object_utils(child_object)

    virtual function string get_type_name();
        return "child_object";
    endfunction
endclass

module testbench;
    initial begin
        my_object obj1 = new();
        my_object obj2 = new child_object();
        /* my_object obj2是宣告靜態類型, 靜態類型決定了可以通過這個變數調用哪些方法或屬性。
        new child_object()是動態類型, 物件在運行時的實際類型，是通過 new 分配的類型, 
        在這裡，new child_object() 表示物件的動態類型是 child_object，因為實例化的是 child_object。
        如果某方法是虛擬方法 (virtual)，那麼運行時會執行動態類型的方法，而不是靜態類型的方法。
        */

        $display("obj1 type: %s", obj1.get_type_name()); // 輸出: "my_object"
        $display("obj2 type: %s", obj2.get_type_name()); // 輸出: "child_object"
    end
endmodule


// Factory Interface
// An object derived from uvm_object by itself does not get
// registered with the UVM factory unless the macro is called
// within the class definition
class my_object extends uvm_object;
    
    // Register current object type with the factory
    `uvm_object_utils(my_object)

    ...
endclass


// Utility Functions
// Print
function void print (uvm_printer printer = null);

// Copy
function void uvm_object::copy (uvm_object rhs, uvm_copier copier=null);

// Compare
function bit compare (uvm_object rhs, uvm_comparer comparer=null);