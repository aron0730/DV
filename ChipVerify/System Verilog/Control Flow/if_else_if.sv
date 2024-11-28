// unique-if, unique0-if
// No else block for unique-if
module tb;
    int x = 4;

    initial begin
        // This if else if construct is declared to be "unique"
        // Error is not reported here because there is a "else"
        // clause in the end which will be triggered when none of
        // the conditions match

        unique if (x == 3)
            $display ("x is %0d", x);
        else if (x == 5)
            $display ("x is %0d", x);
        else
            $display ("x is neither 3 nor 5");

        // When none of the conditions become true and there
        // is no "else" clause, then an error is reported
        unique if (x == 3)
            $display ("x is %0d", x);
        else if (x == 5)
            $display ("x is %0d", x);
    end
endmodule

// Multiple matches in unique-if
module tb;
    int x = 4;

    initial begin
        
        // This if else if construct is declared to be "unique"
        // When multiple if blocks match, then error is reported
        unique if (x == 4)
            $display ("1. x is %0d", x);
        else if (x == 4)
            $display ("2. x is %0d", x);
        else
            $display ("x is not 4");
    end
endmodule

// priority-if
// No else clause in priority-if
module tb;
    int x = 4;

    initial begin
        // This if else if construct is declared to be "unique"
        // Error is not reported here because there is a "else"
        // clause in the end which will be triggered when none of
        // the conditions match
        priority if (x == 3)
            $display("x is %0d", x);
        else if (x == 5)
            $display("x is %0d", x);
        else
            $display("x is neither 3 nor 5");

        // When none of the conditions become true and there
        // is no "else clause", then an error is reported
        priority if (x == 3)
            $display("x is %0d", x);
        else if (x == 5)
            $display("x is %0d", x);
    end
endmodule

// Exit after first match in priority-if
module tb;
    int x = 4;
    initial begin
        // Exits if-else block once the first match is found
        priority if (x == 4)
            $display("x is %0d", x);
        else if (x != 5)
            $display("x is %0d", x);
    end
endmodule