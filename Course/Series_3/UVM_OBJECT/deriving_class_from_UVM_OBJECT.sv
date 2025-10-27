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

endclass

module tb;
    obj o;
    initial begin
        o = new("obj");
        o.randomize();
        `uvm_info("TB_TOP", $sformatf("Value of a : %0d", o.a), UVM_NONE);
    end
endmodule
