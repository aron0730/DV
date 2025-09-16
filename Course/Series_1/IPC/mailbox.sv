class generator;
    int data = 12;
    mailbox mbx;  //* generator to driver

    task run();
        mbx.put(data);
        $display("[GEN] : SENT DATA : %0d", data);
    endtask

endclass

class driver;
    int datac = 0;
    mailbox mbx;

    task run();
        mbx.get(datac);
        $display("[DRV] : RCVD DATA : %0d", datac);
    endtask

endclass

module tb;
    
    generator gen;
    driver drv;
    mailbox mbx;

    initial begin
        gen = new();
        drv = new();
        mbx = new();

        gen.mbx = mbx;
        drv.mbx = mbx;

        gen.run();
        drv.run();
    end
endmodule