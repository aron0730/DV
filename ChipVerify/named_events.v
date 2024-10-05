module tb;

    event a_event;
    event b_event[5];

    initial begin
        #20 -> a_event;

        #30 -> a_event;

        #50 ->a_event;

        #10 ->b_event[3];
    end

    always @ (a_event) $display ("T = %0t [always] a_event is triggered", $time);

    initial begin
        #25;
        @(a_event) $display("T=%0t [initial] b_event is triggered", $time);

        #10 @(b_event[3]) $display("T=%0t [initial] b_event is triggered", $time);
    end


endmodule