class transaction;
    randc bit [3:0] a;
    randc bit [3:0] b;
    bit [4:0] sum;

    function display();
        $display("a : %0d \t b : %0d \t sum : %0d", a, b, sum);
    endfunction
endclass

class error extends transaction;
    constraint data_c {a == 0; b == 0;}
endclass

class generator;
    mailbox #(transaction) mbx;
    transaction trans;
    event done;

    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
    endfunction

    task run();
        trans = new();
        for(int i = 0; i < 10; i++) begin
            trans.randomize();
            mbx.put(trans);
            $display("[GEN] : DATA SENT TO DRIVER");
            trans.display();
            #20;
        end
        ->done;
    endtask
endclass

interface add_if;
    logic [3:0] a;
    logic [3:0] b;
    logic [4:0] sum;
    logic clk;

    modport DRV (output a, b, input sum, clk);
endinterface

class driver;
    mailbox #(transaction) mbx;
    transaction data;
    virtual add_if aif;

    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
    endfunction

    task run();
        forever begin
            mbx.get(data);
            @(posedge aif.clk);
            aif.a <= data.a;
            aif.b <= data.b;
            $display("[DRV] : Interface Trigger");
            data.display();
        end
    endtask
endclass

module tb;
    mailbox #(transaction) mbx;
    generator gen;
    driver drv;
    event done;
    error err;

    add_if aif();
    add dut (.a(aif.a), .b(aif.b), .sum(aif.sum), .clk(aif.clk));

    always #10 aif.clk = ~aif.clk;
    initial begin
        aif.clk = 0;
    end

    initial begin
        mbx = new();
        gen = new(mbx);
        drv = new(mbx);
        drv.aif = aif;
        done = gen.done;

        err = new();
        gen.trans = err;  //* Constraint doesn't work
    end

    initial begin
        fork
            gen.run();
            drv.run();
        join_none
        wait(done.triggered);
        $finish();
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end

endmodule

//*************************************

class transaction;
    randc bit [3:0] a;
    randc bit [3:0] b;
    bit [4:0] sum;

    function display();
        $display("a : %0d \t b : %0d \t sum : %0d", a, b, sum);
    endfunction

    virtual function transaction copy();
        copy = new();
        copy.a = this.a;
        copy.b = this.b;
        copy.sum = copy.sum;
    endfunction
endclass

class error extends transaction;
    
    // constraint data_c {a == 0; b == 0;}

    function transaction copy();
        copy = new();
        copy.a = 0;
        copy.b = 0;
        copy.sum = copy.sum;
    endfunction

endclass

class generator;
    mailbox #(transaction) mbx;
    transaction trans;
    event done;

    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
        trans = new();
    endfunction

    task run();
        for(int i = 0; i < 10; i++) begin
            trans.randomize();
            mbx.put(trans.copy);
            $display("[GEN] : DATA SENT TO DRIVER");
            trans.display();
            #20;
        end
        ->done;
    endtask
endclass

interface add_if;
    logic [3:0] a;
    logic [3:0] b;
    logic [4:0] sum;
    logic clk;

    modport DRV (output a, b, input sum, clk);
endinterface

class driver;
    mailbox #(transaction) mbx;
    transaction data;
    virtual add_if aif;

    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
    endfunction

    task run();
        forever begin
            mbx.get(data);
            @(posedge aif.clk);
            aif.a <= data.a;
            aif.b <= data.b;
            $display("[DRV] : Interface Trigger");
            data.display();
        end
    endtask
endclass

module tb;
    mailbox #(transaction) mbx;
    generator gen;
    driver drv;
    event done;
    error err;

    add_if aif();
    add dut (.a(aif.a), .b(aif.b), .sum(aif.sum), .clk(aif.clk));

    always #10 aif.clk = ~aif.clk;
    initial begin
        aif.clk = 0;
    end

    initial begin
        mbx = new();
        gen = new(mbx);
        drv = new(mbx);
        drv.aif = aif;
        done = gen.done;

        err = new();
        gen.trans = err;
    end

    initial begin
        fork
            gen.run();
            drv.run();
        join_none
        wait(done.triggered);
        $finish();
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end

endmodule