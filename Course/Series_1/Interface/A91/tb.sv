class transaction;
    randc bit [3:0] a;
    randc bit [3:0] b;
    bit [7:0] mul;

    function void display();
        $display("[Trans] : a %0d, b %0d, mul %0d", a, b, mul);
    endfunction

    function transaction copy();
        copy = new();
        copy.a = this.a;
        copy.b = this.b;
        copy.mul = this.mul;
    endfunction
endclass

class generator;
    mailbox #(transaction) mbx;
    transaction trans;
    event done, next;

    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
        trans = new();
    endfunction

    task run();
        for(int i = 0; i < 10; i++) begin
            assert(trans.randomize()) else $display("[GEN] Randomization Failed");
            mbx.put(trans.copy());
            $display("[GEN] SENT TRANS TO DRV");
            trans.display();
            wait(next.triggered);
          	#1step;
        end
        ->done;
    endtask
endclass

interface mul_if;
    logic [3:0] a;
    logic [3:0] b;
    logic [7:0] mul;
    logic clk;
endinterface

class driver;
    mailbox #(transaction) mbx;
    transaction data;
    event next;

    virtual mul_if mif;

    function new(mailbox #(transaction) mbx);
        this.mbx = mbx;
    endfunction

    task run();
        forever begin
            mbx.get(data);
            @(posedge mif.clk);
            mif.a <= data.a;
            mif.b <= data.b;
            $display("[DRV] Interface Triggered");
            $display("[DRV] : a %0d, b %0d", data.a, data.b);
            ->next;
        end
    endtask
endclass

module tb;
    mailbox #(transaction) mbx;
    generator gen;
    driver drv;
    event done;

    mul_if mif();
    top dut (.clk(mif.clk), .a(mif.a), .b(mif.b), .mul(mif.mul));

    initial begin
        mif.clk = 0;
    end
	always #10 mif.clk = ~mif.clk;	
  
    initial begin
        mbx = new();
        gen = new(mbx);
        drv = new(mbx);
        drv.mif = mif;
        done = gen.done;
        gen.next = drv.next;
    end

    initial begin
        fork
            gen.run();
            drv.run();
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
