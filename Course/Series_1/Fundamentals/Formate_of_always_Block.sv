`timescale 1ns/1ps

module tb();
    always @()// always_comb, always_ff, always_latch

    // In testbench code, we do not use @()
    // Just like
    always statement;

    always begin
        .........
        ...........
        .............
    end


endmodule

// Note:

combinational circuit:
always(signal a, b) begin
    
end

sequential circuit:
always(posedge clk) begin
    
end

