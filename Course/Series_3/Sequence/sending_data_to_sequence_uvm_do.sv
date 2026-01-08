`include "uvm_macros.svh"
import uvm_pkg::*;

class transaction extends uvm_sequence_item;
    
    rand bit [3:0] a;
    rand bit [3:0] b;
    rand bit [4:0] y;
    
    function new(input string inst = "transaction");
        super.new(inst);
    endfunction

    `uvm_object_utils_begin(transaction)
        `uvm_field_int(a, UVM_DEFAULT)
        `uvm_field_int(b, UVM_DEFAULT)
        `uvm_field_int(y, UVM_DEFAULT)
    `uvm_object_utils_end

endclass
///////////////////////////////////////////////////////////////

class sequence1 extends uvm_sequence#(transaction);
    `uvm_object_utils(sequence1)

    transaction trans;

    function new(input string inst = "sequence1");
        super.new(inst);
    endfunction

    virtual task body();
        repeat(5) begin
            `uvm_do(trans)
            `uvm_info("SEQ1", $sformatf("a : %0d b : %0d", trans.a, trans.b), UVM_NONE);
        end
    endtask
endclass
///////////////////////////////////////////////////////////////

class driver extends uvm_driver#(transaction);
    `uvm_component_utils(driver)
    
    transaction trans;

    function new(input string inst = "driver", uvm_component parent = null);
        super.new(inst, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        trans = transaction::type_id::create("trans");
        forever begin
            seq_item_port.get_next_item(trans);
            `uvm_info("DRV", $sformatf("a : %0d b : %0d", trans.a, trans.b), UVM_NONE);
            seq_item_port.item_done();
        end
    endtask
endclass
///////////////////////////////////////////////////////////////

class agent extends uvm_agent;
    `uvm_component_utils(agent)

    uvm_sequencer #(transaction) seqr;
    driver d;

    function new(input string inst = "agent", uvm_component parent = null);
        super.new(inst, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        seqr = uvm_sequencer #(transaction)::type_id::create("SEQR", this);
        d = driver::type_id::create("DRV", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        d.seq_item_port.connect(seqr.seq_item_export);
    endfunction
endclass
///////////////////////////////////////////////////////////////

class env extends uvm_env;
    `uvm_component_utils(env)

    agent a;


    function new(input string inst = "env", uvm_component parent = null);
        super.new(inst, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        a = agent::type_id::create("AGENT", this);
    endfunction
    
endclass
///////////////////////////////////////////////////////////////
class test extends uvm_test;
    `uvm_component_utils(test)

    sequence1 seq1;
    env e;

    function new(input string inst = "env", uvm_component parent = null);
        super.new(inst, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        seq1 = sequence1::type_id::create("SEQ1");
        e = env::type_id::create("ENV", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        seq1.start(env.a.seqr);
        phase.drop_objection(this);
    endtask
endclass
///////////////////////////////////////////////////////////////

module tb;
 
  
  initial begin
    run_test("test");
  end
  
  
endmodule




`uvm_do(trans)

`uvm_create(item)
sequencer.wait_for_grant(prior)
this.pre_do(1)
item.randomize()
this.mid_do(item)
sequencer.send_request(item)
sequencer.wait_for_item_done()
this.post_do(item)
