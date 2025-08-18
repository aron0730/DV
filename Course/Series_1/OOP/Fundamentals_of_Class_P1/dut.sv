module top (input a,b,
            output y);

    reg temp;

    assign y = a & b;
endmodule

module top2 (input c, d, 
             output y);
    top dut (c, d, y);
    dut.temp;
    
endmodule