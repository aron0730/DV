// Use of specify block

specify

    specparam t_rise = 200, t_fall = 150;
    specparam clk_to_q = 70, d_to_q = 100;
endspecify


// Within main module

module my_block (...);

    specparam dhold = 2.0;
    specparam ddly  = 1.5;
    parameter WIDTH = 32;

endmodule