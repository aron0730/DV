// Syntax
program [name] [port_list];
    // ...
endprogram

program test1 (input clk, reset);
    initial ...
endprogram

program test2 (interface wb_if);
    initial ...
endprogram

program test3;
    initial ...
endprogram


module tb;
    bit [3:0] mode;

    program p1;
        // ...
    endprogram

    program p2;
        // ...
    endprogram

endmodule
