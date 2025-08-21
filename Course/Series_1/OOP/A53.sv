`timescale 1ns/1ps
module tb;
    bit wr = 0;
    bit en = 0;
    bit [5:0] addr = 0;
    bit clk = 0;

    always #20 clk = ~clk;

    task automatic stim_addr();
        @(posedge clk);
        en <= 1'b1;
        wr <= $urandom_range(0, 1);
        addr <= $urandom_range(0, 63);
        $strobe("[%0t] en : %0b, wr : %0b, addr : 0x%0h", $time, en, wr, addr);
		
    endtask

    initial begin
        repeat (10) stim_addr();
        #20 $finish();
    end
endmodule