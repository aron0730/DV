`include "uvm_macros.svh"
import uvm_pkg::*;

class comp1 extends uvm_component;
    `uvm_component_utils(comp1)

    int data1 = 0;
    function new(input string path = "comp1", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(int)::get(null, "uvm_test_top", "data", data1))
            `uvm_error("comp1", "Unable to access Interface");
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("comp1", $sformatf("Data rcvd comp1 : %0d", data1), UVM_NONE);
        phase.drop_objection(this);
    endtask
endclass

class comp2 extends uvm_component;
    `uvm_component_utils(comp2)

    int data2 = 0;
    function new(input string path = "comp2", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(int)::get(null, "uvm_test_top", "data", data2))  // cntxt = null, 代表用絕對路徑去查, 如果設定cntxt = this配合 "", 就是由此component往上爬去搜尋
            `uvm_error("comp2", "Unable to access Interface");
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("comp2", $sformatf("Data rcvd comp2 : %0d", data2), UVM_NONE);
        phase.drop_objection(this);        
    endtask

endclass

/////////////////////////////////////////////////////////////////////////
class agent extends uvm_agent;
    `uvm_component_utils(agent)

    function new(string inst = "AGENT", uvm_component parent = null);
        super.new(inst, parent);
    endfunction

    comp1 c1;
    comp2 c2;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        c1 = comp1::type_id::create("comp1", this);
        c2 = comp2::type_id::create("comp2", this);
    endfunction


endclass

//////////////////////////////////////////////////////////////////////////
class env extends uvm_env;
    `uvm_component_utils(env);

    function new(input string inst = "ENV", uvm_component c);
        super.new(inst, c);
    endfunction

    agent a;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        a = agent::type_id::create("AGENT", this);
    endfunction
endclass

///////////////////////////////////////////////////////////////////////////
class test extends uvm_test;
    `uvm_component_utils(test);

    function new(input string inst = "TEST", uvm_component c);
        super.new(inst, c);
    endfunction

    env e;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        e = env::type_id::create("ENV", this);
    endfunction
endclass
///////////////////////////////////////////////////////////////////////////
module tb;
    int data = 256;

    initial begin
        uvm_config_db#(int)::set(null, "uvm_test_top", "data", data);  // uvm_test_top.data
        run_test("test");
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
endmodule
