`include "uvm_macros.svh"
import uvm_pkg::*;

class comp extends uvm_component;
    `uvm_component_utils(comp)
    
    function new(string path = "comp", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    task reset_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(" ")
    endtask
endclass