
// pre-randomize
// post-randomize
class generator;
    randc bit[3:0] a, b;  // rand or rnadc
    bit [3:0] y;
    int min;
    int max;

    function void pre_randomize(input int min, input int max);
        this.min = min;
        this.max = max;
    endfunction

    constraint data {
        a inside {[min:max]};
        b inside {[min:max]};
    }

    function void post_randomize();
        $display("Value of a : %0d and b : %0d", a, b);
    endfunction

endclass

module tb;
    generator g;
    int i = 0;
    int status = 0;

    initial begin
        g = new();

        for (i = 0; i < 15; i++) begin
            g.pre_randomize(3:8);
            g.randomize();
            g.post_randomize();
            #10;
        end

    end
endmodule