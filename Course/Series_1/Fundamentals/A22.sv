`include "test.sv"


module tb;
  
    reg resetn = 0;   //////rst represent DUT reset Signal
    reg clk = 0;
    /////// User Logic goes here
    initial begin
    resetn = 1'b0;
    clk = 1'b0;
    end

    initial begin
    resetn = 1'b0;
    #100;
    resetn = 1'b1;
    forever begin
        #50;
        resetn = ~resetn;
    end
    end

    /////// User code ends here


    test t1 = new();

    initial begin
    #201;
    t1.no_gen(resetn);
    t1.display();
    end

endmodule