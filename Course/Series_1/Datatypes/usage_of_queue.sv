class transaction;

    rand bit [7:0] din;
    randc bit [7:0] addr;
    bit wr;
    bit [7:0] dout;

    constraint addr_c {addr > 10; 
                       addr < 18;};
endclass

class generator;
    transaction t;
    integer i;


    task run();
        repeat(count) begin
            trans = new();
            assert(trans.randomize()) else ("Randomization Failed");
        end
    endtask
endclass


class scoreboard;

    bit [7:0] rdata;
    bit [7:0] queue[$];
    transaction t;
    task run();
        if(t.wr == 1'b1) begin
            queue.push_front(tr.wdata);
        end else if begin
            if(tr.rdata = queue.pop_back())
                $display("Data Mismatch at %0t", $time);
        end
    endtask
endclass
