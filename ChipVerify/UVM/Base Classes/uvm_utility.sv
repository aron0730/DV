// Utility Macros

// Object Utility
class ABC extends uvm_object;

    // Register this user defined class with the factory
    `uvm_object_utils(ABC)

    function new (strint name = "ABC")
        super.new(name);  // 表示數據類型或非層次結構的物件, 因為非層次, 所以不需要parent
    endfunction
endclass

// Component Utility
class DEF extends uvm_component;

    // Class derived from uvm_component, register with factory
    `uvm_component_utils(DEF)

    function new (string name = "DEF", uvm_component parent=null);
        super.new(name, parent);  // 構建測試平台的層次結構。需要parent
    endfunction
endclass


// Macro Expansion: Behind the Scenes
// Empty uvm_object_utils macro
`define uvm_object_utils(T)
    `uvm_object_utils_begin(T)
    `uvm_object_utils_end

`define uvm_object_utils_begin(T)
    `m_uvm_object_registry_internal(T,T)    // Sub-macro #1
    `m_uvm_object_create_func(T)            // Sub-macro #2
    `m_uvm_get_type_name_func(T)            // Sub-macro #3
    `uvm_field_utils_begin(T)               // Sub-macro #4

// uvm_object_utils_end simply terminates a function started
// somewhere in the middle
`define uvm_object_utils_end
    end
endfunction

// Sub-macro #1. Implement the functions "get_type()" and "get_object_type()"
`define m_uvm_object_registry_internal(T,S)
    typedef uvm_object_registry # (T, `"S`") type_id;
    static function type_id get_type();
        return type_id::get();
    endfunction

    virtual function uvm_object_wrapper get_object_type();
        return type_id::get();
    endfunction

// Sub-macro #2. Implement the function "create()"
`define m_uvm_object_create_func(T)
    function uvm_object create (string name="");
        T tmp;

`ifdef UVM_OBJECT_DO_NOT_NEED_CONSTRUCTOR
        tmp = new();
        if (name!="")
            tmp.set_name(name);
`else
        if (name=="")
            tmp = new();
        else
            tmp = new(name);
`endif

        return tmp
    endfunction
    
// Sub-macro #3. Implement the function "get_type_name()"
`define m_uvm_get_type_name_func(T)
    const static string type_name = `"T`";
    virtual function string get_type_name();
        return type_name;
    endfunction

// Sub-marco $4. Implement field automation macros
`define uvm_field_utils_begin(T)
    function void __m_uvm_field_automation (uvm_object tmp_data__, int what__, string str__);


// How to use uvm_component_utils_*
class my_drive extends uvm_driver;
    `uvm_component_utils(my_driver)
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

// How to use uvm_object_param_utils_*
class my_packet #(type T = int) extends uvm_object;
    `uvm_object_param_utils(my_packet#(T))
    function new();
        super.new();
    endfunction
endclass


// Creation of class object
class ABC extends uvm_object;
    `uvm_object_utils(ABC)

    function new (string name = "ABC")
        super.new(name);
    endfunction
endclass

class base_test extends uvm_test;
    `uvm_component_utils(base_test);

    function new (strint name = "base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase (uvm_phase phase);
        
        // An object of class "ABC" is instantiated in UVM by calling
        // its "create()" function which has been defined using a macro
        // as shown above
        ABC abc = ABC::type_id::create("abc_inst");
    endfunction
endclass
/*
在 UVM 的模擬過程中，所有 uvm_component 都會自動進入它們的 build_phase，這是由 UVM 執行環境控制的。

在 UVM 測試執行流程中，build_phase 是一個很早期執行的階段，通常由測試類中的以下結構啟動：
run_test("base_test");
當執行 run_test 時，UVM 自動創建 base_test 的實例，並按以下順序執行：

調用 base_test 的構造函數 new。
執行 build_phase。
依次進入其他 UVM 階段。
因此，ABC 的實例化實際上是在 run_test 開始後，由 base_test 的 build_phase 階段中執行的。*/


// Field Macros
class ABC extends uvm_object;
    rand bit [15:0] m_addr;
    rand bit [15:0] m_data;

    `uvm_object_utils_begin(ABC)
        `uvm_field_int(m_addr, UVM_DEFAULT)
        `uvm_field_int(m_data, UVM_DEFAULT)
    `uvm_object_utils_end

    function new (string name = "ABC");
        super.new(name);
    endfunction
endclass

/* uvm_field_* flag:
UVM_DEFAULT: open all function (ex: copy, compare, print)
UVM_NOCOMPARE
UVM_NOPRINT
UVM_NOCOPY
ex:
`uvm_field_int (m_addr, UVM_NOCOMPARE | UVM_NOPRINT)


uvm_field_int
uvm_field_string
uvm_field_object
uvm_field_array_int
uvm_field_array_object

Flag	Description
UVM_ALL_ON	All operations are turned on
UVM_DEFAULT	Enables all operations and equivalent to UVM_ALL_ON
UVM_NOCOPY	Do not copy the given variable
UVM_NOCOMPARE	Do not compare the given variable
UVM_NOPRINT	Do not print the given variable
UVM_NOPACK	Do not pack or unpack the given variable
UVM_REFERENCE	Operate only on handles, i.e. for object types, do not do deep copy, etc
*/

// What happen after using field macro
`umv_field_int (m_addr, UVM_DEFAULT)

    function void do_copy(uvm_object rhs);
        ABC rhs_ = ABC::type_id::get(rhs);  // 這是一個靜態函數，用於將一個通用的 uvm_object 指標（例如 rhs）轉換為指定類型（例如 ABC）的句柄。
        return this.m_addr == rhs_.m_addr;
    endfunction

    function bit do_compare(uvm_object rhs);
        ABC rhs_ = ABC::type_id::get(rhs);
        return this.m_addr == rhs_.m_addr;
    endfunction

    function void do_print(uvm_printer printer);
        printer.print_field("m_addr", this.m_addr, $bits(this.m_addr));
    endfunction

// type_id::get(rhs) 的具體實現大致如下：
static function ABC get(uvm_object obj);
    if (obj == null)
        return null; // 如果 obj 是 null，直接返回 null
    if (obj.get_type_name() == this.type_name)
        return ABC'(obj); // 類型匹配，進行類型轉換
    return null; // 類型不匹配，返回 null
endfunction


