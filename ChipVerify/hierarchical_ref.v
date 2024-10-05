module tb;
    A uA();
    B uB();

    initial begin : TB_INITIAL
        reg signal;
        #10 $display(signal = %0d, signal);
    end

    initial begin
        TB_INITIAL.signal = 0;
        uA.display();

        uB.B_INITIAL_BLOCK1.b_signal_1 = 1;
        uB.B_INITIAL_BLOCK2.b_signal_2 = 0;
    end


endmodule

module A;

    task display();
        $display("Hello, world!");
    endtask

endmodule

module B;
    initial begin : B_INITIAL
        #50;
        begin : B_INITIAL_BLOCK1
            reg b_signal_1;
            #10 $display("signal_1=%0d", b_signal_1);
        end

        #50;
        begin : B_INITIAL_BLOCK2
            reg b_signal_2;
            #10 $display("signal_2=%0d", b_signal_2);
        end
    end
endmodule