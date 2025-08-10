module tb;

    int arr[10];

    initial begin
        foreach(arr[i]) begin
            arr[i] = i * i;
        end
        $display("arr's elements : %0p", arr);
    end


endmodule