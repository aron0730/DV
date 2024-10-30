property prop_crc_valid;
    // Assertion checks if CRC is valid
    @ (posedge clk) ($rose(crc_done)) | -> (crc_valid == 1);
endproperty

cover crc_valid_coverage {
    // Coverage bins count how often the assertion is true
    // or false for different scenarios
    bins crc_valid_true = (prop_crc_valid == 1);
    bins crc_valid_false = (prop_crc_valid == 0);
}

assert property (prop_crc_valid);


/*
與 $fell() 和 $stable() 的比較
$rose(signal)：檢測 signal 的上升沿（從 0 變 1）。
$fell(signal)：檢測 signal 的下降沿（從 1 變 0）。
$stable(signal)：檢測 signal 是否在當前時鐘週期保持穩定（無變化）。
*/

/*
bins（覆蓋 bin）：

bins 是 SystemVerilog 中的分類桶，用來計算特定條件被觸發的次數。每當條件符合指定的情況時，該 bin 的計數器會自動增加一次。
crc_valid_true 和 crc_valid_false 是這個覆蓋群組中的兩個 bin，用於記錄 prop_crc_valid 在不同情況下的出現頻率。
crc_valid_true bin：

bins crc_valid_true = (prop_crc_valid == 1);
當 prop_crc_valid 為真（即 1）時，crc_valid_true bin 的計數器會增加一次。這意味著 prop_crc_valid 在模擬過程中被成功觸發的次數被記錄了下來。
crc_valid_false bin：

bins crc_valid_false = (prop_crc_valid == 0);
當 prop_crc_valid 為假（即 0）時，crc_valid_fals
*/

/*
property 區塊主要用於定義「屬性」(property)，其作用是描述設計的預期行為或約束條件。
這些屬性通常與 SystemVerilog Assertions (SVA) 結合使用，用來驗證設計在特定情境下是否符合預期，確保系統的正確性。

property 的用途
property 區塊的用途可以歸納為以下幾點：

定義驗證條件：

property 區塊用於定義一個可以被驗證的條件或行為，類似於一個斷言的模板。
當 property 被定義後，可以在模擬過程中使用 assert 語句來檢查該條件是否成立。
建立可重複使用的驗證邏輯：

property 可以封裝一段驗證邏輯，並在多處使用。這樣可以避免重複寫驗證邏輯，提高驗證的可讀性和維護性。
例如，可以定義一個 property 用於檢查某信號在特定事件發生後是否維持一定狀態，然後在設計中的多處引用這個 property。
檢查時序行為：

property 特別適合檢查數位設計中的時序行為，例如在某信號的上升沿觸發後，另一信號是否會在指定時間內到達某個狀態。
時序屬性通常通過序列操作符（如 |->、## 等）來描述，確保時序上的依賴和反應符合設計要求。
輔助覆蓋率：

property 不僅可以用於斷言檢查，還可以與覆蓋率分析結合，記錄特定條件是否在模擬過程中達成，從而提高覆蓋率。
*/



/*------------------*/
/*
例子中的各個部分解釋
property prop_crc_valid;：

定義一個名為 prop_crc_valid 的 property。這個屬性描述了在特定情況下 crc_valid 的期望行為。
@(posedge clk)：

表示該 property 在每個時鐘上升沿被檢查。這樣可以確保每次時鐘跳變時，系統都會驗證 property 的條件。
$rose(crc_done) |-> (crc_valid == 1);：

|-> 是一個時序操作符，表示「隱含於」。這裡的意思是，當 crc_done 信號從 0 變為 1（即上升沿），那麼在該時間點，crc_valid 信號應該為 1。如果不滿足這個條件，斷言會失敗。
assert property (prop_crc_valid);：

將 prop_crc_valid 的屬性進行實際斷言。這樣，模擬器在模擬過程中會自動檢查 crc_valid 是否在 crc_done 的上升沿滿足預期條件。
其他應用場景
定義時序約束：例如檢查在某信號變化後的若干個時鐘週期內，另一信號應變成特定值。
描述複雜條件的觸發行為：用於描述設計中多信號的複合條件，例如多個事件的依序發生。
配合 cover 提供覆蓋率資料：可以結合 cover 來追蹤某個 property 是否在模擬中被觸發，增加覆蓋率統計的細緻度。
*/