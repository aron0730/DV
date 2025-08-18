class first;

    reg [2:0] data;
    reg [1:0] data2;

endclass

module tb;
    first f;
    
    initial begin
        f = new();
        f.data = 3'b010;
        f.data2 = 2'b01;
        f = null;  // deallocate class handler
        #1;
        $display("value of data : %0d and data2 : %0d", f.data, f.data2);
    end
    
endmodule