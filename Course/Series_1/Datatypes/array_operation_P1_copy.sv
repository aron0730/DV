module tb;
    int arr1[5];
    int arr2[5];

    initial begin
        
        for (int i = 0; i < 5; i++) begin
            arr1[i] = 5 * i; // 0 5 10 15 20
        end

        arr2 = arr1;

        $display("arr2 : %0p", arr2);
    end

endmodule