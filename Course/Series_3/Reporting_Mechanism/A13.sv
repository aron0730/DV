`include "uvm_macros.svh"
import uvm_pkg::*;

class driver extends uvm_driver;
    `uvm_component_utils(driver);

    function new(string path, uvm_component parent);
        super.new(path, parent);
    endfunction

    task run();
        `uvm_warning("DRV", "UVM_WARNING 1");
        `uvm_warning("DRV", "UVM_WARNING 2");
        `uvm_warning("DRV", "UVM_WARNING 3");
        `uvm_warning("DRV", "UVM_WARNING 4");
    endtask
endclass

module tb;
    driver d;

    initial begin
        d = new("DRV", null);
        d.set_report_severity_action(UVM_WARNING, UVM_DISPLAY|UVM_COUNT);
        d.set_report_max_quit_count(4);
        #10;
        d.run();
    end
endmodule