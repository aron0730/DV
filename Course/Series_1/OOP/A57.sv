class generator;
  
    bit [3:0] a = 5,b =7;
    bit wr = 1;
    bit en = 1;
    bit [4:0] s = 12;
    
    function void display();
        $display("a:%0d b:%0d wr:%0b en:%0b s:%0d", a,b,wr,en,s);
    endfunction 

    function generator copy();
        copy = new();
        copy.a = a;
        copy.b = b;
        copy.wr = wr;
        copy.en = en;
        copy.s = s;
    endfunction
endclass

module tb;
    generator g1, g2;

    initial begin
        g1 = new();
        g2 = new();
        g2 = g1.copy();

        g2.a = 12;
        g2.b = 15;
        g2.wr = 0;
        g2.en = 0;    
        g2.s = 15;
        $display("Value of g1 : %p", g1);
        $display("Value of g2 : %p", g2);
    end
endmodule