module tb;

    // unique
    int arr1[2] = '{1, 2};

    // repetition operator
    int arr2[2] = '{2{3}};

    // default
    int arr3[2] = '{default: 2};

    // uninitialized
    int arr4[2];

    int arr[10] = '{default: 2};

    initial begin
        $display("arr1 : %0p", arr1);
    end
endmodule