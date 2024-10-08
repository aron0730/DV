module tb
    initial display();

    initial begin
        #50 disable display.T_DISPLAY;
    end
endmodule


task display();
    begin : T_DISPLAY
        $display("[%0t] T_Task started", $time);
        #100;
        $display("[%0t] T_task ended", $time);
    end

    begin : S_DISPLAY
        #10;
        $display("[%0t] S_Task started", $time);
        #20;
        $display("[%0t S_Task ended]", $time);
    end
endtask

/*
simulation log:

[0] T_Task started
[60] S_Task started
[80] S_Task ended

*/