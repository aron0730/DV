class Packet;
    bit [15:0]  addr;
    bit [7:0]   data;

    function new (bit [15:0] ad, bit [7:0] d);
        addr = ad;
        data = d;
        $display("addr=0x%0h data=0x%0h", addr, data);
    endfunction
endclass

module tb;
    initial begin
        Packet p1, p2, p3;
        p1 = new(16'hdead, 8'h12);
        p2 = new(16'hface, 8'hab);
        p3 = new(16'hcafe, 8'hfc);
    end
endmodule
/* sim log : 
addr=0xdead data=0x12
addr=0xface data=0xab
addr=0xcafe data=0xfc */


class Packet;
    bit [15:0]  addr;
    bit [7:0]   data;

    static int static_ctr = 0;
    int ctr = 0;

    function new (bit [15:0] ad, bit [7:0] d);
        addr = ad;
        data = d;
        static_ctr++;
        ctr++;
        $display("static_ctr=%0d ctr=%0d addr=0x%0h data=0x%0h", static_ctr, ctr, addr, data);
    endfunction
endclass

module tb;
    initial begin
        Packet p1, p2, p3;
        p1 = new(16'hdead, 8'h12);
        p2 = new(16'hface, 8'hab);
        p3 = new(16'hcafe, 8'hfc);
    end
endmodule
/* sim log :
static_ctr=1 ctr=1 addr=0xdead data=0x12
static_ctr=2 ctr=1 addr=0xface data=0xab
static_ctr=3 ctr=1 addr=0xcafe data=0xfc */

/*
什麼是靜態函數？
靜態函數（static function）是一種不依賴於類的物件實例即可被調用的方法。其特點包括：

1. 不需要實例化類即可調用。
2. 只能訪問類的靜態成員，無法訪問非靜態成員（即物件專屬成員）。
3. 不能聲明為 virtual，因為靜態函數與物件無關，不適用於多態。
靜態函數通常用於需要針對整個類（而非某個物件）的操作。*/

class Packet;
    static int ctr = 0;

    function new();
        ctr++;
    endfunction

    static function get_pkt_ctr();
        $display("ctr=%0d", ctr);
    endfunction
endclass

module tb;
    Packet pkt[6];

    initial begin
        for (int i = 0; i < $size(pkt); i++) begin
            pkt[i] = new;
        end
        Packet::get_pkt_ctr();      // Static call using :: operator
        pkt[5].get_pkt_ctr();       // Normal call using instance
    end
endmodule
/* sim log :
ctr=6
ctr=6 */


class Packet;
    static int ctr = 0;
    bit [1:0] mode;

    function new();
        ctr++;
    endfunction

    static function get_pkt_ctr();
        $display("ctr=%0d mode=%0d", ctr, mode);  // ERROR! A static class method cannot access non static class members.
    endfunction
endclass