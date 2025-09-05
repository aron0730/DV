//* Trigger : ->
//* edge sensitive_blocking @(), level_sensitive_non-blocking wait()

module tb;
    event a1, a2;

    initial begin
        -> a1;
        -> a2;
    end

    initial begin
        @(a1);  //* Lost the event trigger
        $display("Event A1 Trigger");
        @(a2);
        $display("Event A2 Trigger");
    end
endmodule

//*******************************************

module tb;
    event a1, a2;

    initial begin
        -> a1;
        #10;
        -> a2;
    end

    initial begin
        wait(a1.triggered);
        $display("Event A1 Trigger");
        @(a2);
        $display("Event A2 Trigger");
    end
endmodule

//*******************************************

module tb;
    event a1, a2;

    initial begin
        -> a1;
        -> a2;
    end

    initial begin
        wait(a1.triggered);
        $display("Event A1 Trigger");
        wait(a2.triggered);
        $display("Event A2 Trigger");
    end
endmodule