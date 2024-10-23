module tb;
    initial display();
    initial display();
    initial display();
    initial display();

endmodule
// global task
task display();
    integer i = 0;
    i = i + 1;
    $display("i = %0d", i);

endtask

task automatic display();
    integer i = 0;
    i = i + 1;
    $display("i = %0d", i);

endtask

// task in module

module tb;
    des u0;

    initial begin
        u0.display();  // Task is not visible in the module 'tb'
    end

endmodule

module des
    initial begin
        display();  // Task definition is local to the module
    end

    task display();
        $display("Hello world")
    endtask
endmodule
