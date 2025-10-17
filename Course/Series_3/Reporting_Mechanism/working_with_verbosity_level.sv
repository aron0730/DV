`include "uvm_macros.svh"

import uvm_pkg::*;

module tb;

    initial begin
        $display("Default Verbosity level : %0d", uvm_top.get_report_verbosity_level);
        #10;
        `uvm_info("TB_TOP", "String MEDIUM", UVM_MEDIUM);
        `uvm_info("TB_TOP", "String HIGH", UVM_HIGH);
        uvm_top.set_report_verbosity_level(UVM_HIGH);
        $display("Default Verbosity level : %0d", uvm_top.get_report_verbosity_level);
        `uvm_info("TB_TOP", "String MEDIUM", UVM_MEDIUM);
        `uvm_info("TB_TOP", "String HIGH", UVM_HIGH);
    end

endmodule

// UVM_ROOT is parent to all the classes that we add in UVM Testbench environment(UVM Tree).
// Because UVM_ROOT returns a null pointer, we cannot directly access it.
// However, in a few situations, we may need to access or configure the default settings of UVM_ROOT.
//
// In such a case, UVM provides a global variable UVM_TOP which is accessible to all classes of environment.
// UVM_TOP could be used whenever we need to work with the UVM root.



// UVM_TOP 與 uvm_root::get()
// 兩者其實是同一個物件，只是不同的存取方式：
// uvm_root r1 = uvm_root::get();
// uvm_root r2 = UVM_TOP;
// assert(r1 == r2);
// 差別在於：
// UVM_TOP 是 一個全域變數 (global variable)；
// uvm_root::get() 是 一個靜態函數 (singleton accessor)。
// 功能等價，但 UVM_TOP 更常用在 testbench 中快速呼叫。