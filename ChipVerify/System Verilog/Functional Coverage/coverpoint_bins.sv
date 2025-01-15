coverpoint mode {
    // Manually create a separate bin for each value
    bins zero = {0};
    bins one = {1};

    // Allow SystemVerilog to automatically create separate bins for each value
    // Values from 0 to maximum possible value is split into separate bins
    bins range[] = {[0:$]};

    // Create automatic bins for both the given ranges
    bins c[] = { [2:3], [5:7] };

    // Use fixed number of automatic bins. Entire range is broken up into 4 bins
    bins range[4] = { [0:$] };

    // If the number of bins cannot be equally divided for the given range, then
	// the last bin will include remaining items; Here there are 13 values to be
	// distributed into 4 bins which yields:
	// [1,2,3] [4,5,6] [7,8,9] [10, 1, 3, 6]
    bins range[4] = {[1:0], 1, 3, 6};

 	// A single bin to store all other values that don't belong to any other bin
	bins others = default;   
}

// Example
module tb;
    bit [2:0] mode;

    // This covergroup does not get sample automatically because
    // the sample event is missing in declaration
    covergroup cg;
        coverpoint mode {
            bins one = {1};
            bins five = {5};
        }
    endgroup

    // Stimulus : Simply randomize mode to have different values and
    // manually sample each time
    initial begin
        cg cg_inst = new();

        for (int i = 0; i < 5; i++) begin
            #10 mode = $random;
            $display("[%0t] mode = 0x%0h", $time, mode);
            cg_inst.sample();
        end

        $display("Coverage = %0.2f %%", cg_inst.get_inst_coverage())
    end
endmodule
/* sim log :
[10] mode = 0x4
[20] mode = 0x1
[30] mode = 0x1
[40] mode = 0x3
[50] mode = 0x5
Coverage = 100.00 % */



// Automatic Bins

module tb;
    bit [2:0] mode;

    // This covergroup does not get sample automatically because
    // the sample event is missing in declaration
    covergroup fg;
        coverpoint mode {

            // Declares a separate bin for each values -> Here there will 8 bins
            // 每個數值都會分配到單獨的一個 bin。這裡一共生成 8 個 bins，對應 mode 的可能值 0 到 7。
            bins range[] = {[0:$]};
        }
    endgroup

    // Stimulus : Simply randomize mode to have different values and
    // manually sample each time
    initial begin
        cg cg_inst = new();

        for (int i = 0; i < 5; i++) begin
            #10 mode = $random;
            $display("[%0t] mode = 0x%0h", $time, mode);
            cg_inst.sample();
        end

        $display("Coverage = %0.2f %%", cg_inst.get_inst_coverage())
    end
endmodule

/* sim log :
[10] mode = 0x4
[20] mode = 0x1
[30] mode = 0x1
[40] mode = 0x3
[50] mode = 0x5
Coverage = 50.00 %

模擬執行時，mode 的值被多次取樣，對應的值為：0x4、0x1、0x1、0x3 和 0x5。
在 0 到 7 的範圍中，只有 4 個值被取樣（0x1, 0x3, 0x4, 0x5）。
因此，覆蓋率為50% */


// Fixed Number of automatic bins
covergroup fg;
    coverpoint mode {

        // Declares 4 bins for the total range of 8 values
        // So bin0 -> [0:1], bin1 -> [2:3], bin2 -> [4:5], bin3 -> [6:7]
        bin range[4] = {[0:$]};
    }
endgroup
/* sim log :
[10] mode = 0x4
[20] mode = 0x1
[30] mode = 0x1
[40] mode = 0x3
[50] mode = 0x5
Coverage = 75.00 % */


// Split fixed number of bins between a given range
covergroup
    coverpoint mode {

        // Define 3 bins
        // Two bins for values from 1:4, and one bin for value 7
        // bin1->[1.2]  bin2->[3,4]  bin3->7
        bins range[3] = {[1:4], 7};
    }
endgroup
/* sim log :
[10] mode = 0x4
[20] mode = 0x1
[30] mode = 0x1
[40] mode = 0x3
[50] mode = 0x5
Coverage = 66.67 % */
