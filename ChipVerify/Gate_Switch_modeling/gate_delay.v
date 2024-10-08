module des (input a, b, 
            output out1, out2);

    // AND gate has 2 time unit gate delay
    and #(2) o1 (out1, a, b);

    // BUFIF0 gate has 3 time unit gate delay
    bufif0 #(3) b1 (out2, a, b);
endmodule

// Two Delay Format
module des1 (input a, b, 
             output out1, out2);

    and #(2, 3) o1 (out1, a, b);
    bufif0 #(4, 5) b1 (out2, a, b);

endmodule

// Three Delay Format
module des2 (input a, b, 
             output out1, out2);
    // and #(<rise>, <fall>)
    and #(2, 3) o1 (out1, a, b);
    bufif0 #(5, 6 ,7) b1 (out2, a, b);

endmodule

// Min/Typical/Max delays
module des3 (input a, b, 
             output out1, out2);
    
    and #(2:3:4, 3:4:5) o1 (out1, a, b);
    bufif0 #(5:6:7, 6:7:8, 7:8:9) b1 (out2, a, b);
endmodule

module tb;
    reg a, b;
    wire out1, out2;

    des d0 (.a(a), .b(b), .out1(out1), .out2(out2));

    initial begin
        {a, b} <= 0;

        $monitor("[T=%0t] a=%0b b=%0b and=%0b bufif0=%0b", $time, a, b, out1, out2);

        #10 a <= 1;
        #10 b <= 1;
        #10 a <= 0;
        #10 b <= 0;
    end
endmodule

// Example :
// Single delay specified - used for all three types of transition delays
or #(<delay>) o1 (out, a, b);

// Two delays specified - used for Rise and Fall transitions
or #(<rise>, <fall>) o1 (out, a, b);

// Three delays specified - used for Rise, Fall and Turn-off transitions
or #(<rise>, <fall>, <turn_off>) o1 (out, a, b);