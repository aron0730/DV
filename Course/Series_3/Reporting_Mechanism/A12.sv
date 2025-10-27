`include "uvm_macros.svh"
import uvm_pkg::*;

class driver extends uvm_driver;
    `uvm_component_utils(driver);

    function new(string path, uvm_component parent);
        super.new(path, parent);
    endfunction

    task run();
        `uvm_info("DRV", "UVM_NONE", UVM_NONE);
        `uvm_info("DRV", "UVM_LOW", UVM_LOW);
        `uvm_info("DRV", "UVM_HIGH", UVM_HIGH);
    endtask
endclass

module tb;
    driver d;

    initial begin
        d = new("DRV", null);
        d.set_report_verbosity_level(UVM_DEBUG);
        d.run();
    end
endmodule

//**********************************************************

`include "uvm_macros.svh"
import uvm_pkg::*;

class driver extends uvm_driver;
    `uvm_component_utils(driver);

    function new(string path, uvm_component parent);
        super.new(path, parent);
    endfunction

    task run();
        `uvm_info("DRV", "UVM_NONE", UVM_NONE);
        `uvm_info("DRV", "UVM_LOW", UVM_LOW);
        `uvm_info("DRV", "UVM_HIGH", UVM_HIGH);
    endtask
endclass

module tb;
    driver d;

    initial begin
        d = new("DRV", null);
        uvm_top.set_report_verbosity_level(UVM_DEBUG);
        // d.set_report_verbosity_level(UVM_DEBUG);
        #10;
        d.run();
    end
endmodule