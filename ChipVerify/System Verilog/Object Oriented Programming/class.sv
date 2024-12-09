class myPacket;
    bit [2:0]   header;
    bit         encode;
    bit [2:0]   mode;
    bit [7:0]   data;
    bit         stop;

    function new (bit [2:0] header = 3'h1, bit [2:0] mode = 5);
        this.header = header;
        this.encode = 0;
        this.mode   = mode;
        this.stop   = 1;
    endfunction

    function display();
        $display ("Header = 0x%0h, Encode = %0b, Mode = 0x%0h, Stop = %0b", 
                   this.header, this.dncode, this.mode, this.stop);
    endfunction
endclass

// How can I access signals within a class?

module tb_top;
    myPacket pkt0, pkt1;

    initial begin
        pkt0 = new(3'h2, 2'h3);
        pkt0.display();

        pkt1 = new();
        pkt1.display();
    end
endmodule
/* sim log :
Header = 0x2, Encode = 0, Mode = 0x3, Stop = 1
Header = 0x1, Encode = 0, Mode = 0x5, Stop = 1 */

// How do I create an array of classes?
module tb_top;
    myPacket pkt0[3];

    initial begin
        for(int i = 0; i < $size(pkt0); i++) begin
            pkt0[i] = new();
            pkt0[i].display();
        end
    end
endmodule
/* sim log :
Header = 0x1, Encode = 0, Mode = 0x5, Stop = 1
Header = 0x1, Encode = 0, Mode = 0x5, Stop = 1
Header = 0x1, Encode = 0, Mode = 0x5, Stop = 1 */

// What is inheritance?
class networkPkt extends myPacket;
    bit       parity;
    bit [1:0] crc;

    function new();
        super.new();
        this.parity = 1;
        this.crc = 3;
    endfunction

    function display();
        super.display();
        $display ("Parity = %0b, CRC = 0x%0h", this.parity, this.crc);
    endfunction

endclass