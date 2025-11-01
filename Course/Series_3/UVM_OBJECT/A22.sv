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
    my_object obj1;
    my_object obj2;

    initial begin
        obj1 = new("obj");
        if(!$cast(obj2, obj1.clone())) `uvm_info("TB_TOP","clone failed", UVM_NONE);
        obj1.print();
        obj2.print();
        obj1.compare(obj2);
    end
endmodule