module tb;

    bit a = 0;
    byte b = 0;  // 2-state -> 0, 4-state -> x
    shortint c = 0;
    int d = 0;
    longint e = 0;

    bit [7:0] f = 8'b0000_0000;
    bit [15:0] g = 16'h00;

    real h = 0;

    initial begin
        a = 1'b0;
    end
endmodule