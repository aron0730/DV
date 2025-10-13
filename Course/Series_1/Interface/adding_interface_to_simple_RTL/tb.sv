interface add_if;
    logic [3:0] a;
    logic [3:0] b;
    logic [4:0] sum;
endinterface

module tb;
    add_if aif();

    // add dut(aif.a, aif.b, aif.sum);  // positional map
    add dut(.a(aif.a), .b(aif.b), .sum(aif.sum));  // mapping by name

    initial begin
        aif.a = 4;
        aif.b = 4;
        #10;
        aif.a = 3;
        #10;
        aif.b = 7;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end

endmodule

//***************************

interface and_if;
  logic [3:0] a;
  logic [3:0] b;
  logic [3:0] y;
    
  endinterface
 
 
module tb;
  
  and_if aif();
  
  and4 dut (.a(aif.a), .b(aif.b), .y(aif.y));
  
  initial begin
    aif.a = 4'b0100;
    aif.b = 4'b1100;
    #10;
    $display("a : %b , b : %b and y : %b",aif.a, aif.b, aif.y );
  end
  
endmodule
