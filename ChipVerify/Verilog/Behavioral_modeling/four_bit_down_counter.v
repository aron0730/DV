module design_top (input clk, input rstn, input en, output [3:0] out);

    counter #(.N(4), .Down(1)) u0 (.clk(clk), .rstn(rstn), .en(en));

endmodule


module counter #(parameter N = 2, parameter DOWN = 0)
                (input clk, input rstn, input en, output reg [N-1:0] out);

    always @ (posedge clk) begin

        if (!rstn) begin
            out <= 0;
        end else begin
            if (en) begin
                if (DOWN) begin
                    out <= out - 1;
                end else begin
                    out <= out + 1;
                end
            end else begin
                out <= out;
            end
        end
    end
endmodule