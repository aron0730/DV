module tb();
    // Declare inputs and outputs
    logic a;
    logic b;
    logic sel;
    logic out;

    // Instantiate DUT
    mux2to1 u_mux(a, b, sel, out);

    // Test cases
    initial begin
        
        // Test case 1: sel=0, a=1, b=0
        sel = 0;
        a = 1;
        b = 0;
        #1 $display("Test case 1: a=%b, b=%b, sel=%b => out=%b", a, b, sel, out);
        if (out !== a) $error("Test case 1 failed");

        // Test case 2: sel=1, a=1, b=0
        sel = 1;
        a = 1;
        b = 0;
        #1 $display("Test case 2: a=%b, b=%b, sel=%b => out=%b", a, b, sel, out);
        if (out !== b) $error("Test case 2 failed");

        // Test case 3: sel=0, a=0, b=1
        sel = 0;
        a = 0;
        b = 1;
        #1 $display("Test case 3: a=%b, b=%b, sel=%b => out=%b", a, b, sel, out);
        if (out !== a) $error("Test case 3 failed");
        
        // Test case 4: sel=1, a=0, b=1
        sel = 1;
        a = 0;
        b = 1;
        #1 $display("Test case 4: a=%b, b=%b, sel=%b => out=%b", a, b, sel, out);
        if (out !== b) $error("Test case 4 failed");

        // Finish test
        $display("All test cases passed");
        $finish
    end
endmodule