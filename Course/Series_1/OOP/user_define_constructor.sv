class first;

    int data;

    function new();
        data = 32;
    endfunction

endclass

module tb;

    first f1;

    initial begin
        f1 = new();
        $display("Data : %0d", f1.data);
    end

endmodule

//**************************************************************

class first;

    int data;

    function new(input int datain = 0);
        data = datain;
    endfunction

endclass

module tb;

    first f1;

    initial begin
        f1 = new(32);
        $display("Data : %0d", f1.data);
    end

endmodule