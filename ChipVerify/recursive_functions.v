
function automatic integer factorial(integer i);
    integer result = i;

    if (i) begin
        result = i * factorial (i - 1)
        $display("i = %0d, result = %0d", i, result);
    end else
        result = 1;

    return result;
endfunction


module tb
    initial begin
        integer result = factorial(4);
        $display("factorial(4) = %0d", result);
    end
endmodule
