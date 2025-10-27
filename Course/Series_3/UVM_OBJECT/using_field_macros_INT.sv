`include "uvm_macros.svh"
import uvm_pkg::*;

// Object class is use to implement all the Dynamic Components of Testbench 
// e.g. Transaction Class
class obj extends uvm_object;
    // `uvm_object_utils(obj)

    function new(string path = "OBJ");
        super.new(path);
    endfunction

    rand bit [3:0] a;

    `uvm_object_utils_begin(obj)
        `uvm_field_int(a, UVM_DEFAULT)
    `uvm_object_utils_end

endclass

module tb;
    obj o;
    initial begin
        o = new("obj");
        o.randomize();
        // `uvm_info("TB_TOP", $sformatf("Value of a : %0d", o.a), UVM_NONE);
        o.print();
    end
endmodule

//***************************

`include "uvm_macros.svh"
import uvm_pkg::*;

// Object class is use to implement all the Dynamic Components of Testbench 
// e.g. Transaction Class
class obj extends uvm_object;
    `uvm_object_utils(obj)

    function new(string path = "OBJ");
        super.new(path);
    endfunction

    rand bit [3:0] a;

    virtual function void do_print(uvm_printer printer);
        printer.print_string("==== Custom Print ====", "");
        printer.print_field_int("a", a, 4, UVM_HEX);
    endfunction

    // `uvm_object_utils_begin(obj)
        // `uvm_field_int(a, UVM_DEFAULT)
    // `uvm_object_utils_end

endclass

module tb;
    obj o;
    initial begin
        o = new("obj");
        o.randomize();
        // `uvm_info("TB_TOP", $sformatf("Value of a : %0d", o.a), UVM_NONE);
        o.print();
    end
endmodule
