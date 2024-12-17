// Syntax
<variable> inside {<values or range>}

// Inverted "inside"
!(<variable> inside {<values or range>})

// When used in conditional statements
module tb;
    bit [3:0]   m_data;
    bit         flat;

    initial begin
        for (int i = 0; i < 10; i++) begin
            m_data = $random;

            // Used in a ternary operator
            flag = m_data inside {[4:9]} ? 1 : 0;

            // Used with "if-else" operators
            if (m_data indise {[4:9]})
                $display("m_data=%0d INSIDE [4:9], flag=%0d", m_data, flag);
            eles
                $display("m_data=%0d outside [4:9], flag=%0d", m_data, flag);
        end
    end
endmodule
/* sim log :
m_data=4 INSIDE [4:9], flag=1
m_data=1 outside [4:9], flag=0
m_data=9 INSIDE [4:9], flag=1
m_data=3 outside [4:9], flag=0
m_data=13 outside [4:9], flag=0
m_data=13 outside [4:9], flag=0
m_data=5 INSIDE [4:9], flag=1
m_data=2 outside [4:9], flag=0
m_data=1 outside [4:9], flag=0
m_data=13 outside [4:9], flag=0 */

// Used in constraints
class ABC;
    rand bit [3:0] m_var;

    // Constrain m_var to be either 3, 4, 5, 6 or 7
    constraint c_var { m_var inside {[3:7]}; }
endclass

module tb;
    initial begin
        ABC abc = new();
        repeat (5) begin
            abc.randomize();
            $display("abc.m_var = %0d", abc.m_var);
        end
    end
endmodule
/* sim log :
abc.m_var = 7
abc.m_var = 6
abc.m_var = 6
abc.m_var = 3
abc.m_var = 4 */

// Inverted "inside"
class ABC;
    rand bit [3:0] m_var;

    // Constrain m_var to be either 3, 4, 5, 6 or 7
    constraint c_var { !(m_var inside {[3:7]}); }
endclass

module tb;
    initial begin
        ABC abc = new();
        repeat (5) begin
            abc.randomize();
            $display("abc.m_var = %0d", abc.m_var);
        end
    end
endmodule
/* sim log :
abc.m_var = 1
abc.m_var = 12
abc.m_var = 0
abc.m_var = 14
abc.m_var = 10 */

// Practical Example
class Data;
    rand bit [15:0] m_addr;

    constraint c_addr { m_addr inside {[16'h4000:16'h4fff]}; }
endclass

module tb;
    initial begin
        Data data = new()
        repeat (5) begin
            data.randomize();
            $display("addr = 0x%0h", data.m_addr);
        end
    end
endmodule
/* sim log :
addr = 0x48ef
addr = 0x463f
addr = 0x4612
addr = 0x4249
addr = 0x4cee */