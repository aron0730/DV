`timescale 1ns/10ps
module clock_gen (input enable, 
                  output reg clk);

    parameter FREQ = 100000;  // in kHz
    parameter PHASE = 0;      // in degrees
    parameter DUTY = 50;      // in percentage

    real clk_pd = 1.0 / (FREQ * 1e3) * 1e9  // convert to ns
    real clk_on = DUTY / 100.0 * clk_pd;
    real clk_off = (100.0 - DUTY) / 100.0 * clk_pd;
    real quarter = clk_pd / 4;
    real start_dly = quarter * PHASE / 90;

    reg start_clk;

    initial begin
        $display("FREQ      = %0d kHz", FREQ);
        $display("PHASE     = %0d deg", PHASE);
        $display("DUTY      = %0d %%", DUTY);
        
        $display("PERIOD    = %0.3f ns", clk_pd);
        $display("CLK_ON    = %0.3f ns", clk_on);
        $display("CLK_OF    = %0.3f ns", clk_off);
        $display("QUARTER   = %0.3f ns", quarter);
        $display("START_DLY = %0.3f ns", start_dly);
    end

    initial begin
        clk <= 0;
        start_clk <= 0;
    end

    always @ (posedge enable or negative enable) begin
        if (enable) begin
            #(start_dly) start_clk = 1;
        end else begin
            #(start_dly) start_clk = 0;
        end
    end

    always @ (posedge start_clk) begin
        if (start_clk) begin
            clk = 1;

            while (start_clk) begin
                #(clk_on) clk = 0;
                #(clk_off) clk = 1;
            end

            clk = 0;
        end
    end
endmodule


module tb;

    wire clk1;
    wire clk2;
    wire clk3;
    wire clk4;
    reg enable;
    reg [7:0] dly;

    clock_gen                  u0 (enable, clk1);
    clock_gen #(.FREQ(200000)) u1 (enable, clk2);
    clock_gen #(.FREQ(400000)) u2 (enable, clk3);
    clock_gen #(.FREQ(800000)) u3 (enable, clk4);    

    initial begin
        enable <= 0;

        for (int i = 0; i < 10; i++) begin
            dly = $random;
            #(dly) enable <= ~enable;
            $display("i=%0d dly=%0d", i, dly);
            #50;
        end

        #50 $finish;
    end
endmodule

module tb2;

    wire clk1;
    wire clk2;
    wire clk3;
    wire clk4;
    reg enable;
    reg [7:0] dly;

    clock_gen                  u0 (enable, clk1);
    clock_gen #(.DUTY(25)) u1 (enable, clk2);
    clock_gen #(.DUTY(50)) u2 (enable, clk3);
    clock_gen #(.DUTY(75)) u3 (enable, clk4);    

    initial begin
        enable <= 0;

        for (int i = 0; i < 10; i++) begin
            dly = $random;
            #(dly) enable <= ~enable;
            $display("i=%0d dly=%0d", i, dly);
            #50;
        end

        #50 $finish;
    end
endmodule