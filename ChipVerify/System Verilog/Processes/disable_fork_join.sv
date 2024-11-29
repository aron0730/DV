module tb_top;
    initial begin
        // Fork off 3 sub-threads in parallel and the currently executing main thread
        // will finish when any of the 3 sub-threads have finished.
        fork
            
            // Thread1 : Will finish first at time 40ns
            #40 $display("[%0t ns] Show #40 $display statement", $time);

            // Thread2 : Will finish at time 70ns
            begin
                #20 $display("[%0t ns] Shot #20 $display statement", $time);
                #50 $display("[%0t ns] Shot #50 $display statement", $time);
            end

            // Thread3 : Will finish at time 60ns
            #60 $display("[%0t ns] TIMEOUT", $time);
        join_any

        // Display as soon as the fork is done
        $display("[%0t ns] Fork join is done", $time);
    end
endmodule
/* sim log :
[20 ns] Show #20 $display statement
[40 ns] Show #40 $display statement
[40ns] Fork join is done
[60 ns] TIMEOUT
[70 ns] Show #50 $display statement */


module tb_top;
    initial begin
        // Fork off 3 sub-threads in parallel and the currently executing main thread
        // will finish when any of the 3 sub-threads have finished.
        fork
            
            // Thread1 : Will finish first at time 40ns
            #40 $display("[%0t ns] Show #40 $display statement", $time);

            // Thread2 : Will finish at time 70ns
            begin
                #20 $display("[%0t ns] Shot #20 $display statement", $time);
                #50 $display("[%0t ns] Shot #50 $display statement", $time);
            end

            // Thread3 : Will finish at time 60ns
            #60 $display("[%0t ns] TIMEOUT", $time);
        join_any

        // Display as soon as the fork is done
        $display("[%0t ns] Fork join is done", $time);

        disable fork;
    end
endmodule
/* sim log :
[20 ns] Show #20 $display statement
[40 ns] Show #40 $display statement
[40ns] Fork join is done, let's disable fork */

