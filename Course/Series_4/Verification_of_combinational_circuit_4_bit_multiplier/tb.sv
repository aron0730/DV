`include "uvm_macros.svh"
import uvm_pkg::*;

class transaction extends uvm_sequence_item;
    `uvm_object_utils(transaction)

    rand bit [3:0] a;
    rand bit [3:0] b;
         bit [4:0] y;

    function new(input string path = "transaction");
        super.new(path);
    endfunction

endclass
///////////////////////////////////////////////////////////

class generator extends uvm_sequence#(transaction);
    `uvm_object_utils(generator)

    transaction tr;

    function new(input string path = "generator");
        super.new(path);
    endfunction

    virtual task body();
        repeat(15) begin
            tr = transaction::type_id::create("tr");
            start_item(tr);
            assert(tr.randomize());
            `uvm_info("SEQ", $sformatf("a : %0d b : %0d y : %0d", tr.a, tr.b, tr.y), UVM_NONE);
            finish_item(tr);
        end
    endtask
endclass
///////////////////////////////////////////////////////////
class drv extends uvm_driver#(transaction);
    `uvm_component_utils(drv)

    transaction tr;
    virtual mul_if mif;

    function new(input string path = "drv", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual mul_if)::get(this, "", "mif", mif))  //* uvm_test_top.env.agent.drv.aif
            `uvm_error("drv", "Umable to access Interface");
    endfunction

    virtual task run_phase(uvm_phase phase);
        tr = transaction::type_id::create("tr");
        forever begin
            seq_item_port.get_next_item(tr);
            mif.a <= tr.a;
            mif.b <= tr.b;
            `uvm_info("DRV", $sformatf("a : %0d b : %0d y : %0d", tr.a, tr.b, tr.y), UVM_NONE);
            seq_item_port.item_donw(tr);
            #20;
        end
    endtask
endclass
///////////////////////////////////////////////////////////
class mon extends uvm_monitor;
    `uvm_component_utils(mon)

    uvm_analysis_port#(transaction) send;
    transaction tr;
    virtual mul_if mif;

    function new(input string path = "mon", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        send = new("send", this);
        tr = transaction::type_id::create("tr");
        if(!uvm_config_db#(virtual mul_if)get::(this, "", "mif", mif))
            `uvm_error("MON", "Unable to access Interface");
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            #20;
            tr.a = mif.a;
            tr.b = mif.b;
            tr.y = mif.y;
            `uvm_info("MON", $sformatf("a : %0d b : %0d y : %0d", tr.a, tr.b, tr.y), UVM_NONE);
            send.write(tr);  //!
        end
    endtask
endclass

///////////////////////////////////////////////////////////
class sco extends uvm_scoreboard;
    uvm_component_utils(sco);
    
    uvm_analysis_imp#(transaction) recv;

    function new(input string path = "sco", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function build_phase(uvm_phase phase);
        super.build_phase(phase);
        recv = new("recv", this);
    endfunction

    virtual function void write(transaction tr);
        if(tr.y == (tr.a * tr.b))
            `uvm_info("SCO", $sformatf("Test Passed -> a : %0d b : %0d y : %0d", tr.a, tr.b, tr.y), UVM_NONE);
        else
            `uvm_error("SCO", $sformatf("Test Failed -> a : %0d b : %0d y : %0d", tr.a, tr.b, tr.y), UVM_NONE);
        $display("---------------------------------------------------------");
    endfunction
endclass
