module my_module(input clk, sel, [7:0] data, output reg [7:0] out);
    reg [7:0] internal_reg;


    always @ (posedge clk) begin
        if(sel) begin
            internal_reg <= data;
        end else begin
            internal_reg <= internal_reg + 1;
        end
    end

    always @ (*) begin
        case(internal_reg)
            8'h00: out = 8'h10;
            8'h01: out = 8'h20;
            8'h02: out = 8'h30;
            8'h03: out = 8'h40;
            default : out = 8'h50;
        endcase
    end
endmodule