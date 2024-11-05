enum int        {RED, YELLOW, GREEN} light_1;       // int type; RED = 0, YELLOW = 1, GREEN = 2
enum bit[1:0]   {RED, YELLOW, GREEN} light_2;       // bit type; RED = 0, YELLOW = 1, GREEN = 2

enum            {RED=3, YELLOW, GREEN}       light_3;         // RED = 3, YELLOW = 4, GREEN = 5
enum            {RED = 4, YELLOW = 9, GREEN} light_4;         // RED = 4, YELLOW = 9, GREEN = 10 (automatically assigned)
enum            {RED = 2, YELLOW, GREEN = 3} light_5;         // Error : YELLOW and GREEN are both assigned 3

enum bit[0:0]   {RED, YELLOW, GREEN} light_6;                 // Error: minimum 2 bits are required

module tb;
    // "e_true_false" is a new data-type with two valid values: TRUE and FALSE
    typedef enum {TRUE, FALSE} e_true_false;

    initial begin
        // Declare a variable of type "e_true_false" that can store TRUE or FALSE
        e_true_false answer;

        // Assign TRUE/FALSE to the enumerated variable
        answer = TRUE;

        // Display string value of the variable
        $display("answer = %s", answer.name);
    end
endmodule
// sim log : answer = TRUE


/*
name
    表示列舉項目 name，會自動分配下一個連續數值。
    示例：enum { IDLE, RUNNING, STOPPED };，其中 IDLE、RUNNING 和 STOPPED 會自動分配值 0, 1, 2。

name = C
    將常數值 C 明確地分配給列舉項目 name。
    示例：enum { IDLE = 0, RUNNING = 1, STOPPED = 2 };，其中 IDLE = 0, RUNNING = 1, STOPPED = 2。

name[N]
    產生 N 個命名常數，以 name0 到 name(N-1) 命名。
    示例：enum { STATE[3] }; 等同於 enum { STATE0, STATE1, STATE2 };。

name[N] = C
    將值 C 分配給第一個命名常數 name0，後續的 name1 到 name(N-1) 會按順序分配連續值。
    示例：enum { STATE[3] = 10 };，等同於 enum { STATE0 = 10, STATE1 = 11, STATE2 = 12 };。

name[N:M]
    產生從 nameN 到 nameM 的命名常數，N 和 M 是整數。
    示例：enum { LEVEL[2:5] }; 等同於 enum { LEVEL2, LEVEL3, LEVEL4, LEVEL5 };。

name[N:M] = C
    將值 C 分配給 nameN，並且後續 name(N+1) 到 nameM 依次分配連續值。
    示例：enum { LEVEL[2:5] = 7 }; 等同於 enum { LEVEL2 = 7, LEVEL3 = 8, LEVEL4 = 9, LEVEL5 = 10 };。

*/

module tb;
    // name : The next number will be associated with name starting from 0
    // GREEN = 0, YELLOW = 1, RED = 2, BLUE = 3
    typedef enum {GREEN, YELLOW, RED, BLUE} color_set_1;

    // name = C : Associates the constant C to name
    // MAGENTA = 2, VIOLET = 7, PURPLE = 8, PINK = 9
    typedef enum {MEGENTA = 2, VIOLET = 7, PURPLE, PINK} color_set_2;

    // name[N] : Generates N named constants : name0, name1, ..., nameN-1
    // BLACK0 = 0, BLACK1 = 1, BLACK2 = 2, BLACK3 = 3  
    typedef enum {BLACK[4]} color_set_3;

    // name[N] = C : First named constant gets value C and subsequent ones
    // are associated to consecutive values
    // RED0 = 5, RED1 = 6, RED2 = 7
    typedef enum {RED[3] = 5} color_set_4;

    // name[N:M] : First named constant will be nameN and last named
    // constant nameM, where N and M are integers
    // YELLOW3 = 0, YELLOW4 = 1, YELLOW5 = 2
    typedef enum {YELLOW[3:5]} color_set_5;

    // name[N:M] = C : First named constant, nameN will get C and
    // subsequent ones are associated to consecutive values until nameM
    // WHITE3 = 4, WHITE4 = 5, WHITE5 = 6
    typedef enum {WHITE[3:5]= 4} color_set_6;

    initial begin
        // Create new variables for each enumeration style
        color_set_1 color1;
        color_set_2 color2;
        color_set_3 color3;
        color_set_4 color4;
        color_set_5 color5;
        color_set_6 color6;

        color1 = YELLOW; $display("color1 = %0d, name = %s", color1, color1.name());
        color2 = PURPLE; $display("color2 = %0d, name = %s", color2, color2.name());
        color3 = BLACK3; $display ("color3 = %0d, name = %s", color3, color3.name());
        color4 = RED1;   $display ("color4 = %0d, name = %s", color4, color4.name());
        color5 = YELLOW3;$display ("color5 = %0d, name = %s", color5, color5.name());
        color6 = WHITE4; $display ("color6 = %0d, name = %s", color6, color6.name());
    end
endmodule
/*
sim log :
color1 = 1, name = YELLOW
color2 = 8, name = PURPLE
color3 = 3, name = BLACK3
color4 = 6, name = RED1
color5 = 0, name = YELLOW3
color6 = 5, name = WHITE4
*/


/*
first()
    說明：回傳列舉的第一個成員的值。
    用途：當需要從列舉型別的第一個值開始操作時可以使用。

last()
    說明：回傳列舉的最後一個成員的值。
    用途：有助於迭代結尾或檢查列舉的範圍。

next(int unsigned N = 1)
    說明：回傳當前值之後第 N 個列舉值。預設 N = 1，即下一個值。
    用途：用於遍歷列舉值的後續項目，或跳過指定數量的列舉值。

prev(int unsigned N = 1)
    說明：回傳當前值之前第 N 個列舉值。預設 N = 1，即前一個值。
    用途：用於遍歷列舉值的前續項目，或向前跳過指定數量的列舉值。

num()
    說明：回傳列舉中的元素數量。
    用途：可以用於迴圈遍歷或檢查列舉的大小。

name()
    說明：回傳列舉值的字串表示。
    用途：非常適合在除錯或記錄中使用，以便顯示列舉值的名稱。
*/

// GREEN = 0, YELLOW = 1, RED = 2, BLUE = 3
typedef enum {GREEN, YELLOW, RED, BLUE} colors;

module tb;
    initial begin
        colors color;

        // Assign current value of color to YELLOW
        color = YELLOW;

        $display("color.first() = %0d", color.first());     // First value is GREEN = 0
        $display("color.last() = %0d", color.last());       // Last value is BLUE = 3
        $display("color.next() = %0d", color.next());       // Next value is RED = 2
        $display("color.prev() = %0d", color.prev());       // Previous value is GREEN = 0
        $display("color.num() = %0d", color.num());         // Total number of enum = 4
        $display("color.name() = %s", color.name());        // Name of the current enum
    end
endmodule

/*
sim log :
color.first() = 0
color.last()  = 3
color.next()  = 2
color.prev()  = 0
color.num()   = 4
color.name()  = YELLOW
*/

typedef enum bit [1:0] {RED, YELLOW, GREEN} e_light;

module tb;
    e_light light;

    initial begin
        light = GREEN;
        $display("light = %s", light.name());

        // Invalid because of strict typing rules
        light = 0;
        $display("light = %s", lignt.name());

        // OK when explicitly case
        light = e_light'(1);
        $display("light = %s", light.name());

        // OK light is auto-case to integer
        if (light == RED | light == 2)
            $display("light is now %s", light.name());
    end
endmodule