module tb;
    int arr[];

    initial begin
        arr = new[5];

        for(int i = 0; i < 5; i++) begin
            arr[i] = 5 * i;
        end
        $display("arr : %0p", arr);

        arr = new[30];  // Delete previous arr and new one
        for(int i = 0; i < arr.size(); i++) begin
            arr[i] = 7 * i;
        end
        $display("arr : %0p", arr);

        arr = new[40](arr);  // Copy previous arr in new arr
        $display("arr : %0p", arr);

    end
endmodule