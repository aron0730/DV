`include "uvm_macros.svh"
import uvm_pkg::*;
//////////////////////////////////////////////////////////////
class apb_config extends uvm_object;
    `uvm_object_utils(apb_config);

    function new(string name = "apb_config");
        super.new(name);
    endfunction

    uvm_active_passive_enum is_active = UVM_ACTIVE;
endclass
//////////////////////////////////////////////////////////////
typedef enum bit [1:0] {readd = 0, writed = 1, rst = 2} oper_mode;
//////////////////////////////////////////////////////////////
class transaction extends uvm_object;

    rand oper_mode      op;
         logic          PWRITE;
    rand logic [31:0]   PWDATA;
    rand logic [31:0]   PADDR;

    // Output Signals of DUT for APB UART's transaction
    logic               PREADY;
    logic               PSLVERR;
    logic [31:0]        PRDATA;

    `uvm_object_utils_begin(transaction)
        `uvm_field_int(PWRITE, UVM_ALL_ON)
        `uvm_field_int(PWDATA, UVM_ALL_ON)
        `uvm_field_int(PADDR, UVM_ALL_ON)
        `uvm_field_int(PREADY, UVM_ALL_ON)
        `uvm_field_int(PSLVERR, UVM_ALL_ON)
        `uvm_field_int(PRDATA, UVM_ALL_ON)
        `uvm_field_enum(oper_mode, op, UVM_ALL_ON)
    `uvm_object_utils_end

    constraint addr_c { PADDR <= 31; }
    constraint addr_c_err { PADDR > 31; }

    function new(string name = "transaction");
        super.new(name);
    endfunction
endclass : transaction
//////////////////////////////////////////////////////////////
class write_data extends uvm_sequence#(transaction);
    `uvm_object_utils(write_data)

    transaction tr;

    function new(string name = "write_data");
        super.new(name);
    endfunction

    virtual task body();
        repeat(15) begin
            tr = transaction::type_id::create("tr");
            tr.addr_c.constraint_mode(1);
            tr.addr_c_err.constraint_mode(0);

            start_item(tr);
            assert(tr.randomize());
            tr.op = writed;
            finish_item(tr);
        end
    endtask
endclass
//////////////////////////////////////////////////////////////
class read_data extends uvm_sequence#(transaction);
    `uvm_object_utils(read_data);

    transaction tr;

    function new(string name = "write_data");
        super.new(name);
    endfunction

    virtual task body();
        repeat(15) begin
            tr = transaction::type_id::create("tr");
            tr.addr_c.constraint_mode(1);
            tr.addr_c_err.constraint_mode(0);

            start_item(tr);
            assert(tr.randomize());
            tr.op = readd;
            finish_item(tr);
        end
    endtask
endclass
//////////////////////////////////////////////////////////////
class write_read extends uvm_sequence#(transaction);
    `uvm_object_utils(write_read);

    transaction tr;

    function new(string name = "write_read");
        super.new(name);
    endfunction

    virtual task body();
        repeat(15) begin
            tr = transaction::type_id::create("tr");
            tr.addr_c.constraint_mode(1);
            tr.addr_c_err.constraint_mode(0);

            start_item(tr);
            assert(tr.randomize());
            tr.op = writed;
            finish_item(tr);

            start_item(tr);
            assert(tr.randomize());
            tr.op = readd;
            finish_item(tr);
        end
    endtask
endclass
//////////////////////////////////////////////////////////////
class writeb_readb extends uvm_sequence#(transaction);
    `uvm_object_utils(writeb_readb);

    transaction tr;

    function new(string name = "writeb_readb");
        super.new(name);
    endfunction

    virtual task body();
        repeat(15) begin
            tr = transaction::type_id::create("tr");
            tr.addr_c.constraint_mode(1);
            tr.addr_c_err.constraint_mode(0);

            start_item(tr);
            assert(tr.randomize());
            tr.op = writed;
            finish_item(tr);
        end

        repeat(15) begin
            tr = transaction::type_id::create("tr");
            tr.addr_c.constraint_mode(1);
            tr.addr_c_err.constraint_mode(0);

            start_item(tr);
            assert(tr.randomize());
            tr.op = readd;
            finish_item(tr);
        end
    endtask
endclass
//////////////////////////////////////////////////////////////
class write_err extends uvm_sequence#(transaction);
    `uvm_object_utils(write_err)

    transaction tr;

    function new(string name = "write_err");
        super.new(name);
    endfunction

    virtual task body();
        repeat(15) begin
            tr = transaction::type_id::create("tr");
            tr.addr_c.constraint_mode(0);
            tr.addr_c_err.constraint_mode(1);

            start_item(tr);
            assert(tr.randomize());
            tr.op = writed;
            finish_item(tr);
        end
    endtask
endclass
//////////////////////////////////////////////////////////////
class read_err extends uvm_sequence#(transaction);
    `uvm_object_utils(read_err)

    transaction tr;

    function new(string name = "read_err");
        super.new(name);
    endfunction

    virtual task body();
        repeat(15) begin
            tr = transaction::type_id::create("tr");
            tr.addr_c.constraint_mode(0);
            tr.addr_c_err.constraint_mode(1);

            start_item(tr);
            assert(tr.randomize());
            tr.op = readd;
            finish_item(tr);
        end
    endtask
endclass
//////////////////////////////////////////////////////////////
class reset_dut extends uvm_sequence#(transaction);
    `uvm_object_utils(reset_dut)

    transaction tr;

    function new(string name = "reset_dut");
        super.new(name);
    endfunction

    virtual task body();
        repeat(15) begin
            `uvm_do_with(tr, {tr.op == rst;});
        end
    endtask
endclass
//////////////////////////////////////////////////////////////
class driver extends uvm_driver#(transaction);
    `uvm_component_utils(driver)

    virtual apb_if vif;
    transaction tr;

    function new(input string path = "drv", uvm_component parent);
        super.new(path, parent);
    endfunction

    virtual function build_phase(uvm_phase phase);
        super.build_phase(phase);
        tr = transaction::type_id::create("tr");
        if(!uvm_config_db::get(this, "", "vif", vif))
            `uvm_error("drv", "Unable to access Interface");
    endfunction

    task reset_dut();
        repeat(5) begin
            vif.presetn <=  1'b0;
            vif.paddr   <= 'h0;
            vif.pwdata  <= 'h0;
            vif.pwrite  <= 'b0;
            vif.psel    <= 'b0;
            vif.penable <= 'b0;
            `uvm_info("DRV", "System Reset : Start of Simulation", UVM_MEDIUM);
            @(posedge vif.pclk);
        end
    endtask

    virtual task drive();
        reset_dut();
        forever begin
            seq_item_port.get_next_item(tr);
            if(tr.op == rst) begin

            end
            else if(tr.op == writed) begin

            end
            else if(tr.op == readd) begin

            end
            seq_item_port.item_done(tr);
        end
    endtask

    virtual task run_phase(uvm_phase phase);
        drive();
    endtask

endclass