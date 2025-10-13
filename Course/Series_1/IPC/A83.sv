class transaction;
    rand bit [7:0] a;
    rand bit [7:0] b;
    rand bit wr;
endclass

class generator;
    transaction t;
    mailbox #(transaction) mbx;

    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
    endfunction

    task run();
        for(int i = 0; i < 10; i++) begin
            t = new();
            assert(t.randomize()) else $display("Trans randomization failed");
            $display("[GER] : SENT a %0d, b %0d, wr %0d", t.a, t.b, t.wr);
            mbx.put(t);
            #10;
        end
    endtask
endclass

class driver;
    transaction dc;
    mailbox #(transaction) mbx;

    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
    endfunction

    task run();
        forever begin
            mbx.get(dc);
            $display("[DRV] : RCVD a %0d, b %0d, wr %0d", dc.a, dc.b, dc.wr);
            #10;
        end
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
            g.run();
            d.run();
        join
        $finish;
    end
endmodule


//*********************************

//* Use sentinel to EOT

class transaction;
    rand bit [7:0] a;
    rand bit [7:0] b;
    rand bit wr;
endclass

class generator;
    transaction t;
    mailbox #(transaction) mbx;

    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
    endfunction

    task run();
        for(int i = 0; i < 10; i++) begin
            t = new();
            assert(t.randomize()) else $display("Trans randomization failed");
            $display("[GER] : SENT a %0d, b %0d, wr %0d", t.a, t.b, t.wr);
            mbx.put(t);
            #10;
        end

        // <<< send sentinel >>>
        mbx.put(null);
        $display("[GER] : SENT EOT (null transaction)");
    endtask
endclass

class driver;
    transaction dc;
    mailbox #(transaction) mbx;

    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
    endfunction

    task run();
        forever begin
            mbx.get(dc);  // it will be unblocking by EOT
            if (dc == null) begin
                $display("[DRV]: GOT EOT, stopping.");
                break;
            end
            $display("[DRV] : RCVD a %0d, b %0d, wr %0d", dc.a, dc.b, dc.wr);
            #10;
        end
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
            g.run();
            d.run();
        join
        $finish;
    end
endmodule

//*************************
//* use fork_any + disable fork

class transaction;
    rand bit [7:0] a, b;
    rand bit wr;
endclass

class generator;
    mailbox #(transaction) mbx;
    function new(mailbox #(transaction) mbx); this.mbx = mbx; endfunction

    task run();
        for (int i = 0; i < 10; i++) begin
            transaction t = new();
            assert(t.randomize()) else $display("Randomization failed");
            $display("[GEN] Sent a=%0d b=%0d wr=%0d", t.a, t.b, t.wr);
            mbx.put(t);
            #10;
        end
        $display("[GEN] All transactions sent!");
    endtask
endclass

class driver;
    mailbox #(transaction) mbx;
    function new(mailbox #(transaction) mbx); this.mbx = mbx; endfunction

    task run();
        transaction t;
        forever begin
            mbx.get(t);
            $display("[DRV] Got a=%0d b=%0d wr=%0d", t.a, t.b, t.wr);
            #10;
        end
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
            g.run();  // Thread 1
            d.run();  // Thread 2 (forever loop)
        join_any

        // 任何一個 fork thread 結束（generator 結束）就執行這裡
        disable fork;  // 終止所有 fork 中仍在執行的其他 thread（driver）
        $display("[TB] Generator done → stopping driver and finishing sim.");
        #10 $finish;
    end
endmodule