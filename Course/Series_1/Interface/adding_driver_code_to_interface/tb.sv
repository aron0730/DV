interface add_if;
    logic [3:0] a, b;
    logic [4:0] sum;
    logic clk;
endinterface

class driver;
    virtual add_if aif;

    task run();
        forever begin
            @(posedge aif.clk);
            aif.a <= 3;
            aif.b <= 3;
        end
    endtask
endclass

module tb;
    add_if aif();
    add dut(.a(aif.a), .b(aif.b), .sum(aif.sum), .clk(aif.clk));

    always #10 aif.clk <= ~aif.clk;
    initial begin
        aif.clk <= 0;
    end

    driver drv;
    initial begin
        drv = new();
        drv.aif = aif;
        drv.run();
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        #100;
        $finish;
    end
endmodule