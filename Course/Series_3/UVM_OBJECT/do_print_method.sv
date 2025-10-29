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

    virtual function void do_print(uvm_printer printer);
        super.do_print(printer);
        printer.print_field_int("a", a, $bits(a), UVM_HEX);
        printer.print_string("b", b);
        printer.print_real("c", c);
    endfunction
endclass

module tb;
    obj o;

    initial begin
        o = obj::type_id::create("o");
        o.print();
    end
endmodule


// virtual function void print_field (
//     string name,
//     uvm_bitstream_t value,
//     int size,
//     uvm_radix_enum radix = UVM_NORADIX,
//     byte scope_separator = ".",
//     string type_name = ""
// )
// Prints an integral field (up to 4096 bits).
//  name                The name of the field.
//  value               The value of the field.
//  size                The number of bits of the field (maximum is 4096).
//  radix               The radix to use for printing. The printer knob for radix is
//                      used if no radix is specified.
//  scope_separator     is used to find the leaf name since many printers only print
//                      the leaf name of a field. Typical values for the separator
//                      are . (dot) or [ (open bracket).