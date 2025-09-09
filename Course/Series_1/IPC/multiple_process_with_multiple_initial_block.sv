module tb;

    int data1, data2;
    event done;
    
    int i = 0;

    //* Generator
    initial begin
        for (i = 0; i < 10; i++) begin
            data1 = $urandom();
            $display("Generator sent Data : %0d", data1);
            #10;
        end
        -> done;
    end

    //* Driver
    initial begin
        forever begin
            #10;
            data2 = data1;
            $display("Driver Received Data : %0d", data2);
        end
    end

    initial begin
        wait(done.triggered);
        $finish();
    end

endmodule

//*
# KERNEL: Generator sent Data : -1866196019  <- Something error, we need to utilize fork_join
# KERNEL: Generator sent Data : 1497363586
# KERNEL: Driver Received Data : 1497363586
# KERNEL: Generator sent Data : -323839875
# KERNEL: Driver Received Data : -323839875
# KERNEL: Generator sent Data : 484274802
# KERNEL: Driver Received Data : 484274802
# KERNEL: Generator sent Data : 1697558877
# KERNEL: Driver Received Data : 1697558877
# KERNEL: Generator sent Data : -1150633903
# KERNEL: Driver Received Data : -1150633903
# KERNEL: Generator sent Data : -1621255588
# KERNEL: Driver Received Data : -1621255588
# KERNEL: Generator sent Data : 200096136
# KERNEL: Driver Received Data : 200096136
# KERNEL: Generator sent Data : -1608882576
# KERNEL: Driver Received Data : -1608882576
# KERNEL: Generator sent Data : -491775510
# KERNEL: Driver Received Data : -491775510
# KERNEL: Driver Received Data : -491775510
//*