// 1. Create an event using event
event eventA;  // Creates an event called "eventA"

// 2. Trigger an event using -> operator
->eventA;  // Any process that has access to "eventA" can trigger the event

// 3. Wait for event to happen
@eventA;                    // Use "@" operator to wait for an event
wait (eventA.triggered);    // or use the wait statement with "eventA.triggered"

// 4. Pass events as arguments to functions
module tb_top;
    event eventA;       // Declare an event handle called "eventA"

    initial begin
        fork
            waitForTrigger (eventA);        // Task waits for eventA to happen
            #5 ->eventA;                    // Triggers eventA
        join
    end

    // The event is passed as an argument to this task. It simply waits for the event
    // to be triggered
    task automatic waitForTrigger(event eventA);
        $display("[%0t] Waiting for EventA to be triggered", $time);
        wait(eventA.triggered);
        $display("[%0t] EventA has triggered", $time);
    endtask //automatic
endmodule
/* sim log :
[0] Waiting for EventA to be triggered
[5] EventA has triggered */

// Semaphore
module tb_top;
    semaphore key;      // Create a semaphore handle called "key"

    initial begin
        key = new(1);   // Create only a single key; multiple keys are also possible

        fork
            personA();  // personA tries to get the room and puts it back after work
            personB();  // personB also tries to get the room and puts it back after work
            #25 personA (); 		// personA tries to get the room a second time
        join_none
    end

    task getRoom(bit[1:0] id);
        $display("[%0t] Trying to get a room for id[%0d]..." $time, id);
        key.get(1);
        $display("[%0t] Room Key retrieved for id[%0d]", $time, id);
    endtask

    task putRoom(bit[1:0] id);
        $display("[%0t] Leaving room id[%0d]", $time, id);
        key.put(1);
        $display("[%0t] Room Key put back id[%0d]", $time, id);
    endtask

    // This person tries to get the room immediately and puts
    // it back 20 time units later
    task personA();
        getRoom(1);
        #20 putRoom(1);
    endtask

    // This person tries to get the room after 5 time units and puts it back after
    // 10 time units
    task personB();
        #5 getRoom(2);
        #10 putRoom(2);
    endtask
endmodule

/* sim log :
[0] Trying to get a room for id[1] ...
[0] Room Key retrieved for id[1]
[5] Trying to get a room for id[2] ...
[20] Leaving room id[1] ...
[20] Room Key put back id[1]
[20] Room Key retrieved for id[2]
[25] Trying to get a room for id[1] ...
[30] Leaving room id[2] ...
[30] Room Key put back id[2]
[30] Room Key retrieved for id[1]
[50] Leaving room id[1] ...
[50] Room Key put back id[1] */

// Mailbox
// Data packet in this environment
class transaction;
    rand bit [7:0] data;

    function display();
        $display("[%0t] Data = 0x%0h", $time, data);
    endfunction
endclass

// Generator class - Generate a transaction object and put into mailbox
class generator;
    mailbox mbx;

    function new (mailbox mbx);
        this.mbx = mbx;
    endfunction

    task genData();
        transaction trns = new();
        trns.randomize();
        trns.display();
        $display("[%0t] [Generator] Going to put data packet into mailbox", $time);
        mbx.put(trns);
        $display("[%0t] [Generator] Data put into mailbox", $time);
    endtask
endclass

// Driver class - Get the transaction object from Generator
class driver;
    mailbox mbx;

    function new (mailbox mbx);
        this.mbx = mbx;
    endfunction

    task drvData();
        transaction drvTrns = new();
        $display("[%0t] [Driver] Waiting for available data", $time);
        mbx.get(drvTrns);
        $display("[%0t] [Driver] Data received from Mailbox", $time);
        drvTrns.display();
    endtask
endclass

// Top Level environment that will connect Generator and Driver with a mailbox
module tb_top;
    mailbox mbx;
    generator Gen;
    driver Drv;

    initial begin
        mbx = new();
        Gen = new(mbx);
        Drv = new(mbx);

        fork
            #10 Gen.genData();
            Drv.drvData();
        join_none
    end
endmodule
/* sim log :
[0] [Driver] Waiting for available data
[10] Data = 0x9d
[10] [Generator] Put data packet into mailbox
[10] [Generator] Data put into mailbox
[10] [Driver] Data received from Mailbox
[10] Data = 0x9d */