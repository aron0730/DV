module tb;
    bit arr1[8];
    bit arr2[];  // = {1, 0, 1, 0};

    initial begin
        $display("Size of arr1 : %0d", $size(arr1));
        $display("Size of arr2 : %0d", $size(arr2));

        $display("value of first element : %0d", arr1[0]);
        arr1[1] = 1;
        $display("value of first element : %0d", arr1[1]);
        arr2[0] = 1;  // warning! arr2 have no specific size, it will out of bounding

        $display("value of all elements of arr2 : %0p", arr2);
    end

endmodule