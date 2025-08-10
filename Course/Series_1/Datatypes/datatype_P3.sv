`timescale 1ns/1ps

module tb;

    time fix_time = 0;
    realtime real_time = 0;

    // $time();     return current simulation time in fixed point format
    // $realtime(); return current simulation time in floating point format

    initial begin
        #12.5;
        fix_time = $time;
        real_time = $realtime;
        $display("Current simulation fix_time  : %0t", fix_time);
        $display("Current simulation real_time : %0t", real_time);
    end

    initial begin
      	#200
        $finish();
    end
endmodule