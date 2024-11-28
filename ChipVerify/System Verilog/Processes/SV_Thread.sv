module tb_top;
    initial begin
        #1 $display("[%0t ns] Start fork ...", $time);

        // Main Process: Fork these processes in parallel and wait untill all
        // of them finish
        fork
            // Thread1 : Print this statement after 5ns from start of fork
            #5 $display ("[%0t ns] Thread1: Orange is named after orange", $time);

            // Thread2 : Print these two statements after the given delay from start of fork
            begin
                #2 $display("[%0t ns] Thread2: Apple keeps the doctor away", $time);
                $4 $display("[%0t ns] Thread2: But not anymore", $time);
            end

            // Thread3 : Print this statement after
            #10 $display("[%0t ns] Thread3: Banana is a good fruit", $time);
        join

        // Main Process: Continue with rest of statements once fork-join is over
        $display("[%0t ns] After Fork-Join", $time);

    end
endmodule
/* sim log :
[1 ns] Start fork ...
[3 ns] Thread2: Apple keeps the doctor away
[6 ns] Thread1: Orange is named after orange
[7 ns] Thread2: But not anymore
[11 ns] Thread3: Banana is a good fruit
[11 ns] After Fork-Join */

// fork join_any example
module tb_top;
   initial begin

   	  #1 $display ("[%0t ns] Start fork ...", $time);

   	  // Main Process: Fork these processes in parallel and wait until
      // any one of them finish
      fork
      	 // Thread1 : Print this statement after 5ns from start of fork
         #5 $display ("[%0t ns] Thread1: Orange is named after orange", $time);

         // Thread2 : Print these two statements after the given delay from start of fork
         begin
            #2 $display ("[%0t ns] Thread2: Apple keeps the doctor away", $time);
            #4 $display ("[%0t ns] Thread2: But not anymore", $time);
         end

         // Thread3 : Print this statement after 10ns from start of fork
         #10 $display ("[%0t ns] Thread3: Banana is a good fruit", $time);
      join_any

      // Main Process: Continue with rest of statements once fork-join is exited
      $display ("[%0t ns] After Fork-Join", $time);
   end
endmodule

// fork join_none example
module tb_top;
   initial begin

   	  #1 $display ("[%0t ns] Start fork ...", $time);

   	  // Main Process: Fork these processes in parallel and exits immediately
      fork
      	 // Thread1 : Print this statement after 5ns from start of fork
         #5 $display ("[%0t ns] Thread1: Orange is named after orange", $time);

         // Thread2 : Print these two statements after the given delay from start of fork
         begin
            #2 $display ("[%0t ns] Thread2: Apple keeps the doctor away", $time);
            #4 $display ("[%0t ns] Thread2: But not anymore", $time);
         end

         // Thread3 : Print this statement after 10ns from start of fork
         #10 $display ("[%0t ns] Thread3: Banana is a good fruit", $time);
      join_none

      // Main Process: Continue with rest of statements once fork-join is exited
      $display ("[%0t ns] After Fork-Join", $time);
   end
endmodule
/* sim log :
[1 ns] Start fork ...
[1 ns] After Fork-Join
[3 ns] Thread2: Apple keeps the doctor away
[6 ns] Thread1: Orange is named after orange
[7 ns] Thread2: But not anymore
[11 ns] Thread3: Banana is a good fruit */



// Nested fork join
module tb;

    initial begin
        $display("[%0t] Main Thread: Fork join going to start", $time);
        fork
            fork
                print(20, "Thread1_0");
                print(30, "Thread1_1");
            join
            print(10, "Thread2");
        join
        $display("[%0t] Main Thread: Fork join has finished", $time);
    end 

    // Note that this task has to be automatic
    task automatic print (int _time, string t_name);
        #_time $display("[%0t] %s", $time, t_name);
    endtask
endmodule
/* sim log :
[0] Main Thread: Fork join going to start
[10] Thread2
[20] Thread1_0
[30] Thread1_1
[30] Main Thread: Fork join has finished */

module tb;
    initial begin
        $display("[%0t] Main Thread: Fork join going to start", $time);

        fork
            // Thread 1
            fork
                #50 $display("[%0t] Thread1_0 ...",$time);
                #70 $display("[%0t] Thread1_1 ...",$time);

                begin
                    #10 $display("[%0t] Thread1_2 ...", $time);
                    #100 $display("[%0t] Thread1_2 finished", $time);
                end

            join

            // Thread 2
            begin
                #5 $display("[%0t] Thread2 ...", $time);
                #10 $display("[%0t] Thread2 finished", $time);
            end

            // Thread 3
            #20 $display("[%0t] Thread3 finished", $time);
        join
        $display("[%0t] Main Thread: Fork join has finished", $time);
    end
endmodule
/* sim log :
[0] Main Thread: Fork join going to start
[5] Thread2 ...
[10] Thread1_2 ...
[15] Thread2 finished
[20] Thread3 finished
[50] Thread1_0 ...
[70] Thread1_1 ...
[110] Thread1_2 finished
[110] Main Thread: Fork join has finished */

