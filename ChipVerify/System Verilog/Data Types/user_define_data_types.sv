// Normal declaration may turn out to be quite long
unsigned shortint           my_data;
enum {RED, YELLOW, GREEN}   e_light;
bit[7:0]                    my_byte;

// Declare an alias for this long definition
typedef unsigned shortint           u_shorti;
typedef enum {RED, YELLOW, GREEN}   e_light;
typedef bit[7:0]                    u_byte;

// Use these new data-types to create variables
u_shorti    my_data;
e_light     light1;
ubyte       my_byte;


module tb;
    typedef shortint unsigned u_shorti;
    typedef enum {RED, YELLOW, GREEN} e_light;
    typedef bit[7:0] u_byte;

    initial begin
        u_shorti 	data = 32'hface_cafe;
        e_light 	light = GREEN;
        ubyte 		cnt = 8'hFF;

        $display ("light=%s data=0x%0h cnt=%0d", light.name(), data, cnt);        
    end
endmodule


// Alias
logic [7:0] data;
alias mydata = data; // 將 "mydata" 作為訊號 "data" 的別名

initial begin
    mydata = 8'hFF; // 使用別名 "mydata" 對 "data" 進行賦值
end