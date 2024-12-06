// Generic Mailbox Example
module tb;
    // Create a new mailbox that can hold utmost 2 items
    mailbox mbx = new(2);

    // Block1: This block keeps putting items into the mailbox
    // The rate of items being put into the mailbox is 1 every ns
    initial begin
        for (int i = 0; i < 5; i++) begin
            #1 mbx.put(i);
            $display("[%0t] Thread0: Put item #%0d, size=%0d", $time, i, mbx.num());
        end
    end

    // Block2: This block keeps getting items from the mailbox
    // The rate of items received from the mailbox is 2 every ns
    initial begin
        forever begin
            int idx;
            #2 mbx.get(idx);
            $display("[%0t] Thread1: Got item #%0d, size=%0d", $time, idx, mbx.num());
        end
    end
endmodule
/* sim log :
[1] Thread0: Put item #0, size=1
[2] Thread1:   Got item #0, size=0
[2] Thread0: Put item #1, size=1
[3] Thread0: Put item #2, size=2
[4] Thread1:   Got item #1, size=1
[4] Thread0: Put item #3, size=2
[6] Thread1:   Got item #2, size=2
[6] Thread0: Put item #4, size=2
[8] Thread1:   Got item #3, size=1
[10] Thread1:   Got item #4, size=0 */

// Example

// Create alias for parameterized "string" type mailbox
typedef mailbox #(string) s_mbox;

// Define a component to send messages
class comp1;

    // Create a mailbox handle to put items
    s_mbox names;

    // Define a task to put items into the mailbox
    task send();
        for (int i = 0; i < 3; i++) begin
            string s = $sformatf ("name_%0d", i);
            #1 $display("[%0t] Comp1: Put %s", $time, s);
            names.put(s);
        end
    endtask
endclass //comp1

// Define a second component to receive messages
class comp2;

    // Create a mailbox handle to receive items
    s_mbox list;

    // Create a loop that conitnuously gets an item from
    // the mailbox
    task receive();
        forever begin
            string s;
            list.get(s);
            $display("[%0t] Comp2: Got %s", $time, s);
        end
    endtask
endclass

// Connect both mailbox handles at a higher level
module tb;
    
    // Declare a global mailbox and create both components
    s_mbox m_mbx = new();
    comp1  m_comp1 = new();
    comp2  m_comp2 = new();

    initial begin
        // Assign both mailbox handles in components with the
        // global mailbox
        m_comp1.names = m_mbx;
        m_comp2.list = m_mbx;

        // Start both components, where comp1 keeps sending
        // and comp2 keeps receiving
        fork
            m_comp1.send();
            m_comp2.receive();
        join

    end
endmodule
/* sim log :
[1] Comp1: Put name_0
[1]    Comp2: Got name_0
[2] Comp1: Put name_1
[2]    Comp2: Got name_1
[3] Comp1: Put name_2
[3]    Comp2: Got name_2 */
