`include "uvm_macros.svh"
import uvm_pkg::*;

class driver extends uvm_driver;
`uvm_component_utils(driver)

    function new(string path, uvm_component parent);
        super.new(path, parent);
    endfunction

    task run();
        `uvm_info("TB_TOP", $sformatf("First RTL : Aaron"), UVM_NONE);
    endtask
endclass

module tb;
    driver d;

    initial begin
        d = new("DRV", null);
        d.run();
    end
endmodule