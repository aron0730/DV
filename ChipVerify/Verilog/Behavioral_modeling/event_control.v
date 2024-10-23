module tb;
    reg a, b;

    initial begin
        a <= 0;

        #10 a <= 1;
        #10 b <= 1;
        
        #10 a <= 0;
        #15 a <= 1;
    end

    initial begin
        @(posedge a);
        $display ("T = %0t Posedge of a detected for 0->1", $time);
        @(negedge b);
        $display ("T = %0t Posedge of b detected for 0->1", $time);
    end

    initial begin
        @(posedge (a + b)) $display ("T = %0t Posedge of a + b", $time);

        @(a) $display ("T = %0t Change in a found", $time);
    end


endmodule