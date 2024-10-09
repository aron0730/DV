module d_latch (input d, en, rstn, 
                output reg q);

    always @ (en or rstn or d) begin
        if (!rstn) begin
            q <= 0;
        end else begin
            if (en) begin
                q <= d;
            end
        end
    end
endmodule

task init();
    d <= 0;
    en <= 0;
    rstn <= 0;
    prev_q <= 0;
endtask

task reset_release();
    // 2. Release reset
    #10 rstn <= 1;
endtask

task checker (input d, en, rstn, q);
    #1;
    if (!rstn) begin
        if (q != 0)
            $error("Q is not 0 during resetn !");
    end else begin
        if (en) begin
            if (q != d)
                $error("Q does not follow D when EN is high ! ");
        end else begin
            if (q != prev_q)
                $error("Q does not get latched !"); 
        end
    end
endtask

task test_1();
    // 3. Randomly change d and en
    integer delay, delay2;
    for (i = 0; i < 5; i++) begin
        delay = $random;
        delay2 = $random;
        #(delay2) en <= ~en;
        #(delay) d <= i;

        // Check output value for given inputs
        checker(d, en, rstn, q);
        prev_q <= q;
    end
endtask

module tb_latch;
    reg d, en ,rstn;
    reg prev_q;
    wire q;
    integer i;

    d_latch u0 (.d(d), .en(en), .rstn(rstn), .q(q));

    initial begin
        // {d, en, rstn} <= 0;
        init();

        reset_release();
        test_1();
    end

endmodule