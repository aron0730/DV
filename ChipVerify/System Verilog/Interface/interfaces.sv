interface apb_if (intput pclk);
    logic [31:0] paddr;
    logic [31:0] pwdata;
    logic [31:0] prdata;
    logic        penable;
    logic        pwrite;
    logic        psel;
endinterface //apb_if (intput pclk)

interface myBus (input clk);
    logic [7:0] data;
    logic       enable;

    // From TestBench perspective, 'data' is input and 'write' is output
    modport TB (intput data, clk, output enable);

    // From DUT perspective, 'data' is output and 'enable' is input
    modport DUT (output data, input enable, clk);
endinterface //myBus (input clk)

// How to connect an interface with DUT ?
module dut (myBus busIf);
    always @ (posedge busIf.clk)
        if (busIf.enable)
            busIf.data <= busIf.data + 1;
        else
            busIf.data <= 0;
endmodule

// Filename : tb_top.sv
module tb_top;
    bit clk;

    // Create a clock
    always #10 clk = ~clk;

    // Create an interface object
    myBus busIf(clk);

    // Instantiate the DUT; pass modport DUT of busIf
    dut dut0 (busIf.DUT);

    // Testbench code : let's wiggle enable
    initial begin
        busIf.enable <= 0;
        #10 busIf.enable <= 1;
        #40 busIf.enable <= 0;
        #20 busIf.enable <= 1;
        #100 $finish;
    end
endmodule

// What are the advantages?
// Before interface
dut dut0 (.data(data), .enable(enable), ...);

// With interface - higher level of abstraction possible
dut dut0 (busIf.DUT);

// How to parameterize an interface ?
interface myBus #(parameter D_WIDTH = 31) (input clk);
    logic [D_WIDTH-1 : 0] data;
    logic                 enable;
endinterface

interface my_int (input bit clk);
    // Rest of interface code

    clocking cb_clk @ (posedge clk);
        default input #3ns output @2ns;
        input enable;
        output data;
    endclocking
endinterface

// How to use a clocking block ?
// To wait for posedge of clock
@busIf.cb_clk;

// To use clocking block signals
busIf.cb_clk.enable = 1;