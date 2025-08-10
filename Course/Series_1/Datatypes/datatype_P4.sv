`timescale 1ns/1ps

module top(
    input a, b, sel,   // sel = 0 -> y = a, sel = 1 -> y = b
    output y
    );

    reg temp;

    always @(*) begin
        if (sel == 1'b0)
            temp = a;
        else
            temp = b;
    end

    assign y = temp;

endmodule