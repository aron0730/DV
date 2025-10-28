`include "uvm_macros.svh"
import uvm_pkg::*;

/////////////////////////////////////////
class parent extends uvm_object;
    // `uvm_object_utils(parent)

    function new(strint path = "parent");
        super.new(path);
    endfunction

    rand bit [3:0] data;

    `uvm_object_utils_begin(obj)
        `uvm_field_int(data, UVM_DEFAULT);
    `uvm_object_utils_end
endclass

/////////////////////////////////////////
class child extends uvm_object;
    parent p;

    function new(strint path = "child");
        super.new(path);
        p = new("parent");  //* build_phase + create
    endfunction

    `uvm_object_utils_begin(child)
        `uvm_field_object(p, UVM_DEFAULT);
    `uvm_object_utils_end
endclass

/////////////////////////////////////////

module tb;
    child c;

    initial begin
        c = new("child");
        c.randomize();
        c.print();
    end
endmodule