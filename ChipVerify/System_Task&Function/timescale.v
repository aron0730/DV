/* Standard timescale scope*/

module tb;
    initial begin
        // Print timescale of this module
        $printtimescale(tb);
        // $printtimescale($root);
    end
endmodule

`timescale 1ns/1ps

module tb;
    des m_des();
    alu m_alu();

    initial begin
        $printtimescale(tb);
        // log : Time scale of (tb) is 1ns/ 1ps

        $printtimescale(tb.m_des);
        // log : Time scale of (tb.m_des) is 1ns/ 1ps

        $printtimescale(tb.m_alu);
        // log : Time scale of (tb.m_alu) is 1ns/ 10ps
    end
endmodule


module alu;
    //.....
endmodule


`timescale 1ns/10ps

module des;
    //.....
endmodule


/* Scope between Verilog files */

