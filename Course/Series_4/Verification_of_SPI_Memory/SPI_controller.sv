

///////////////////////
module top(
    input wr, clk, rst,
    input [7:0] addr, din,
    output [7:0] dout,
    output done, err
);

    wire csreg, mosireg, misoreg, readyreg, opdonereg;

    spi_intf intf (wr, clk, rst, readyreg, opdonereg, addr, din, dout, csreg, mosireg, misoreg, done, err);
    spi_mem mem_inst (clk, rst, csreg, mosireg, readyreg, misoreg, opdonereg);
endmodule