module tb;

    function automatic bit [31:0] multiplication (input bit [31:0] a, b);
        return a * b;
    endfunction

    bit [31:0] result = 0;
    bit [31:0] expected = 0;
    initial begin
        bit [31:0] ain = 32'h20;
        bit [31:0] bin = 32'h11a;

        expected = a * b;
        result = multiplication(ain, bin);
        $display("value of multiplication : %0d * %0d = %0d", ain, bin, result);
        
        if (result == expected)
            $display("Test Passed");
        else
            $display("Test Failed : Expected %0d, Got %0d", expected, result);
    end
endmodule

