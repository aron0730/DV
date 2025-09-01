class generator;
    randc bit[3:0] a, b;  // rand or rnadc
    bit [3:0] y;

    extern constraint data;
    extern function void display();
endclass

constraint generator::data {
    a inside {[0:3]};
    b inside {[12:15]};
};

function void generator::display();
    $display("Value of a : %0d and b : %0d", a, b);
endfunction



module tb;
    generator g;
    int i = 0;
    int status = 0;

    initial begin
        g = new();

        for (i = 0; i < 15; i++) begin
            assert(g.randomize()) else $display("Randomization Failed");
            g.display();
            #10;
        end
    end
endmodule