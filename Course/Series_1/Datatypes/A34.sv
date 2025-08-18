`timescale 1ns/1ps
module tb;
    int arr[];

    initial begin
        arr = new[7];
        foreach(arr[i]) begin
            arr[i] = (i+1) * 7;
        end
        $display("arr : %0p", arr);
        #20;
        
        arr = new[20](arr);
        for(int i = 7; i < arr.size(); i++) begin
          	arr[i] = (i - 6) * 5;
        end
        $display("arr : %0p", arr);

    end
    
endmodule