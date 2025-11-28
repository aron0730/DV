`include "uvm_macros.svh"
import uvm_pkg::*;

class test extends uvm_test;
    `uvm_component_utils(test);

    function new (string path = "test", uvm_component parent);
        super.new(path, parent);
    endfunction
    
    //! Construction Phases
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_name(), "Build Phase Executed", UVM_NONE);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_name(), "Connect Phase Executed", UVM_NONE);
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info(get_name(), "End of Elaboration Phase Executed", UVM_NONE);
    endfunction
    
    //! Main Phases
    task run_phase(uvm_phase phase);
        `uvm_info(get_name(), "Run Phase", UVM_NONE);
    endtask

    //! Cleanup Phases
    function void extract_phase(uvm_phase phase);
        super.extract_phase(phase);
        `uvm_info(get_name(), "Extract Phase Executed", UVM_NONE);
    endfunction

    function void check_phase(uvm_phase phase);
        super.check_phase(phase);
        `uvm_info(get_name(), "Check Phase Executed", UVM_NONE);
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info(get_name(), "Report Phase Executed", UVM_NONE);
    endfunction

    function void final_phase(uvm_phase phase);
        super.final_phase(phase);
        `uvm_info(get_name(), "Final Phase Executed", UVM_NONE);
    endfunction
endclass

module tb;
    initial begin
        run_test("test");
    end
endmodule