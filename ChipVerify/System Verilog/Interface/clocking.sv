// Syntax
[default] clocking [identifier_name] @ [event_or_identifier]
    default input #[delay_or_edge] output #[delay_or_edge]
    [list of signals]
endclocking

clocking ckb @ (posedge clk);
    default input #1step output negedge;
    input ...;
    output ...;
endclocking

clocking ck1 @ (posedge clk);
    default input #5ns output #2ns;
    input data, valid, ready = top.ele.ready;
    output negedge grant;
    input #1step addr;
endclocking

// Clocking Blocks Part 2
clocking cb @(clk);
    input #1ps req;
    output #2 gnt;
    input #1 output #3 sig;
endclocking

// Example
module des (input req, clk, output reg gnt);
    always @ (posedge clk)
        if (req)
            gnt <= 1;
        else
            gnt <= 0;
endmodule

interface _if (input bit clk);
    logic gnt;
    logic req;

    clocking cb @(posedge clk);
        input #1ns gnt;
        output #5 req;
    endclocking
endinterface

module tb;
    bit clk;

    // Instantiate the interface
    _if if0(.clk(clk));

    // Instantiate the design
    des d0 (.clk(clk), .req(if0.req), .gnt(if0.gnt));

    // Create a clock and initialize input signal
    always #10 clk = ~clk;

    initial begin
        clk <= 0;
        if0.cb.req <= 0;
    end

    // Drive stimulus
    initial begin
        for (int i = 0; i < 10; i++) begin
            bit [3:0] delay = $random;
            repeat (delay) @(posedge if0.clk);
            if0.cb.req <= ~if0.cb.req;
        end
        #20 $finish;
    end
endmodule

// Other Example
// Output skew
interface _if (input bit clk);
    logic gnt;
    logic req;

    clocking cb_0 @(posedge clk);
        output #0  req;
    endclocking

    clocking cb_1 @(posedge clk);
        output #2 req;
    endclocking

    clocking cb_2 @(posedge clk);
        output #5 req;
    endclocking
endinterface

module tb;
    bit clk;

    // Instantiate the interface
    _if if0(.clk(clk));

    // Instantiate the design
    des d0 (.clk(clk), .req(if0.req), .gnt(if0.gnt));

    // Create a clock and initialize input signal
    always #10 clk = ~clk;

    initial begin
        clk <= 0;
        if0.cb.req <= 0;
    end

    // Drive stimulus
    initial begin
        for (int i = 0; i < 3;i++) begin
            repeat (2) @ (if0.cb_0);
            case(i)
                0 : if0.cb_0.req <= 1;
                1 : if0.cb_1.req <= 1;
                2 : if0.cb_2.req <= 1;
            endcase
            repeat (2) @ (if0.cb_0);
            if0.req <= 0;
        end
        $20 finish;
    end
endmodule

// Input skew
module des (output reg[3:0] gnt);
    always #1 gnt <= $random;
endmodule

interface _if (input bit clk);
    logic [3:0] gnt;

    clocking cb_0 @(posedge clk);
        input #0  gnt;
    endclocking

    clocking cb_1 @(posedge clk);
        input #1step gnt;
    endclocking

    clocking cb_2 @(posedge clk);
        input #1 gnt;
    endclocking

    clocking cb_3 @(posedge clk);
        input #2 gnt;
    endclocking
endinterface

module tb;
    bit clk;

    always #5 clk = ~clk;
    initial   clk <= 0;

    _if if0 (.clk (clk));
    des d0  (.gnt (if0.gnt));

    initial begin
        fork
            begin
                @(if0.cb_0);
                $display ("cb_0.gnt = 0x%0h", if0.cb_0.gnt);
            end

            begin
                @(if0.cb_1);
                $display ("cb_1.gnt = 0x%0h", if0.cb_1.gnt);
            end

            begin
                @(if0.cb_2);
                $display ("cb_2.gnt = 0x%0h", if0.cb_2.gnt);
            end
            
            begin
                @(if0.cb_3);
                $display ("cb_3.gnt = 0x%0h", if0.cb_3.gnt);
            end
        join
        #10 $finish;
    end

endmodule