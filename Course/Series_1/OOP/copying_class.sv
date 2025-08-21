class first;

    int data;

endclass

module tb;

    first f1;
    first p1;

    initial begin
        f1 = new();  // 1. constructor
        f1.data = 24;  // 2. processing

        p1 = new f1;  // 3. copying data from f1 to p1 
        // p1 = new();
        // p1 = f1;

        $display("Value of p1.data member : %0d", p1.data);  // 4. processing 
        p1.data = 100;
        $display("Value of f1.data member : %0d", f1.data);  // 4. processing 
        $display("Value of p1.data member : %0d", p1.data);  // 4. processing 

    end
endmodule