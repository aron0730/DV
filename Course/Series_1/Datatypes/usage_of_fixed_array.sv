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
        t = new();
        t.randomize();
    endtask
endclass


class scoreboard;

    bit [7:0] tarr[256] = '{default:0};
    transaction t;
    task run();
        if(t.wr == 1'b1) begin
            tarr[t.addr] = din;
            $display("[SCB] : Data stored din : %0d addr : %0d", t.din, t.addr);
        end

        if(t.wr == 1'b0) begin
            if(t.dout == 0)
                $display("[SCB] : No Data Written at this Location Test Passed") ;
            else if (t.dout == tarr[t.addr])
                $display("[SCB] : Valid Data found Test Passed");
            else
                $display("[SCB] : Test Failed");
        end
    endtask
endclass
