module tb;

    logic [31:0] arr[0:19];
    logic [31:0] queue[$]l
    initial begin
        foreach(arr[i]) begin
            arr[i] = $urandom;
        end

        for (int i = arr.size() - 1; i >= 0 ; i--) begin
            queue.push_back(arr[i]);
        end
        $display("arr   : %0p", arr);
        $display("queue : %0p", queue);
    end
endmodule