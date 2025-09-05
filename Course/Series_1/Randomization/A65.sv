class generator;
    rand bit [3:0] addr;
    rand bit wr;

    constraint addr_c {
        (wr == 1) -> (addr inside {[0:7]});
        (wr == 0) -> (addr inside {[8:15]});
    }

endclass

module tb;

    generator g;

    initial begin
        g = new();

        for (int i = 0; i < 20; i++) begin
            
            assert(g.randomize()) else $display("[%0t] Failed to Randomization", $time);
            $display("[%0t]Value of wr : %0d, addr : %0d", $time, g.wr, g.addr);

        end
        $finish;
    end
endmodule