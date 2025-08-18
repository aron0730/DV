class transaction;

    bit [31:0] data1;
    bit [31:0] data2;
    bit [31:0] data3;

    function void display();
        $display("trans data1 : %0d, data2 : %0d, data3 : %0d", data1, data2, data3);
    endfunction

endclass

module tb;

    transaction trans;

    initial begin
        trans = new();
        trans.data1 = 45;
        trans.data2 = 78;
        trans.data3 = 90;
        #1;
        trans.display();
    end
endmodule

//*****************************************************************

class transaction;

    bit [31:0] data1;
    bit [31:0] data2;
    bit [31:0] data3;

    function new(bit[31:0] d1, d2, d3);
        data1 = d1;
        data2 = d2;
        data3 = d3;
    endfunction
    function void display();
        $display("trans data1 : %0d, data2 : %0d, data3 : %0d", data1, data2, data3);
    endfunction

endclass

module tb;

    transaction trans;

    initial begin
        trans = new(45, 78, 90);
        #1;
        trans.display();
    end
endmodule