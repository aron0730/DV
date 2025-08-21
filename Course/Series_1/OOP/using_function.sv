module tb;

    function bit [3:0] add(input bit [3:0] a = 4'b0100, b = 4'b0010);
        return a + b;
    endfunction

    bit [4:0] result = 0;
    bit [3:0] ain = 4'b0100;
    bit [3:0] bin = 4'b0010;
    initial begin
        result = add(ain, bin);
        $display("Vlaue of addition : %0d", result);
    end
endmodule

//*****************************************************************************

module tb;

    bit [4:0] result = 0;
    bit [3:0] ain = 4'b0100;
    bit [3:0] bin = 4'b0010;

    function bit [4:0] add();
        return ain + bin;
    endfunction

    function void display_ain_bin();
        $display("Value of ain : %0d and bin : %0d", ain, bin);
    endfunction

    initial begin
        result = add();
        display_ain_bin();
        $display("Vlaue of addition : %0d", result);
    end
endmodule