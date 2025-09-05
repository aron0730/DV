class first;
    rand bit wr;  // :=
    rand bit rd;  // :/

    constraint cntrl {
        wr dist {0 := 30 , 1 := 70};
        rd dist {0 :/ 30 , 1 :/ 70};
    }

endclass

module tb;
    first f;

    initial begin
        f = new();

        for(int i = 0; i < 10; i++) begin
            f.randomize();
            $display("Value of wr : %0d and rd : %0d", f.wr, f.rd);
        end
    end
endmodule

//********************************************

class first;
    rand bit wr;  // :=
    rand bit rd;  // :/

    rand bit [1:0] var1;
    rand bit [1:0] var2;

    constraint data {
        var1 dist {0 := 30 , [1:3] := 90};  // p(0) = 30/300, p(1) = 90/300, p(2) = 90/300, p(3) = 90/300
        var2 dist {0 :/ 30 , [1:3] :/ 90};  // p(0) = 30/120, p(1) = 30/120, p(2) = 30/120, p(3) = 30/120
    }

    constraint cntrl {
        wr dist {0 := 30 , 1 := 70};
        rd dist {0 :/ 30 , 1 :/ 70};
    }

endclass

module tb;
    first f;

    initial begin
        f = new();

        for(int i = 0; i < 10; i++) begin
            f.randomize();
            $display("Value of wr : %0d and rd : %0d", f.wr, f.rd);
        end

        for(int i = 0; i < 10; i++) begin
            f.randomize();
            $display("Value of var1(:=) : %0d and var2(:/) : %0d", f.var1, f.var2);
        end
    end
endmodule