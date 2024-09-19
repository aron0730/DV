module tb
    reg [7:0] a, b;
    reg [7:0] result;

    initial begin
        a = 4;
        b = 5;
        #10 result = sum(a, b);
    end
endmodule

function [7:0] sum;
    input [7:0] a, b;
    begin
        sum = a + b;
    end
endfunction

function [7:0] sum (input [7:0] a, b);
    begin
        sum = a + b;
    end
endfunction

