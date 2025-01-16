// Syntax
// Simple assert statement
assert(<expression>);

// Assert statement with statements to be executed for pass/fail conditions
assert(<expression>) begin
    // If condition is true, execute these statements
end else begin
    // If condition is false, execute these statements
end

// Optionally give name for the assertion
[assert_name] : assert(<expression>);


// Immediate Assertion in Design
interface my_if(input bit clk);
    logic pop;
    logic push;
    logic empty;
    logic full;
endinterface

module my_des (my_if _if);

    always @ (posedge _if.clk) begin
        if (_if.push) begin
            // Immediate assertion and ensures that
            // fifo is not full when push is 1
            a_push: assert (!_if.full) begin
                $display("[PASS] push when fifo not full");
            end else begin
                $display("[FAIL] push when fifo full !");
            end
        end
    end

    if (_if.pop) begin
        // Immediate assertion ot ensure that fifo is not
        // empty when pop is 1
        a_pop: assert (!_if.empty) begin
            $display("[PASS] pop when fifo not empty");
        end else begin
            $display("[FAIL] pop when fifo empty !");
        end
    end
endmodule

module tb;
    bit clk;
    always #10 clk <= ~clk;

    my_if _if (clk);
    my_des u0 (.*);

    initial begin
        for (int i = 0; i < 5; i++) begin
            _if.push  <= $random;
            _if.pop   <= $random;
            _if.empty <= $random;
            _if.full  <= $random;
            $strobe("[%0t] push=%0b full=%0b pop=%0b empty=%0b", $time, _if.push, _if.full, _if.pop, _if.empty);
            @(posedge clk);
        end
        #10 $finish;
    end
endmodule
/* sim log :
[0] push=0 full=1 pop=1 empty=1
ncsim: *E,ASRTST (./design.sv,13): (time 10 NS) Assertion tb.u0.a_pop has failed 
[FAIL] pop when fifo empty !
[10] push=1 full=0 pop=1 empty=1
[PASS] push when fifo not full
ncsim: *E,ASRTST (./design.sv,13): (time 30 NS) Assertion tb.u0.a_pop has failed 
[FAIL] pop when fifo empty !
[30] push=1 full=1 pop=1 empty=0
ncsim: *E,ASRTST (./design.sv,5): (time 50 NS) Assertion tb.u0.a_push has failed 
[FAIL] push when fifo full !
[PASS] pop when fifo not empty
[50] push=1 full=0 pop=0 empty=1
[PASS] push when fifo not full
[70] push=1 full=1 pop=0 empty=1
ncsim: *E,ASRTST (./design.sv,5): (time 90 NS) Assertion tb.u0.a_push has failed  */


// Immediate Assertion in Testbench
class Packet;
    rand bit [7:0] addr;

    constraint c_addr { addr > 5; addr < 3; }
endclass

module tb;
    initial begin
        Packet m_pkt = new();

        m_pkt.randomize();
    end
endmodule

