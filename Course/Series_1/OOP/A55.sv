class first;

    bit [7:0] a;
    bit [7:0] b;
    bit [7:0] c;

    function new(input bit [7:0] a = 0, input bit [7:0] b = 0, input bit [7:0] c = 0);
        this.a = a;
        this.b = b;
        this.c = c;
    endfunction
endclass

module tb;

    first f1;

    initial begin
        f1 = new (.a(2), .b(4), .c(56));
        $display("f1.a : %0d, f1.b : %0d, f1.c : %0d", f1.a, f1.b, f1.c);
    end
endmodule