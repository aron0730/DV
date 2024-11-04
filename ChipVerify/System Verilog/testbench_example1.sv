// Design
// Note that in this protocol, write data is provided
// in a single clock along with the address while read
// data is received on the next clock, and no transactions
// ca be started during that time indicated by "ready" signal.

module reg_ctrl #(parameter ADDR_WIDTH = 8,
                  parameter DATA_WIDTH = 16,
                  parameter DEPTH = 256,
                  parameter RESET_VAL = 16'h1234)
                 (input clk,
                  input rstn,
                  input [ADDR_WIDTH-1:0] address,
                  input sel,
                  input wr,
                  input [DATA_WIDTH-1:0] wdata,
                  output reg [DATA_WIDTH-1:0] rdata,
                  output reg ready);

    reg [DATA_WIDTH-1:0] ctrl [DEPTH];
    reg ready_dly;
    reg ready_pe;

    // if reset is asserted, clear the memory element
    // Else store data to addr for valid writes
    // For reads, provide read data back
    always @ (posedge clk) begin
        if (!rstn) begin
            // 在重置期間，將所有寄存器初始化為 RESET_VAL
            for(int i = 0; i < DEPTH; i++) begin
                ctrl[i] <= RESET_VAL;
            end
        end else begin
            // 寫入操作：當 sel, ready, wr 都為高電平時，將 wdata 寫入對應的地址
            if (sel & ready & wr) begin
                ctrl[addr] <= wdata;
            end

            // 讀取操作：當 sel, ready 為高電平，且 wr 為低電平時，將地址對應的資料放入 rdata
            if (sel & ready & !wr) begin
                rdata <= ctrl[addr];
            end else begin
                rdata <= 0;  // 若無讀取操作，則將 rdata 清零
            end
        end
    end

    // Ready is driven using this always block
    // During reset, drive ready as 1
    // Else drive ready low for a clock low
    // for a read until the data is given back
    always @ (posedge clk) begin
        if (!rstn) begin
            ready <= 1;  // 重置期間，將 ready 設為 1
        end else begin
            if (sel & ready_pe) begin
                ready <= 1;  // 當 ready_pe 訊號為高時，恢復 ready 為 1
            end

            if (sel & ready & !wr) begin
                ready <= 0;  // 當正在執行讀取操作時，將 ready 設為 0，阻止新的操作
            end
        end
    end

    // Drive internal signal accordingly
    always @ (posedge clk) begin
        if (!rstn) begin
            ready_dly <= 1;  // 重置時，ready_dly 設為 1
        end else begin
            ready_dly <= ready;  // 否則，將 ready_dly 更新為 ready
        end
    end

    assign ready_pe = ~ready & ready_dly;
endmodule

/*
一次完整的復位後寫入+讀取操作流程如下：

復位階段：rstn 為低，初始化寄存器。
寫入階段：rstn 釋放，sel=1，wr=1，並設置 address 和 wdata，寫入數據。
讀取階段：sel=1，wr=0，並設置 address，讀取數據並將 ready 設為 0。
恢復 ready：在下一個時鐘週期，ready 恢復為高，模組可以進行新的操作。
*/


// Transaction Object
class reg_item;
    // This is the base transaction object that will be used
    // in the evnironment to initiate new transactions and
    // capture transactions at DUT interface
    rand bit [7:0] addr;
    rand bit [15:0] wdata;
    rand bit [15:0] rdata;
    rand bit wr;

    // This function allows us to print contents of the data packet
    // so that it is eaiser to track in a logfile
    function void print(string tag="");
        $display("T=%0t [%s] addr=0x%0h wr=%0d wdata=0x%0h rdata=0x%0h", 
                            $time, tag, addr, wr, wdata, rdata);
    endfunction
endclass

/*
這些欄位前的 rand 關鍵字允許 UVM 中的隨機化機制進行隨機測試，使驗證工具可以自動生成各種測試場景。
*/

// Driver
// The driver is responsible for driving transactions to the DUT
// All it does is to get a transaction from the mailbox if it is
// available and drive it out into the DUT interface.
class driver;
    virtual reg_if vif;
    event drv_done;
    mailbox drv_mbx;

    task run();
        $display ("T=%0t [Driver] starting ...", $time);
        @ (posedge vif.clk);

        // Try to get a new transaction every time and then assign
        // packet contents to the interface. But do this only if the
        // design is ready to accept new transactions

        // 不斷從訊息箱中取出新的交易物件並驅動到介面
        forever begin
            reg_item item;
            $display ("T=%0t [Driver] waiting for item ...", $time);
            drv_mbx.get(item);  // 從 drv_mbx 中取出交易物件 item
            item.print("Driver");  // 印出交易物件的細節

            // 將交易物件的內容驅動到介面信號上
            vif.sel <= 1;
            vif.addr <= item.addr;
            vif.wr <= item.wr;
            vif.wdata <= item.wdata;
            @ (posedge vif.clk);  // 在下一個時鐘上升沿開始驅動

            // 等待直到 ready 信號為高
            while (!vif.ready) begin
                $display("T=%0t [Driver] wait until ready is high", $time);
                @(posedge vif.clk);
            end

            // When transfer is over, raise the done event
            vif.sel <= 0;
            ->drv_done;  // 觸發 drv_done 事件，用於通知其他等待該事件的進程。
        end
    endtask
endclass


// Monitor
// The monitor has a virtual interface handle with which it can monitor
// the events happening on the interface. It sees new transactions and then
// captures information into a packet and sends it to  the scoreboard
// using another mailbox.
class monitor;
    virtual reg_if vif;
    mailbox scb_mbx;  // Mailbox connected to scoreboard

    task run();
        $display("T=%0t [Monitor] starting ...", $time);

        // Check forever at every clock edge to see if there is a 
        // valid transaction and if yes, capture info into a class
        // object and send it to the scoreboard when the transaction
        // is over.
        forever begin
            @(posedge vif.clk);
            if (vif.sel) begin
                reg_item item = new;

                item.addr = vif.addr;
                item.wr = vif.wr;
                item.wdata = vif.wdata;

                if (!vif.wr) begin
                    @(posedge vif.clk);
                    item.rdata = vif.rdata;
                end

                item.print("Monitor");
                scb_mbx.put(item);
            end
        end
    endtask
endclass;


// Scoreboard
// The scoreboard is responsible to check data integrity. Since the design
// stores data it receives for each address, scoreboard helps to check if the 
// same data is reveived when the same address is read at any later point
// in time. So the scoreboard has a "memory" element which updates it
// internally for every write operation.
class scoreboard;
    mailbox scb_mbx;
    reg_item refq[256];

    task run();
        forever begin
            reg_item item;
            scb_mbx.get(item);
            item.print("Scoreboard");

            if (item.wr) begin
                if (refq[item.addr] == null)
                    refq[item.addr] = new;

                refq[item.addr] = item;
                $display("T=%0t [Scoreboard] Store addr=0x%0h wr=0x%0h data=0x%0h", $time, item.addr, item.wr, item.wdata)
            end

            if (!item.wr) begin
                if (refq[item.addr] == null)
                    if (item.rdata != 'h1234)
                        $display("T=%0t [Scoreboard] ERROR! First time read, addr=0x%0h exp=1234 act=0x%0h",
                                    $time, item.addr, item.rdata);

                    else
                        $display("T=%1t [Scoreboard] PASS! First time read, addr=0x%0h exp=1234 act=0x%0h",
                                    $time, item.addr, item.rdata);
                
                else
                    if (item.rdata != refq[item.addr].wdata)
                        $display("T=%1t [Scoreborard] ERROR! addr=0x%0h exp=0x%0h act=0x%0h",
                                    $time, item.addr, refq[item.addr].wdata, item.rdata);
                    
                    else
                        $display("T=%1t [Scoreboard] PASS! addr=0x%0h exp=0x%0h act=0x%0h",
                                    $time, item.addr, refq[item.addr].wdata, item.rdata);
            end
        end 
    endtask
endclass

// Environment
// The environment is a container object simply to hold all verification
// components together. This environment can then be reused later and all
// components in it would be automatically connected and available for use
// This is an environment without a generator.
class env;
    driver              d0;         // Driver to design  
    monitor             m0;         // Monitor for design
    scoreboard          s0;         // Scoreboard connected to monitor
    mailbox             scb_mbx;    // Top level mailbox for Scoreboard <-> Monitor
    virtual reg_if      vif;        // Virtual interface handle

    // Instantiate all testbench components
    function new();
        d0 = new;
        m0 = new;
        s0 = new;
        scb_mbx = new();
    endfunction

    // Assign handles and start all components so that
    // they all become active and wait for transactions to be 
    // available
    virtual task run();
        d0.vif = vif;
        m0.vif = vif;
        m0.scb_mbx = scb_mbx;
        s0.scb_mbx = scb_mbx;

        fork
            s0.run();
            d0.run();
            m0.run();
        join_any
    endtask
endclass

/*
driver do          ：driver 負責從 mailbox 中獲取 transaction 並驅動到設計的介面上。
monitor m0         ：monitor 用來從設計中捕獲 transaction 並將其送到 scoreboard 進行驗證。
scoreboard s0      ：scoreboard 用來檢查數據完整性，確保寫入和讀取的數據一致。
mailbox scb_mbx    ：mailbox 是 monitor 和 scoreboard 之間的通信通道，允許 monitor 傳遞 transaction 給 scoreboard。
virtual reg_if vif ：虛擬介面，用於將虛擬介面 handle 傳遞給元件，使得它們可以互相通信。
*/


// Test
// An environment without the generator and hence the stimulus should be
// written in the test.
class test;
    env e0;
    mailbox drv_mbx;

    function new();
        drv_mbx = new();
        e0 = new();
    endfunction

    virtual task run();
        e0.d0.drv_mbx = drv_mbx;

        fork
            e0.run();
        join_none

        apply_stim();
    endtask

    virtual task apply_stim();
        reg_item item;
        $display("T=%0t [Test] Starting stimulus ...", $time);
        item = new;
        item.randomize() with { addr == 8'haa; wr == 1; };
        drv_mbx.put(item);

        item = new;
        item.randomize() with { addr == 8'haa; wr == 0; };
        drv_mbx.put(item);
    endtask
endclass

// Interface
// The interface allows verification components to access DUT signals
// using a virtual interface handle
interface reg_if (input bit clk);
    logic rstn;
    logic [7:0] addr;
    logic [15:0] wdata;
    logic [15:0] rdata;
    logic wr;
    logic sel;
    logic ready;
endinterface

module tb;
    reg clk;

    always #10 clk = ~clk;

    reg_if _if (clk);

    reg_ctrl u0 (.clk(clk), 
                 .addr (_if.addr), 
                 .rstn(_if.rstn), 
                 .sel(_if.sel), 
                 .wr(_if.wr), 
                 .wdata(_if.wdata), 
                 .rdata(_if.rdata), 
                 .ready(_if.ready));

    initial begin
        test t0;
        clk <= 0;
        _if.rstn <= 0;
        _if.sel <= 0;
        #20 _if.rstn <= 1;

        t0 = new;
        t0.e0.vif =_if;
        t0.run();

        // Once the main stimulus is over, wait for some time
        // until all transactions are finished and then end
        // simulation. Note that $finish is required bacause
        // there are components that are running forever in
        // the background like clk, monitor, driver, etc
        #200 $finish;
    end

    // Simulator dependent system tasks that can be used to
    // dump simulation waves.
    initial begin
        $dumpvars;
        $dumpfile("dump.vcd");
    end

endmodule