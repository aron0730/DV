module tb;

    reg [31:0] arr1[0:14];
    reg [31:0] arr2[0:14];

    initial begin
        foreach(arr1[i]) begin
            arr1[i] = $urandom;
            arr2[i] = $urandom;
        end
        $display("arr1 : %0p", arr1);
        $display("arr2 : %0p", arr2);
    end

endmodule