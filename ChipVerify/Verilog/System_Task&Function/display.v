// $display(<list_of_arguments>);
// $write(<list_of_arguments>);

// Verilog Syntax
module tb;
    initial begin
        $display ("This ends with a new line ");
        $write ("This does not,");
        $write ("like this. To start new line, use newline char");

        $display("This always start on a new line !");
    end
endmodule

// Verilog Strobes
module tb2;
    initial begin
        reg [7:0] a;
        reg [7:0] b;

        a = 8'h2D;
        b = 8'h2D;

        #10;
        b <= a + 1;

        $display ("[$display] time=%0t a=0x%0h b=0x%0h", $time, a, b);
        $strobe  ("[$strobe] time=%0t a=0x%0h b=0x%0h", $time, a, b);

        #1;
        $display ("[$display] time=%0t a=0x%0h b=0x%0h", $time, a, b);
        $strobe  ("[$strobe] time=%0t a=0x%0h b=0x%0h", $time, a, b);
    end
endmodule

// simulation log
// [$display] time=10 a=0x2d b=0x2d
// [$strobe] time=10 a=0x2d b=0x2e

// [$display] time=10 a=0x2d b=0x2e
// [$strobe] time=10 a=0x2d b=0x2e

// verilog continuous monitors
module tb3;
    initial begin
        reg [7:0] a;
        reg [7:0] b;

        a = 8'h2D;
        b = 8'h2D;

        #10;
        b <= a + 1;

        $monitor ("[$monitor] time=%0t a=0x%0h b=0x%0h", $time, a, b);

        #1  b <= 8'hA4;
        #5  b <= a - 8'h33;
        #10 b <= 8'h1;

    end 
endmodule

// simulation log
// [$monitor] time=10 a=0x2d b=0x2e
// [$monitor] time=11 a=0x2d b=0xa4
// [$monitor] time=16 a=0x2d b=0xfa
// [$monitor] time=26 a=0x2d b=0x1

module tb4;
    initial begin
        
        reg [7:0] a;
        reg [39:0] str = "Hello";
        time cur_time;
        real float_pt;

        a = 8'h0E;
        float_pt = 3.142;

        $display ("a = %h", a);
        $display ("a = %d", a);
        $display ("a = %b", a);

        $display ("str = %s", str);
        #200 cur_time = $time;
        $display ("time = $t", cur_time);
        $display ("float_pt = %f", float_pt);
        $display ("float_pt = %e", float_pt);

    end
endmodule

/*
\n : Newline character
\t : Tab character
\\ : The \ character
\" : The " character
%% : The % character
*/
