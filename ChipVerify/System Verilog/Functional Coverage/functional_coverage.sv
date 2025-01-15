module test;
    bit [3:0] mode; // mode 可以有 16 種值
    bit [1:0] key;  // key 可以有 4 種值

    // 其他測試平台相關代碼
endmodule

covergroup cg_mode_key;
    coverpoint mode; // 對 mode 變數進行覆蓋率分析
    coverpoint key;  // 對 key 變數進行覆蓋率分析
    cross mode, key; // 分析 mode 和 key 的交叉覆蓋率
endgroup

// Example
class myTrns;
    rand bit [3:0] mode;
    rand bit [1:0] key;

    function display();
        $display("[%0tns] mode = 0x%0h, key = 0x%0h", $time, mode, key);
    endfunction

    covergroup CovGrp;
        coverpoint mode {
            bins featureA = {0};
            bins featureB = {[1:3]};
            bins common [] = {4:$};
            bins reserve = default;
        }
        coverpoint key;

    endgroup
endclass



// How to specify when to sample
class myCov;
    covergroup CovGrp;
        ...
    endgroup

    function new ();
        CovGrp = new;       // Create an instance of the covergroup
    endfunction
endclass

module tb_top;
    myCov myCov0 = new();   // Create an instance of the class

    initial begin
        myCov0.CovGrp.sample();
    end

endmodule

covergroup CovGrp @(posedge clk); // 在 clk 的上升沿進行抽樣
    // 定義覆蓋點
endgroup

covergroup CovGrp @(eventA); // 在事件 eventA 觸發時進行抽樣
    // 定義覆蓋點
endgroup
/*
@(posedge clk) 表示每當 clk 出現上升沿時，觸發覆蓋點抽樣。
@(eventA) 則表示每當 eventA 事件被觸發（例如用 ->eventA），執行覆蓋點抽樣。
*/


// What are the ways for conditional coverage?
// Use iff construct
covergroup CovGrp;
    coverpoint mode iff (!_if.reset) {
        // bins for mode
    }
endgroup

// Use start and stop functions
CovGrrp cg = new;

initial begin
    #1 _if.reset = 0;
    cg.stop();
    #10 _if.reset = 1;
    cg.start();
end