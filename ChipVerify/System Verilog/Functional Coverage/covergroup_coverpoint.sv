// covergroup
module tb;
    // Declare some variables that can be "sampled" in the covergroup
    bit [1:0] mode;
    bit [2:0] cfg;

    // Declare a clock to act as an event that can be used to sample
    // coverage points within the covergroup
    bit clk;
    always #20 clk = ~clk;

    // "cg" is a covergroup that is sampled at every posedge clk
    covergroup cg @ (posedge clk);
        coverpoint mode;
    endgroup

    // Create an instance of the covergroup
    cg cg_inst;

    initial begin
        // Instantiate the covergroup object similar to a class object
        cg_inst = new();

        // Stimulus : Simply assign random values to the coverage variables\
        // so that different values can be sampled by the covergroup object
        for (int i = 0; i < 5; i++) begin
            @(negedge clk);
            mode = $random;
            cfg = $random;
            $display("[%0t] mode = 0x%0h cfg = 0x%0h", $time, mode, cfg);
        end
    end

    // At the end of 500ns, terminate test and print collected coverage
    initial begin
        #500 $display("Coverage = %0.2f %%", cg_inst.get_inst_coverage());
    end
endmodule


// coverpoint
module tb;

    bit [1:0] mode;
    bit [2:0] cfg;
    
    bit clk;
    always #20 clk = ~clk;

    // "cg" is a covergroup that is sampled at every posedge clk
    // This covergroup has two coverage points, one to cover "mode"
    // and the other to cover "cfg". Mode can take any value from
    // 0->3 and cfg can take any value from 0 -> 7
    covergroup cg @ (posedge clk);

        // Coverpoints can optionally have a name before a colon ":"
        cp_mode     : coverpoint mode;
        cp_cfg_10   : coverpoint cfg[1:0];
        cp_cfg_lsb  : coverpoint cfg[0];
        cp_sum      : coverpoint(mode + cfg);
    endgroup

    cg cg_inst;

    initial begin
        cg_inst = new();

        for (int i = 0; i < 5; i++) begin
            @(negedge clk);
            mode = $random;
            cfg = $random;
            $display ("[%0t] mode=0x%0h cfg=0x%0h", $time, mode, cfg);
        end
    end

    initial begin
        #500 $display ("Coverage = %0.2f %%", cg_inst.get_inst_coverage());
        $finish;
    end
endmodule