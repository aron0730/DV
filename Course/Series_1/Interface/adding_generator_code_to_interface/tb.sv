//* 1. add transaction constructor in generator custom constructor
//* 2. Send deep copy of transaction between generator and driver

class transaction;
    randc bit [3:0] a;
    randc bit [3:0] b;
    bit [4:0] sum;

    function void display();
        $display("a : %0d \t b : %0d \t sum : %0d", a, b, sum);
    endfunction

    function transaction copy();
        copy = new();
        copy.a = this.a;
        copy.b = this.b;
        copy.sum = this.sum;
    endfunction
endclass

class generator;
    transaction trans;
    mailbox #(transaction) mbx;
    event done;

    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
        trans = new();
    endfunction

    task run();
        for(int i = 0; i < 10; i++) begin
            assert(trans.randomize()) else $display("Randomization Failed");
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
endinterface

class driver;
    virtual add_if aif;
    mailbox #(transaction) mbx;
    transaction data;
    event next;

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
            ->next;
        end
    endtask
endclass

module tb;
    generator gen;
    driver drv;
    mailbox #(transaction) mbx;
    add_if aif();
    event done;

    add dut(.a(aif.a), .b(aif.b), .sum(aif.sum), .clk(aif.clk));

    always #10 aif.clk <= ~aif.clk;
    initial begin
        aif.clk <= 0;
    end

    initial begin
        mbx = new();
        gen = new(mbx);
        drv = new(mbx);
        drv.aif = aif;
        done = gen.done;
    end

    initial begin
        fork
            drv.run();
            gen.run();
        join_none
        wait(done.triggered);
        #1step;
        $finish();
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
endmodule