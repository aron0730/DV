virtual class uvm_void;
endclass


virtual class uvm_object extends uvm_void;
    extern function void print (uvm_printer printer=null);
    extern function void copy (uvm_object rhs, uvm_copier copier=null);
    extern function bit compare (uvm_object rhs, uvm_comparer comparer=null);
    extern function void record (uvm_recorder recorder=null);
    ...

endclass

// Example
class my_transaction extends uvm_object;
    bit [7:0] addr;
    bit [7:0] data;

    // overwrite print
    function void print (uvm_printer printer = null);
        $display("Address: %0h, Data: %0h", addr, data);
    endfunction

    // overwrite copy
    function void copy (uvm_object rhs);
        my_transaction tx = my_transaction::type_id::cast(rhs);
        if (tx != null) begin
            this.addr = tx.addr;
            this.data = tx.data;
        end
    endfunction
endclass
/*
my_transaction::type_id
這是 UVM 框架提供的類型識別符 (Type Identifier)。
每個繼承自 uvm_object 的類都會自動生成一個 type_id 成員，用於識別類型並執行與類型相關的操作。

type_id::cast(rhs);
功能：將 rhs 嘗試轉型為指定的類型(這裡是 my_transaction)。
返回值：
    如果 rhs 實際上是 my_transaction 類型，則返回一個有效的指向該物件的指標。
    如果 rhs 不是 my_transaction 類型，則返回 null。

my_transaction tx
宣告 tx 為 my_transaction 類型，用於接收轉型結果。 */

initial begin
    my_transaction tx1 = new();
    my_transaction tx2 = new();

    tx1.addr = 8'hA5;
    tx1.data = 8'h5A;

    // Use copy , copy tx1 to tx2
    tx2.copy(tx1);

    // print result
    $display("tx2 addr=%0h, data=%h", tx2.addr, tx2.data);
end


// uvm_report_object
// A report has 'severity', 'id_string', 'text_message', and 'verbosity_level'

`uvm_info ("STAT", "Status register updated", UVM_HIGH)

// severity  		: uvm_info
// id_string 		: "STAT"
// text_message 	: "Status register updated"
// verbosity_level 	: UVM_HIGH



// uvm_component
// custom driver
class my_driver extends uvm_component;
    
    // Driver initialization
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    // Driver main behavior
    task run_phase (uvm_phase phase);
        $display("Driver is running...");
    endtask
endclass

module tb;

    initial begin
        uvm_component env = new("env", null);
        my_driver driver = new("driver", env);

        // Execute the build and run phases
        env.build_phase(null);
        env.run_phase(null);
    end
endmodule

// Practice
class my_driver extends uvm_component;

    // Driver's build function
    function new (string name, uvm_component parent);
        super.new(name, parent);  // initialize parent class uvm_component;
    endfunction

    // Run phase: Stages of executing component behavior
    task run_phase (uvm_phase phase);
        $display("[%0t] Driver is running...", $time);
    endtask
endclass

module tb;
    initial begin
        // build a environment component as parent component
        uvm_component env = new("env", null);

        // Instantiate the driver in the environment
        my_driver driver = new("driver1", env);

        // Execute driver behavior
        env.build_phase(null);  // Initialize component
        env.run_phase(null);  // Execute simulation
    end
endmodule

/*
在 UVM 測試平台中，每個元件都有父子關係。
new 方法將元件連接到其父元件，形成層次結構 
env
├── agent1
│   ├── driver1
│   └── monitor1
└── scoreboard
*/


// More complex
// Define a environment include driver
class my_env extends uvm_compoenet;
    my_driver driver;

    function new (string name, uvm_component parent);
        super.new(name, parent);  // Initialize parent class
    endfunction

    // build environment
    function void build_phase (uvm_phase phase);
        driver = my_driver::type_id::create("driver1", this);  // Use factory mode
    endfunction
endclass

module tb;
    initial begin
        // build environment
        my_env env = new("env", null);

        // Execute environment build and execute
        env.build_phase(null);  // initialize all components in environment
        env.run_phase(null);    // Execute all component's behaviors
    end
endmodule