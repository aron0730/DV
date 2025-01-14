package <package_name>;
  // Typedef declarations
  // Function/Task definitions
  // ...
endpackage

// Example
package my_pkg;

    // Create typedef declarations that can be reused in multiple modules
    typedef enum bit [1:0] { RED, YELLOW, GREEN, RSVD } e_signal;

    typedef struct {
        bit [3:0] signal_id;
        bit       active;
        bit [1:0] timeout;
    } e_sig_param;

    // Create function and task definitions that can be reused
    // Note that it will be a 'static' method if the keyword 'automatic' is not used
    function int calc_parity();
        $display("Called from somewhere");
    endfunction 

endpackage

// Package Import
import <package_name>::*; // Imports all items
import <package_name>::<item_name>; // Imports specific item

// Wildcard Import
import my_pkg::*;

class myClass;
    e_signal    m_signal;
endclass

module tb;
    myClass cls;

    initial begin
        cls     = new();
        cls.m_signal = GREEN;
        $display("m_signal = %s", cls.m_signal.name());
        calc_parity();
    end
endmodule

// Import Specific Items
import my_pkg::GREEN;
import my_pkg::e_signal;
import my_pkg::common;

// Although e_signal is made visible, enumerated labels will not be made visible
import my_pkg::e_signal;

// Import each enumerated label instead, if you are not importing using wildcard ::*
import my_pkg::RED;
import my_pkg::GREEN;
import my_pkg::YELLOW;
// etc

// Search Order
/*
SystemVerilog 的名稱解析遵循一個固定的搜尋順序來確保代碼中相同名稱的項目正確解析，特別是在多層定義（本地定義、package 導入等）同時存在的情況下。

搜尋優先順序
本地定義（Local Definitions）

模組或介面內的定義（如 typedef、enum 等）具有最高優先級，會覆蓋來自任何 package 的名稱。
特定導入（Specific Import）

通過 import package_name::item_name 導入的項目優先於萬用字元導入。
萬用字元導入（Wildcard Import）

通過 import package_name::* 導入的項目優先級最低。
單元範疇（$unit Declaration Space）

如果在上述範圍中均無法解析名稱，則會嘗試尋找 $unit（單元範疇）中的定義。
*/

package my_pkg;
    typedef enum bit { READ, WRITE } e_rd_wr;
endpackage

import my_pkg::*;

module tb;
    typedef enum bit { WRITE, READ } e_wr_rd;

    initial begin
        e_wr_rd  	opc1 = READ;
        e_rd_wr  	opc2 = READ;
        $display ("READ1 = %0d READ2 = %0d ", opc1, opc2);
    end
endmodule
/* sim log :
READ1 = 1 READ2 = 1 */


package my_pkg;
    typedef enum bit { READ, WRITE } e_rd_wr;
endpackage

import my_pkg::*;

module tb;
    typedef enum bit { WRITE, READ } e_wr_rd;
	
    initial begin
        e_wr_rd  	opc1 = READ;
        e_rd_wr  	opc2 = my_pkg::READ;
        $display ("READ1 = %0d READ2 = %0d ", opc1, opc2);
	end
endmodule
/* sim log :
READ1 = 1 READ2 = 0  */


// Nested Package Reference
// Define a new package called X
package X;
    byte lb = 8'h10;
    int word = 32'hcafe_face;
    strint name = "X";

    function void display();
        $display("pkg = %s lb = 0x%0h word = 0x%0h", name, lb, word);
    endfunction
endpackage

// Define a new package called Y, use variable value inside X within Y
package Y;
    import X::*;

    byte lb = 8'h10 + X::lb;
    string name = "Y";

    function void display();
        $display("pkg = %s lb = 0x%0h work=0x%0h", name, lb, word);
    endfunction
endpackage

// Define a new package called Z, use variable value inside Y within Z
package Z;
    import Y::*;

    byte lb = 8'h10 + Y::lb;
    string name = "Z";

    function void display();
        // Note that 'word' exists in package X and not in Y, but X
        // is not directly imported here in Z, so the statement below
        // will result in a compilation error
        //$display("pkg=%s lb=0x%0h word=0x%0h", name, lb, word);  // ERROR !

        $display("pkg = %s lb = 0x%0h", name, lb);
    endfunction
endpackage

module tb;
    // import only Z package
    import Z::*;

    initial begin
        X::display();   // Direct reference X package
        Y::display();   // Direct reference Y package
        display();      // Taken from Z package because of import
    end
endmodule
/* sim log :
pkg=X lb=0x10 word=0xcafeface
pkg=Y lb=0x20 word=0xcafeface
pkg=Z lb=0x30 */



// Example
package alu_pkg;
    typedef enum logic [2:0] {
        ADD = 3'b000,
        SUB = 3'b001,
        AND = 3'b010,
        OR  = 3'b011,
        XOR = 3'b100
    } alu_op_t;

endpackage

import alu_pkg::*;

module alu (
    input logic [2:0] opcode,   // ALU operation code
    input logic [31:0] a,       // First operand
    input logic [31:0] b,       // Second operand
    output logic [31:0] result  // Result of the operation
);

always_comb begin
        // Enumerations defined in 'alu_pkg' can be directly used here
        // because they have been imported
        case(opcode)
            ADD: result = a + b;        // Perform addition
            SUB: result = a - b;        // Perform subtraction
            AND: result = a & b;        // Perform bitwise AND
            OR : result = a | b;        // Perform bitwise OR
            XOR: result = a ^ b;        // Perform bitwise XOR
            default : result = 32'b0;   // Default case (optional)
        endcase
end
endmodule





// Note that package import is not done here
// Example
package alu_pkg;
    typedef enum logic [2:0] {
        ADD = 3'b000,
        SUB = 3'b001,
        AND = 3'b010,
        OR  = 3'b011,
        XOR = 3'b100
    } alu_op_t;

endpackage

module alu (
    input logic [2:0]   opcode,  // ALU operation code
    input logic [31:0]  a,       // First operand
    input logic [31:0]  b,       // Second operand
    output logic [31:0] result   // Result of the operation
);

always_comb begin
    // Enumerations defined in 'alu_pkg' is directly referenced using ::
    case (opcode)
        alu_pkg::ADD  : result = a + b;   // Perform addition
        alu_pkg::SUB  : result = a - b;   // Perform subtraction
        alu_pkg::AND  : result = a & b;   // Perform bitwise AND
        alu_pkg::OR   : result = a | b;   // Perform bitwise OR
        alu_pkg::XOR  : result = a ^ b;   // Perform bitwise XOR
        default       : result = 32'b0;   // Default case (optional)
    endcase
end
endmodule