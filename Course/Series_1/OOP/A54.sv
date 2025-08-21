module tb;

    bit [7:0] arr[32];

    function automatic void gen_element (ref bit [7:0] arr[32]);
        foreach (arr[i]) begin
            arr[i] = i * 8;
        end
    endfunction

    initial begin
        gen_element(arr);
        foreach (arr[i]) begin
            $display("arr[%0d] = %0d", i, arr[i]);
        end
    end

endmodule