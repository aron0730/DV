`include "uvm_macrhs.svh"
import uvm_pkg::*;

class spi_config extends uvm_object;
    `uvm_object_utils(spi_config)

    function new(string name = "spi_config");
        super.new(name);
    endfunction

    uvm_active_passive_enum is_active = UVM_ACTIVE;
endclass

typedef enum bit [2:0] {readd = 0, writed = 1, rstdut = 2, writeerr = 3, readerr = 4} oper_mode;

class transaction extends uvm_sequence_item;
    
    rand oper_mode op;
         logic wr;
         logic rst;
    randc logic [7:0] addr;
    rand logic [7:0] din;
         logic [7:0] dout;
         logic done;
         logic err;
    
    `uvm_object_utils_begin(transaction)
        `uvm_field_int(wr, UVM_ALL_ON)
        `uvm_field_int(rst, UVM_ALL_ON)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(din, UVM_ALL_ON)
        `uvm_field_int(dout, UVM_ALL_ON)
        `uvm_field_int(done, UVM_ALL_ON)
        `uvm_field_int(err, UVM_ALL_ON)
        `uvm_field_enum(oper_mode, op, UVM_DEFAULT)
    `uvm_object_utils_end

    constraint addr_c {addr <= 10;}
    constraint addr_c_err {addr > 31;}

    function new(string name = "transaction");
        super.new(name);
    endfunction
    
endclass

/////////////////////////////////////////////////////////////////////////
class write_data extends uvm_sequence#(transaction);
    `uvm_object_utils(write_data)

    transaction tr;

    function new(string name = "write_data");
        super.new(name);
    endfunction

    virtual task body();
        repeat(5) begin
            tr = transaction::type_id::create("tr");
            tr.addr_c.constraint_mode(1);
            tr.addr_c_err.constraint_mode(0);
            start_item(tr);
            assert(tr.randomize);
            tr.op = writed;
            finish_item(tr);
        end
    endtask
endclass

class write_err extends uvm_sequence#(transaction)
    `uvm_object_utils(write_err)

    function new(string name = "write_err");
        super.new(name);
    endfunction

    virtual task body();
        repeat(15) begin
            tr = transaction::type_id::create("tr");
            tr.addr_c_err.constraint_mode(1);
            tr.addr_c.constraint_mode(0);
            start_item(tr);
            assert(tr.randomize);
            tr.op = writed;
            finish_item(tr);
        end
    endtask
endclass

class read_data extends uvm_sequence#(transaction);
    `uvm_object_utils(read_data)

    transaction tr;

    function new(string name = "read_data");
        super.new(name);
    endfunction

    virtual task body();
        repeat(15) begin
            tr = transaction::type_id::create("tr");
            tr.addr_c.constraint_mode(1);
            tr.addr_c_err.constraint_mode(0);
            start_item(tr);
            assert(tr.randomize);
            tr.op = readd;
            finish_item(tr);
        end
    endtask
endclass

class read_err extends uvm_sequence#(transaction)
    `uvm_object_utils(read_err)

    function new(string name = "read_err");
        super.new(name);
    endfunction

    virtual task body();
        repeat(15) begin
            tr = transaction::type_id::create("tr");
            tr.addr_c.constraint_mode(0);
            tr.addr_c_err.constraint_mode(1);
            start_item(tr);
            assert(tr.randomize);
            tr.op = readd;
            finish_item(tr);
        end
    endtask
endclass

class reset_dut extends uvm_sequence#(transaction);
    `uvm_object_utils(reset_dut)

    transaction tr;

    function new(string name = "reset_dut");
        super.new(name);
    endfunction

    virtual task body();
        repeat(15) begin
            tr = transaction::type_id::create("tr");
            tr.addr_c.constraint_mode(1);
            tr.addr_c_err.constraint_mode(0);
            start_item(tr);
            assert(tr.randomize);
            tr.op = rstdut;
            finish_item(tr);
        end
    endtask
endclass

class writeb_readb extends uvm_sequence#(transaction);
    `uvm_object_utils(writeb_readb)

    function new(string name = "writeb_readb");
        super.new(name);
    endfunction

    virtual task body();
        repeat(10) begin  // write 10 transactions
            tr = transaction::type_id::create("tr");
            tr.addr_c.constraint_mode(1);
            tr.addr_c_err.constraint_mode(0);
            start_item(tr);
            assert(tr.randomize);
            tr.op = writed;
            finish_item(tr);
        end

        repeat(10) begin  // read 10 transactions
            tr = transaction::type_id::create("tr");
            tr.addr_c.constraint_mode(1);
            tr.addr_c_err.constraint_mode(0);
            start_item(tr);
            assert(tr.randomize);
            tr.op = readd;
            finish_item(tr);
        end
    endtask
endclass
/////////////////////////////////////////////////////////////////////////