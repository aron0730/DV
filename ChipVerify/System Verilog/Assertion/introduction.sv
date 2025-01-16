// A property written in Verilog/SystemVerilog
always @ (posedge clk) begin
    if (!(a && b))
        $display("Assertion failed");
end

// The property above written in SystemVerilog Assertions syntax
assert property (@(posedge clk) a && b);

/*
assert：用於模擬驗證，及早發現設計中的錯誤。
assume：用於形式驗證工具的約束建模，確保生成有效的測試用例。
cover：幫助評估測試用例是否充分覆蓋設計功能。
restrict：用於形式驗證中優化檢查範圍或性能。 */

// Building Blocks of Assertions
/*
Sequence 是一組邏輯事件的序列，通常用於描述設計功能。
這些事件可以跨越多個時鐘週期，或者僅存在於單個時鐘週期中。
目標：將較小的事件組合起來，用於建立更複雜的行為模式。 */
// Sequence syntax
sequence <name_of_sequence>
    <test expression>
endsequence

// Assert the sequence
assert property (<name_of_sequence>);

// Example 
sequence example_seq;
    @(posedge clk) a == 1 ##1 b == 0 ##2 c == 1;
endsequence

assert property (example_seq);



// Property
/*
Property 是一個或多個 Sequence 的組合，也可以是邏輯條件表達式。
它用於描述和驗證複雜的行為或時序條件。
Property 是 Assertion 的核心，通過它進一步實現驗證和覆蓋的功能。*/
// Porperty syntax
property <name_of_property>
    <test expression> or <sequence expressions>
endproperty

// Assert the property
assert property (<name_of_sequence>);


// Immediate vs Concurrent
// Immediate Example 1
assert (data_valid) else $fatal("Data is invalid!");

// Immediate Example 2
always @ (<some_event>) begin
	...
	// This is an immediate assertion executed only
	// at this point in the execution flow
	$assert(!fifo_empty);      // Assert that fifo is not empty at this point
	...
end


// Concurrent Example 1
property handshake;
    @(posedge clk) req |-> ack ##1 data_ready;
endproperty

assert property (handshake);

// Concurrent Example 2
// Define a property to specify that an ack should be
// returned for every grant within 1:4 clocks
property p_ack;
	@(posedge clk) gnt ##[1:4] ack;  // 當 gnt 信號有效時，ack 信號必須在 1 到 4 個時鐘週期內有效。
endproperty

assert property(p_ack);    // Assert the given property is true always

// Example
module tb;
    bit a, b, c, d;
    bit clk;

    always #10 clk = ~clk;

    initial begin
        for (int i = 0; i < 20; i++) begin
            {a, b, c, d} = $random;
            $display("%0t a = %0d b = %0d c = %0d d = %0d", $time, a, b, c, d);
            @(posedge clk);
        end
        #10 $finish;
    end

    sequence s_ab;
        a ##1 b;  // 當 a 有效後，下一個時鐘週期內 b 必須有效。
    endsequence

    sequence s_cd;
        c ##2 d;  // 當 c 有效後，2 個時鐘週期內 d 必須有效。
    endsequence

    property p_expr;
        @(posedge clk) s_ab ##1 s_cd;  // s_ab 序列在時鐘正緣觸發後成立。 在 1 個時鐘週期後，s_cd 序列必須成立。
    endproperty

    assert property (p_expr);
endmodule
