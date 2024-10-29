module voting_circuit (input [7:0] in1, [7:0] in2, [7:0] in3, output reg [7:0] out);
    always @ (in1, in2, in3) begin
        if((in1 > in2) && (in1 > in3)) begin
            out <= in1;
        end else if ((in2 > in1) && (in2 > in3)) begin
            out <= in2;
        end else begin
            out <= in3;
        end
    end
endmodule

module voting_circuit_tb();
    reg [7:0] in1;
    reg [7:0] in2;
    reg [7:0] in3;
    wire [7:0] out;

    voting_circuit dut(in1, in2, in3, in4);
    initial begin
        in1 = 8'h05;
        in2 = 8'h08;
        in3 = 8'h10;

        #10;
        in1 = 8'h12;
        in2 = 8'h07;
        in3 = 8'h04;

        #10;
        in1 = 8'h01;
        in2 = 8'h01;
        in3 = 8'h20;
    end
endmodule