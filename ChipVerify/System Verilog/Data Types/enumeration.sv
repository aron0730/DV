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