module tb;
    // Repetitive Operations
    // 1. for loop, 2. repeat, 3. foreach 
    int arr[10];  // 0 ~ 9
    int i = 0;
    
    initial begin
        repeat(10) begin
            arr[i] = i;
            i++;
        end
        $display("arr : %0p", arr);
    end
    
 
endmodule