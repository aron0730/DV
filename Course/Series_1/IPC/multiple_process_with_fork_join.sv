module tb;

    bit [7:0] data1, data2;
    event done;
    event next;
    
    int i = 0;

    task generator();
        for (i = 0; i < 10; i++) begin
            data1 = $urandom();
            $display("Generator sent Data : %0d", data1);
            #10;
            wait(next.triggered);
        end
        -> done;
    endtask

    task receiver();
        forever begin
            #10;
            data2 = data1;
            $display("Driver Received Data : %0d", data2);
            -> next;
        end
    endtask

    task wait_event();
        wait(done.triggered);
        $display("completed sending all stimulus");
        $finish();
    endtask


    initial begin
        fork
            generator();
            receiver();
            wait_event();
        join
    end

endmodule