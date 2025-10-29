`include "uvm_macros.svh"
import uvm_pkg::*;

class obj extends uvm_object;
    `uvm_object_utils(obj)

    function new(string path = "OBJ");
        super.new(path);
    endfunction

    bit [3:0] a = 4;
    string b = "UVM";
    real c = 12.34;

    // virtual function void do_print(uvm_printer printer);
    //     super.do_print(printer);
    //     printer.print_field_int("a", a, $bits(a), UVM_HEX);
    //     printer.print_string("b", b);
    //     printer.print_real("c", c);
    // endfunction

    virtual function string convert2string();
        string s = super.convert2string();
        s = {s, $sformatf("a : %0d  ", a)};
        s = {s, $sformatf("b : %0s  ", b)};
        s = {s, $sformatf("c : %0f  ", c)};
        //* a : 4  b : UVM  c : 12.3400
        return s;
    endfunction
endclass

module tb;
    obj o;

    initial begin
        o = obj::type_id::create("o");
        // o.print();
        $display("%0s", o.convert2string());
        `uvm_info("TB_TOP", $sformatf("%0s", o.convert2string()), UVM_NONE);
    end
endmodule
