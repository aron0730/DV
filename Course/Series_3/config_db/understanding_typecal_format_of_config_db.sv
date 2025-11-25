`include "uvm_macros.svh"
import uvm_pkg::*;

class env extends uvm_env;
    `uvm_component_utils(env)

    int data;

    function new(string path = "env", uvm_component parent = null);
        super.new(path, parent);
        

    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        if (uvm_config_db#(int)::get(null, "uvm_test_top", "data", data))
            `uvm_info("ENV", $sformatf("Value of data : %0d", data), UVM_NONE)
        else
            `uvm_error("ENV", "Umable to access the value");
    endfunction
    
endclass

class test extends uvm_test;
    `uvm_component_utils(test)

    env e;

    function new(string path = "test", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        e = env::type_id::create("e", this);
        uvm_config_db#(int)::set(null, "uvm_test_top", "data", 12);  // contest + instance name + key + value
    endfunction
    
endclass

module tb;

    initial begin

        run_test("test");
    end
endmodule