module tb;

    //* default direction : input

    task add (input bit[3:0] a, input bit[3:0] b, output bit [4:0] y);
        y = a + b;
    endtask

    bit [3:0] a, b;
    bit [4:0] y;

    initial begin
        a = 7;
        b = 7;
        add(a, b, y);
        $display("Value of y : %0d", y);
    end

endmodule

//*******************************************************************************
module tb;

    bit [3:0] a, b;
    bit [4:0] y;

    task add ();
        y = a + b;
    endtask

    initial begin
        a = 7;
        b = 7;
        add();
        $display("Value of y : %0d", y);
    end

endmodule

//******************************************************************

module tb;

    bit [3:0] a, b;
    bit [4:0] y;

    task add();
        y = a + b;
        $display("a : %0d and b : %0d and y : %0d", a, b, y);
    endtask

    task stim_a_b();
        a = 1;
        b = 3;
        add();
        #10;
        a = 5;
        a = 6;
        add();
        #10;
        a = 7;
        b = 8;
        add();
        #10;
    endtask

    initial begin
        stim_a_b();
    end

endmodule

/* log:
a : 1 and b : 3 and y : 4
a : 6 and b : 3 and y : 9
a : 7 and b : 8 and y : 15 */


//************************************************************************
module tb;

    bit [3:0] a, b;
    bit [4:0] y;

    bit clk = 0;
    always #10 clk = ~clk;  // 20ns --> 50MHz

    task add();
        y = a + b;
        $display("a : %0d and b : %0d and y : %0d", a, b, y);
    endtask

    task stim_clk();
        @(posedge clk);  // wait
        a = $urandom();
        b = $urandom();
        add();
    endtask

    initial begin
        #110;
        $finish();
    end

    initial begin

        forever begin
            stim_clk();
        end
    end

endmodule