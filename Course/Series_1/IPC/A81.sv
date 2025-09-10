module tb;
    event done;
    int cnt1 = 0, cnt2 = 0;

    task first();
        forever begin
            $display("[%0t] Task 1 Trigger", $time);
            cnt1++;
            #20;
        end   
    endtask

    task second();
        forever begin
            $display("[%0t] Task 2 Trigger", $time);
            cnt2++;
            #40;
        end
    endtask

    task print_cnt();
        #200;
        $display("[%0t]Task 1 time : %0d, Task 2 time : %0d", $time, cnt1, cnt2);
        #1;
        -> done;
    endtask

    initial begin
        fork
            first();
            second();
            print_cnt();
        join_any
        wait(done.triggered);
        $finish();
    end
 
endmodule