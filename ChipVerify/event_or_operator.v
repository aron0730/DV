module tb;

    reg a, b;

    initial begin
        $monitor ("T=%0t a=%0d, b=%0d", $time, a, b);
    end

endmodule