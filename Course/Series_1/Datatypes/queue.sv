module tb;
    int arr[$];  // queue
    
    initial begin
        arr = {1, 2, 3};  // queue do not need apostrophe(')
        $display("arr : %0p", arr);
    end


endmodule