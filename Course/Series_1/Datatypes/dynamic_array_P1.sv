module tb;
    int arr[];

    initial begin
        arr = new[5];

        for(int i = 0; i < 5; i++) begin
            arr[i] = 5 * i;
        end
        $display("arr : %0p", arr);

        arr.delete();
    end
endmodule