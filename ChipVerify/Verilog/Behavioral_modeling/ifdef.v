module my_design (input clk, d, 
`ifdef INCLUDE_RSTN
                  input rstn,
`endif 
                  output reg q);
    
    always @ (posedge clk) begin
`ifdef INCLUDE_RSTN
        if (!rstn) begin
            q <= 0;
        end else
`endif
        begin
            q <= d;
        end
    end
endmodule

module tb;
    reg clk, d, rstn;
    wire q;
    reg [3:0] delay;

    my_design u0 (.clk(clk), .d(d), 
    `ifdef INCLUDE_RSTN
                    .rstn(rstn),
    `endif 
                    .q(q));

    always #10 clk = ~clk;

    initial begin
        integer i;
        {d, rstn, clk} <= 0;
        #20 rstn <= 1;
        for (i = 0; i < 20; i = i + 1) begin
            delay = $random;
            #(delay) q = $random;
        end

        #20 $finish;
    end
endmodule


module tb1;
    initial begin

`ifdef MARCO1
    $display("This is MARCO1");

`elsif MARCO2
    $display("This is MARCO02");
`endif
    end

endmodule

module tb2;

    initial begin
        `ifdef FLAG
            $display("FLAG is defined");

            `ifdef NEST1_A
                $display("FLAG and NEST1_A are defined");

                `ifdef NEST2
                    $display("FLAS, NEST1_A and NEST2 are defined");
                `endif
            `elsif NEST1_B
                $display("FLAG and NEST1_B are defined");
                `ifndef WHITE
                    $display("FLAG and NEST1_B are defined, but WHITE is not");
                `else
                    $display("FLAG, NEST1_B and WHITE are defined");
                `endif
            `else
                $display("Only FLAG is defined");
            `endif 
        `else
            $display("FLAG is not defined");
        `endif
    end

endmodule