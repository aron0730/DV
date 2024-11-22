// unique : No items match for given expression
module tb;
    bit [1:0] abc;

    initial begin
        abc = 1;

        // None of the case items match the value in "abc"
        // A violation is reported here
        unique case (abc)
            0 : $display("Found to be 0");
            2 : $display("Found to be 2");
        endcase
    end
endmodule

// unique : More than one case item matches
module tb;
    bit [1:0] abc;

    initial begin
        abc = 0;

        // Multiple case items match the value in "abc"
        // A violation is reported here
        unique case (abc)
            0 : $display("Found to be 0");
            0 : $display("Again found to be 0");
            2 : $display("Found to be 2");
        endcase
    end
endmodule

// priority case
module tb;
    bit [1:0] 	abc;

    initial begin
        abc = 0;

        // First match is executed
        priority case (abc)
            0 : $display ("Found to be 0");
            0 : $display ("Again found to be 0");
            2 : $display ("Found to be 2");
        endcase
    end
endmodule
