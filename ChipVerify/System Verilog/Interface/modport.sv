modport

// Syntax
modprot [identifier] (
    input [port_list];
    output [port_list];
)

interface myInterface;
    logic ack;
    logic gnt;
    logic sel;
    logic irq0;

    // ack and sel are inputs to the dut0, while gnt and irq0 are outputs
    modport dut0 (
        input ack, sel,
        output gnt, irq0
    );

    // ack and sel are outputs from dut1, while gnt and irq0 are inputs
    modport dut1 (
        input gnt, irq0,
        output ack, sel
    );
endinterface

// Example of named port bundle
module dut0 (myInterface.dut0 _if);
    // ....
endmodule

module dut1 (myInterface.dut1 _if);
    // ....
endmodule

module tb;
    myInterface _if;
    dut0 d0 (.*);
    dut1 d1 (.*);
endmodule

// Example of connecting port bundle
module dut0 (myInterface _if);
    // ....
endmodule

module dut1 (myInterface1 _if);
    // ....
endmodule

module tb;
    myInterface _if;
    dut0 d0 (._if (_if.dut0));
    dut1 d1 (._if (_if.dut1));
endmodule



// Example of connecting to generic interface
module dut0 (interface _if);
    // ....
endmodule

module dut1 (interface _if);
    // ....
endmodule


module tb;
    myInterface _if;
    dut0 d0 (._if (_if.dut0));
    dut1 d1 (._if (_if.dut1));
endmodule

// Design Example
// Interface
interface ms_if (input clk);
    logic sready;       // Indicates if slave is ready to accept data
    logic rstn;         // Active low reset
    logic [1:0] addr;   // Address
    logic [7:0] data;   // Data

    modport slave (input addr, data, rstn, clk, output sready);

    modport master (output addr, data, input sready, rstn, clk);
endinterface

// Design
// This module accepts an interface with modport "master"
// Master sends transactions in a pipelined format
// CLK      1   2   3   4   5   6
// ADDR     A0  A1  A2  A3  A0  A1
// DATA         D0  D1  D2  D3  D4
module master (ms_if.master mif);
    always @ (posedge mif.clk) begin
        
        // If reset is applied, set addr and data to default values
        if (! mif.rstn) begin
            mif.addr <= 0;
            mif.data <= 0;
        end else begin  // Else increment addr, and assign data accordingly if slave is ready
            
            // Send new addr and data only if slave is ready
            if (mif.sready) begin
                mif.addr <= mif.addr + 1;
                mif.data <= (mif.addr * 4);
            end else begin  // Else maintain current addr and data
                mif.addr <= mif.addr;
                mif.data <= mif.data;
            end
        end
    end
endmodule

module slave (ms_if.slave sif);
    reg [7:0] reg_a;
    reg [7:0] reg_b;
    reg       reb_c;
    reg [3:0] reg_d;
    
    reg       dly;
    reg [3:0] addr_dly;

    always @ (posedge sif.clk) begin
        if (! sif.rstn) begin
            addr_dly <= 0;
        end else begin
            addr_dly <= sif.addr;
        end
    end

    always @ (posedge sif.clk) begin
        if (! sif.rstn) begin
            reg_a <= 0;
            reg_b <= 0;
            reg_c <= 0;
            reg_d <= 0;
        end else begin
            case (addr_dly)
                0 : reg_a <= sif.data;
                1 : reg_b <= sif.data;
                2 : reg_c <= sif.data;
                3 : reg_d <= sif.data;
            endcase
        end 
    end

    assign sif.sready = ~(sif.addr[1] & sif.addr[0]) | ~dly;

    always @ (posedge sif.clk) begin
        if (! sif.rstn)
            dly <= 1;
        else
            dly <= sif.sready;
    end
endmodule

module d_top (ms_if tif);
    // Pass the "master" modport to master
    master m0 (tif.master);

    // Pass the "slave" modport to slave
    slave s0 (tif.slave);
endmodule

module tb;
    reg clk;
    always #10 clk = ~clk;

    ms_if   if0(clk);
    d_top   d0(if0);

    // Let the stimulus run for 20 clocks and stop
    initial begin
        clk <= 0;
        if0.rstn <= 0;
        repeat (5) @ (posedge clk);
        if0.rstn <= 1;

        repeat (20) @ (posedge clk);
        $finish;
    end

endmodule