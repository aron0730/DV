module add (
    input [3:0] a, b,
    output [4:0] sum
);

    assign sum = a + b;
endmodule

//**************************

module and4 (
  input [3:0] a,
  input [3:0] b,
  output [3:0] y
 
);
  
 assign y = a & b; 
  
  
endmodule