module tb;
    A a();
    function display();
        $display("Hello, this is TB");
    endfunction
endmodule


module A;
    B b();
    function display();
        $display("Hello, this is A");
    endfunction
endmodule

module B;
    C c();
    function display();
        $display("Hello, this is B");
    endfunction
endmodule

module C;
    D d();
    function display();
        $display("Hello, this is C");
    endfunction
endmodule

module D;
    initial begin
        a.display();
        b.display();
        c.display();

        a.b.c.display();
    end
endmodule