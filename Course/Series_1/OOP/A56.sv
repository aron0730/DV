class first;
    bit [3:0] a;
    bit [3:0] b;
    bit [3:0] c;

    bit [4:0] sum;

    function new(input bit [3:0] a = 0, input bit [3:0] b = 0, input bit [3:0] c = 0);
        this.a = a;
        this.b = b;
        this.c = c;
    endfunction

    task add ();
        sum = a + b + c;
    endtask

    task display_sum();
        $display("Value of Sum : %0d", sum);
    endtask
endclass

module tb;

    first f1;

    initial begin
        f1 = new(.a(1), .b(2), .c(4));
        f1.add();
        f1.display_sum();
    end
endmodule

//**********************************************************************

class first;
    bit [3:0] a;
    bit [3:0] b;
    bit [3:0] c;

    bit [4:0] sum;

    function new(input bit [3:0] a = 0, input bit [3:0] b = 0, input bit [3:0] c = 0);
        this.a = a;
        this.b = b;
        this.c = c;
    endfunction

    task get_sum(input bit [3:0] a = 0, input bit [3:0] b = 0, input bit [3:0] c = 0);
        this.a = a;
        this.b = b;
        this.c = c;
        sum = a + b + c;
        $display("input a : %0d, b : %0d, c : %0d, a + b + c = %0d", a, b, c, sum);
    endtask

endclass

module tb;

    first f1;

    initial begin
        f1 = new();
        f1.get_sum(.a(1), .b(2), .c(4));
    end
endmodule

//**********************************************************************

class first;
    bit [3:0] a;
    bit [3:0] b;
    bit [3:0] c;

    bit [4:0] sum;

    function new(bit [3:0] a = 0, bit [3:0] b = 0, bit [3:0] c = 0);
        this.a = a;
        this.b = b;
        this.c = c;
    endfunction

    function void set_data(bit [3:0] a, bit [3:0] b, bit [3:0] c);
        this.a = a;
        this.b = b;
        this.c = c;
    endfunction

    task get_sum(output bit [4:0] sum);
        sum = a + b + c;
        $display("input a : %0d, b : %0d, c : %0d, a + b + c = %0d", a, b, c, sum);
    endtask

endclass

module tb;

    first f1;

    initial begin
        f1 = new();
        f1.set_data(.a(1), .b(2), .c(4));
        f1.get_sum();
    end
endmodule