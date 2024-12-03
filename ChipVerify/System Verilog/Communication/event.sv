event over;                 // a new event is created called over
event over_again = over;    // over_again becomes an alias to over
event empty = null;         // event variable with no synchronization object

/*
Named events can be triggered using -> or ->> operator
Processes can wait for an event using @ operator or .triggered
*/

// example
module tb;

    // Create an event variable that processes can use to trigger and wait
    event event_a;

    // Thread1: Triggers the event using "->" operator
    initial begin
        #20 ->event_a;
        $display("[%0t] Thread1: triggered event_a", $time);
    end

    // Thread2: Waits for the event using "@" operator
    initial begin
        $display("[%0t] Thread2: waiting for trigger", $time);
        @(event_a);
        $display("[%0t] Thread2: received event_a trigger", $time);
    end

    // Thread3: Waits for the event using ".triggered"
    initial begin
        $display("[%0t] Thread3: waiting for trigger", $time);
        wait(event_a.triggered);
        $display("[%0t] Thread3: received event_a trigger", $time);
    end

endmodule
/* sim log :
[0] Thread2: waiting for trigger 
[0] Thread3: waiting for trigger 
[20] Thread1: triggered event_a
[20] Thread2: received event_a trigger 
[20] Thread3: received event_a trigger */

module tb;
    // Create an event variable that processes can use to trigger and wait
    event event_a;

    // Thread1: Triggers the event using "->" operator at 20ns
    initial begin
        #20 ->event_a;
        $display ("[%0t] Thread1: triggered event_a", $time);
    end

    // Thread2: Starts waiting for the event using "@" operator at 20ns
    initial begin
        $display ("[%0t] Thread2: waiting for trigger ", $time);
        #20 @(event_a);
        $display ("[%0t] Thread2: received event_a trigger ", $time);
    end

    // Thread3: Starts waiting for the event using ".triggered" at 20ns
    initial begin
        $display ("[%0t] Thread3: waiting for trigger ", $time);
        #20 wait(event_a.triggered);
        $display ("[%0t] Thread3: received event_a trigger", $time);
    end    
endmodule
/* sim log :
[0] Thread2: waiting for trigger 
[0] Thread3: waiting for trigger 
[20] Thread1: triggered event_a
[20] Thread3: received event_a trigger */

// wait_order
module tb;
    
    // Declare three events that can be triggered separately
    event a, b, c;

    // This block triggers each event one by one
    initial begin
        #10 -> a;
        #10 -> b;
        #10 -> c;
    end

    // This block waits until each event is triggered in the given order
    initial begin
        wait_order (a, b, c)
            $display("Event were executed in the correct order");
        else
            $display("Event were NOT executed in the correct order !");
    end
endmodule
/* sim log :
Events were executed in the correct order */


// Merging Evnets
module tb;
    // Create event variables
    event event_a, event_b;

    initial begin
        fork
            // Thread1 : waits for event_a to be triggered
            begin
                wait(event_a.triggered);
                $display("[%0t] Thread1 : Wait for event_a is over", $time);
            end

            // Thread2 : waits for event_b to be triggered
            begin
                wait(event_b.triggered);
                $display("[%0t] Thread2 : Wait for event_b is over", $time);
            end

            // Thread3 : triggers event_a at 20ns
            #20 ->event_a;

            // Thread4 : triggers event_b at 30ns
            #30 ->event_b;

            // Thread5 : Assigns event_b to event_a at 10ns
            begin
                // Comment code below and try again to see Thread2 finish later
                #10 event_b = event_a;
            end
        join
    end
endmodule
/* sim log :
[20] Thread1: Wait for event_a is over
[20] Thread2: Wait for event_b is over */
