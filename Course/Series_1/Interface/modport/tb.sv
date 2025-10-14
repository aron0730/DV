interface add_if;
    logic [3:0] a;
    logic [3:0] b;
    logic [4:0] sum;
    logic clk;

    modport DRV (
        output a, b,
        input sum, clk
    );

    modport MON (

    );
endinterface

class drive;
    virtual add_if.DRV aif;

    task run();
        forever begin
            @(posedge aif.clk);
            aif.a <= 2;
            aif.b <= 3;
            $display("[DRV] : Interface Trigger");
        end
    endtask
endclass

module tb;
    add_if aif();
    add dut (.a(aif.a), .b(aif.b), .sum(aif.sum), .clk(aif.clk));

    always #10 aif.clk = ~aif.clk;
    initial begin
        aif.clk = 0;
    end

    drive drv;
    initial begin
        drv = new();
        drv.aif = aif;
        drv.run();
    end

    initial begin
        $dumpfile("dump.vcd"); 
        $dumpvars;  
        #100;
        $finish();
    end

endmodule