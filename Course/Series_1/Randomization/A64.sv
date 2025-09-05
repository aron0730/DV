class generator;
  
    rand bit rst;
    rand bit wr;
    
    /////////////////add constraint 
    constraint wr_c {
        wr dist {1 := 50, 0 := 50};
    }  

    constraint rst_c {
        rst dist {0 := 30, 1 := 70};
    }

endclass

module tb;

    generator g;

    initial begin
        g = new();

        for (int i = 0; i < 20; i++) begin
            assert(g.randomize()) else $display("[%0t] Failed to Randomization", $time);
            $display("[%0t]Value of wr : %0d, rst : %0d", $time, g.wr, g.rst);
            #20;
        end
    end
endmodule
 
/////////////////Add testbench top code