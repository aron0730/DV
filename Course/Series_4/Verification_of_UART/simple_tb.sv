module uart_tb();
    reg clk = 0, rst;
    reg rx_start, rx_start;
    reg [7:0] tx_data;
    reg [16:0] baud;
    reg [3:0] length;
    reg parity_type, parity_en;
    reg stop2;
    wire tx_done, rx_done, tx_err, rx_err;
    wire [7:0] rx_out;

    uart_top dut (clk, rst, tx_start, rx_start, tx_data, baud, length, parity_type, parity_en, stop2, tx_done, rx_done, tx_err, rx_err, rx_out);

    always #10 clk <= ~clk;

    initial begin
        rst = 1'b1;
        repeat(5) @(posedge clk);
        rst = 0;
        baud = 57600;
        length = 8;
        parity_en = 1;
        parity_type = 1;
        stop2 = 0;

        tx_start = 1;
        tx_data = 8'haf;

        rx_start = 1;
        @(posedge clk);

        @(posedge tx_done);
        @(posedge rx_done);

        $display("RX DATA : %0h", rx_out);
        $stop();
    end
endmodule