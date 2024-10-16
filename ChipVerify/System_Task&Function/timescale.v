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

// main.v
`timescale  1ns/1ps

module tb;
    des m_des();
    alu m_alu();

    initial begin
        $printtimescale(tb);
        // log : Time scale of (tb) is 1ns / 1ps

        $printtimescale(tb.m_des);
        // log : Time scale of (tb.m_alu) is 1ns / 1ps

        $printtimescale(tb.m_alu);
        // log : Time scale of (tb.m_des) is 1ns / 10ps

    end
endmodule


// in file_alu.v
module alu;
    // ...
endmodule


// in file_des.v
`timescale 1ns/10ps

module des;
    // ...
endmodule

/*
main.v 的 timescale 1ns/1ps：
在 main.v 文件中，最開始的 timescale 1ns/1ps 設置了默認的時間單位為 1ns，精度為 1ps。這個 timescale 會應用於隨後定義的所有模組，直到碰到新的 timescale 指令。
include 指令的影響：
include 指令會將 file_alu.v 和 file_des.v 的內容直接引入到 main.v 中。在編譯時，這相當於把 file_alu.v 和 file_des.v 的代碼插入到相應的位置。
因此，alu 模組繼承了 main.v 中的 timescale 1ns/1ps，因為在它之前沒有新的 timescale 覆蓋它。
des 模組因為 file_des.v 中有一個新的 timescale 1ns/10ps 指令，所以它使用的是 1ns/10ps 的時間單位和精度。

總結
timescale 指令的作用範圍是從它所在的地方開始，直到遇到下一個 timescale 指令或文件結束。
include 指令 只是將其他文件的內容插入到主文件的對應位置，因此，timescale 的範圍和行為完全依賴於它們的相對位置。
在這個例子中，因為 file_des.v 中有新的 timescale 指令，所以 des 模組使用新的時間單位和精度，而 alu 繼承了主文件的設置。
*/