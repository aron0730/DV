module tb;
    // Repetitive Operations
    // 1. for loop, 2. repeat, 3. foreach 
    int arr[10];  // 0 ~ 9
    int i = 0;
    
    /*
    initial begin
        for(i = 0; i < 10; i++) begin
            arr[i] = i;
        end
        $display("arr : %0p", arr);
    end
    */

    foreach(arr[j]) begin
        arr[j] = j;
    end

    initial begin
        foreach(arr[j]) begin
            arr[j] = j;
        end
      	$display("arr : %0p", arr);
    end


    

endmodule