interface top_if;
    logic clk;
    logic [3:0] a;
    logic [3:0] b;
    logic [7:0] mul;
endinterface

class transaction;
    bit [3:0] a;
    bit [3:0] b;
    bit [7:0] mul;

    function void display();
        $display("a : %0d \t b : %0d \t mul : %0d", a, b, mul);
    endfunction
endclass

class scoreboard;
    mailbox #(transaction) mbx;
    transaction trans;

    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
    endfunction

    task compare(input transaction trans);
        if ((trans.mul) == (trans.a * trans.b)) begin
            $display("[SCO] : MUL RESULT MACHED");
        end else begin
            $error("[SCO] : MUL RESULT MISMATCHED");  //* $warning, $fatal
        end
    endtask
    
    task run();
        forever begin
            mbx.get(trans);
            $display("[SCO] : DATA RCVD FROM MONITOR");
            trans.display();
            compare(trans);
            #40;
        end
    endtask
endclass


class monitor;
    virtual top_if vif;
    mailbox #(transaction) mbx;
    transaction trans;

    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
    endfunction

    task run();
        trans = new();
        forever begin
            repeat(2) @(posedge vif.clk);
            trans.a = vif.a;
            trans.b = vif.b;
            trans.mul = vif.mul;
            $display("[MON] MON RCVD DATA FROM DUT");
            trans.display();
            mbx.put(trans);
        end
    endtask

endclass

module tb;
    mailbox #(transaction) mbx;
    top_if tif();
    monitor mon;
    scoreboard sco;

    top dut (.a(tif.a), .b(tif.b), .mul(tif.mul), .clk(tif.clk));

    always #10 tif.clk = ~tif.clk;
    initial begin
        tif.clk = 0;
    end

    initial begin
        for(int i = 0; i < 20; i++) begin
            repeat(2) @(posedge tif.clk);
            tif.a <= $urandom_range(1, 15);
            tif.b <= $urandom_range(1, 15);
        end
    end

    initial begin
        mbx = new();
        mon = new(mbx);
        sco = new(mbx);
        mon.vif = tif;
    end

    initial begin
        fork
            mon.run();
            sco.run();     
        join
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        #450;
        $finish();
    end
endmodule