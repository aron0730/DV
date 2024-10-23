module tb
    // Module instantiation override
    design_ip #(BUS_WIDTH = 64, DATA_WIDTH = 128) d0 ([port list]);

    // Use of defparam to overrise
    defparam FIFO_DEPTH = 128;

endmodule


module design_ip (addr, wdata, write, sel, rdata);

    parameter BUS_WIDTH = 32, DATA_WIDTH = 64, FIFO_DEPTH = 512;

    input addr;
    input wdata;
    input write;
    input sel;
    output rdata;

    wire [BUS_WIDTH - 1 : 0] addr;
    wire [DATA_WIDTH - 1 : 0] wdata;
    wire [DATA_WIDTH - 1 : 0] rdata;

    reg [7:0] fifo [FIFO_DEPTH];

    // Design code goes here ...
endmodule


// New ANSI style of Verilog port declaration
module design_ip #(parameter BUS_WIDTH = 32, parameter DATA_WIDTH = 64, parameter FIFO_DEPTH = 512;) 
(
    input [BUS_WIDTH - 1 : 0] addr, 
    input [DATA_WIDTH - 1 : 0] wdata, 
    input write, 
    input sel, 
    output [DATA_WIDTH - 1: 0] rdata
);

    reg [7:0] fifo [FIFO_DEPTH];

    // Design code goes here ...
endmodule

