module tb;
    // bit arr[7:0];
    bit arr1[8];
    bit arr2[] = {1, 0, 1, 1};

    initial begin
        $display("Size of arr1 : %0d", $size(arr1));
        $display("Size of arr1 : %0d", $size(arr2));

        $display("Value of first element : %0d", arr1[0]);
        arr1[1] = 1;
        $display("Value of second element : %0d", arr1[1]);
      
      	$display("Value of all element of arr2 : %0p", arr2);
    end

endmoduleg