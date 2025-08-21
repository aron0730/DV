module tb;

    bit [3:0] res[16];

    function automatic init_arr (ref bit [3:0] a[16]);

        for(int i = 0; i < 16; i++) begin
            a[i] = i;
        end
    endfunction

    
    initial begin
        init_arr(res);
        $display("value of res : %p", res);
    end


endmodule