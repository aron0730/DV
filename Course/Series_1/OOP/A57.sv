class generator;

    int data = 55;

    function generator copy();
        copy = new();
        copy.data = data;
    endfunction
endclass

module tb;
    generator g1, g2;

    initial begin
        g1 = new();
        g1.data = 77;
        
        g2 = new g1;
        $display("Value of g1.data : %0d", g1.data);
        $display("Value of g2.data : %0d", g2.data);
        
        g2.data = 99;
        $display("Value of g1.data : %0d", g1.data);
        $display("Value of g2.data : %0d", g2.data);
    end
endmodule