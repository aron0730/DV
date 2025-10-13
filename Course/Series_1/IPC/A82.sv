class transaction;
    bit [7:0] addr = 7'h12;
    bit [3:0] data = 4'h4;
    bit we = 1'b1;
    bit rst = 1'b0;
endclass

class generator;
    transaction t;
    mailbox #(transaction) mbx;

    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
    endfunction

    task main();
        t = new();
        $display("[GER] : addr 0x%0h, data 0x%0h, we %0d, rst %0d", t.addr, t.data, t.we, t.rst);
        mbx.put(t);
        #10;
    endtask
endclass

class driver;
    transaction dc;
    mailbox #(transaction) mbx;

    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
    endfunction

    task main();
        mbx.get(dc);
        $display("[DRV] : addr 0x%0h, data 0x%0h, we %0d, rst %0d", dc.addr, dc.data, dc.we, dc.rst);
        #10;
    endtask
endclass

module tb;
    mailbox #(transaction) mbx;
    generator g;
    driver d;

    initial begin
        mbx = new();
        g = new(mbx);
        d = new(mbx);

        fork
            g.main();
            d.main();
        join
        $finish;
    end
    
endmodule