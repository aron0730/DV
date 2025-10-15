//* 1. add transaction constructor in generator custom constructor
//* 2. Send deep copy of transaction between generator and driver

class transaction;
    randc bit [3:0] a;
    randc bit [3:0] b;

    function void display();
        $display("a : %0d \t b : %0d", a, b);
    endfunction

    function transaction copy();
        copy = new();
        copy.a = this.a;
        copy.b = this.b;
    endfunction
endclass

class generator;
    transaction trans;
    mailbox #(transaction) mbx;

    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
        trans = new();
    endfunction

    task run();
        for(int i = 0; i < 10; i++) begin
            assert(trans.randomize()) else $display("Randomization Failed");
            $display("[GEN] : DATA SENT TO DRIVER");
            trans.display();
            mbx.put(trans.copy);
        end
    endtask
endclass

module tb;
    generator gen;
    mailbox #(transaction) mbx;

    initial begin
        mbx = new();
        gen = new(mbx);
        gen.run();
    end
endmodule