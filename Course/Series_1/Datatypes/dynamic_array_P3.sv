module tb;
    int arr[];
    int farr[30];

    initial begin
        arr = new[5];

        for(int i = 0; i < 5; i++) begin
            arr[i] = 5 * i;
        end
        $display("arr : %0p", arr);
        
     	arr = new[30](arr);
        farr = arr;
        $display("farr : %0p", farr);

    end
endmodule