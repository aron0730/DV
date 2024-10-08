module lshift_reg (input clk,
                    input rstn,
                    input [7:0] load_val,
                    input load_en,
                    output reg [7:0] op);

    always @ (posedge clk) begin
        if (!rstn) begin
            op <= 0;
        end else begin
            if (load_en) begin
                op <= load_val;
            end else begin
                op[0] <= op[7];
                op[1] <= op[0];
                op[2] <= op[1];
                op[3] <= op[2];
                op[4] <= op[3];
                op[5] <= op[4];
                op[6] <= op[5];
                op[7] <= op[6];
            end
        end
    end
endmodule


module lshift_reg_for (input clk,
                        input rstn,
                        input [7:0] load_val,
                        input load_en,
                        output [7:0] op);
    integer i;

    always @ (posedge clk) begin
        if (!rstn) begin
            op <= 0;
        end else begin
            if (load_en) begin
                op <= load_val;
            end else begin
                for (i = 0; i < 7; i = i + 1) begin
                    op[i + 1] <= load_val[i];
                end
                op[0] <= op[7];
            end
        end
    end
endmodule


