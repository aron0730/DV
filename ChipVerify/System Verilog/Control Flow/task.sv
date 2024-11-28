// Style 1
task [name];
    input [port_list];
    inout [port_list];
    output [port_list];
    begin
        [statements]
    end
endtask

// Style 2
task [name] (input [port_list], inout [port_list], output [port_list]);
    begin
        [statements]
    end
endtask

// Style 3
task [name] ();
    begin
        [statements];
    end
endtask

// Static Task
task sum (input [7:0] a, b, output [7:0] c);
    begin
        c = a + b;
    end
endtask
// or

task sum;
    input [7:0] a, b;
    output [7:0] c;
    begin
        c = a + b;
    end
endtask

module tb;
    reg [7:0] x, y, z;
    initial begin
        sum (x, y, z);
    end
endmodule

// Automatic Task
module tb;

    initial display();
    initial display();
    initial display();
    initial display();

    // This is a static task
    task display();
        integer i = 0;
        i = i + 1;
        $display("i=%0d", i);
    endtask
endmodule
/* sim log :
i=1
i=2
i=3
i=4 */

module tb;

    initial display();
    initial display();
    initial display();
    initial display();

    // Note that the task is now automatic
    task automatic display();
        integer i = 0;
        i = i + 1;
        $display("i=%0d", i);
    endtask
endmodule
/* sim log :
i=1
i=1
i=1
i=1 */

// Global task
// This task is outside all modules
task display();
    $display("Hello World!")
endtask

module des;
    initial begin
        dispaly();
    end
endmodule


// Declared within the module

module tb;

    des u0;

    initial begin
        u0.display();  // Task is not visible in the module 'tb'
    end
endmodule

module des;
    initial begin
        display();  // Task definition is local to the module
    end

    task display();
        $display("Hello World!");
    endtask
endmodule