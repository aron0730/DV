class generator;

    rand bit [3:0] a, b;  //* rand or randc
    bit [3:0] y;

    // constraint data { a > 15;};  // a can't be more than 16 because the data types is 4 bits, status will be 0

endclass

module tb;
    generator g;
    int i = 0;

    initial begin

        for (i = 0; i < 10; i++) begin
            g = new();  // Every transaction will create new object to avoid overwrite the previous transaction before the dut response
            g.randomize();
            $display("Value of a : %0d and b : %0d with status : %0d", g.a, g.b, status);
            #10;
        end
        
    end
endmodule