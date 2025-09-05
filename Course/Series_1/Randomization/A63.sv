class generator;
  
    rand bit [4:0] a;
    rand bit [5:0] b;
    
    constraint data {
        a inside {[0:8]};
        b inside {[0:5]};
    } 

endclass

module tb;

    generator g;

    initial begin
        g = new();
        int err_count = 0;

        for (int i = 0; i < 20; i++) begin
            assert(g.randomize()) else begin
                err_count++;
                $display("[%0t]Failed Randomization (count : %0d)", $time, err_count);
                continue;
            end 
            $display("Value of a : %0d, b : %0d, err count : %0d", g.a, g.b, err_count);
        end

        $display("===Summary ===");
        $display("Total randomize failures: %0d", err_count);
        $finish;
    end
endmodule