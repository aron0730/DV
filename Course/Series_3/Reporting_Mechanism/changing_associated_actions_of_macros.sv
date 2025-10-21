// Define all possible values for report actions. Each report is configured
// to execute one or more actions, determined by the bitwise OR of any or all
// of the following enumeration constants.
//
// ******************************************
// UVM_NO_ACTION  - No action is taken
// UVM_DISPLAY    - Sends the report to the standard output
// UVM_LOG        - Sends the report to the file(s) for this (severity,id) pair
// UVM_COUNT      - Counts the number of reports with the COUNT attribute.
//                  When this value reaches max_quit_count, the simulation terminates
// UVM_EXIT       - Terminates the simulation immediately
// UVM_CALL_HOOK  - Callback the report hook methods
// UVM_STOP       - Causes ~$stop~ to be executed, putting the simulation into
//                  interactive mode.
// UVM_RM_RECORD  - Sends the report to the recorder

`include "uvm_macros.svh"
import uvm_pkg::*;

////////////////////////////////////
class driver extends uvm_driver;

    `uvm_component_utils(driver)

    function new(string path, uvm_component parent);
        super.new(path, parent);
    endfunction

    task run();
        `uvm_info("DRV", "Informational Message", UVM_NONE);
        `uvm_warning("DRV", "Potential Error");
        `uvm_error("DRV", "Real Error");
        #10;
        `uvm_fatal("DRV", "Simulation cannot continue");
        #10;
        `uvm_fatal("DRV1", "Simulation cannot continue");
    endtask
endclass

////////////////////////////////////
module tb;
    driver d;

    initial begin
        d = new("DRV", null);
        // d.set_report_severity_action(UVM_INFO, UVM_NO_ACTION);
        // d.set_report_severity_action(UVM_INFO, UVM_DISPLAY | UVM_EXIT);
        d.set_report_severity_action(UVM_FATAL, UVM_DISPLAY);
        d.run();
    end
endmodule