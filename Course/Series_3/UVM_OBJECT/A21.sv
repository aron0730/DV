`include "uvm_macros.svh"
import uvm_pkg::*;

class my_object extends uvm_object;
    // `uvm_object_utils(my_object)

    function new(string path = "my_object");
        super.new(path);
    endfunction

    rand bit [1:0] a;
    rand bit [3:0] b;
    rand bit [7:0] c;

    `uvm_object_utils_begin(my_object)
        `uvm_field_int(a, UVM_DEFAULT);
        `uvm_field_int(b, UVM_DEFAULT);
        `uvm_field_int(c, UVM_DEFAULT);
    `uvm_object_utils_end
endclass

module tb;
    my_object obj;

    initial begin
        obj = new("obj");
        obj.randomize();
        obj.print();
    end
endmodule