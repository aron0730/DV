// Syntax
$test$plusargs (user_string)
$value$plusargs (user_string, variable)

module tb;
    initial begin
        if ($test$plusargs ("STANDBY")) 
            $display ("STANDBY argument is found ...");

        if ($test$plusargs ("Standby"))
            $display ("Standby argument is also found ...");

        if ($test$plusargs ("STAND"))
            $display ("STAND substring is found ...");

        if ($test$plusargs ("S"))
            $display ("Some string starting with S found ...");

        if ($test$plusargs ("T"))
            $display ("Some string containing T found ...");

        if ($test$plusargs ("STAND_AT_EASE"))
            $display ("Can't stand any longer ...");

        if ($test$plusargs ("SUNSHADE"))
            $display ("It's too hot today ...");

        if ($test$plusargs ("WINTER"))
            $display ("No match.. ");
    end
endmodule



// Example
module tb;
    initial begin
        if ($test$plusargs("DEBUG"))
            $display("DEBUG mode enabled!");
        else
            $display("DEBUG mode not enabled.");
    end
endmodule

// cmd line
vsim -c tb +DEBUG

// Output
DEBUG mode enabled!



// Example
module tb;
    initial begin
        int my_val;
        if ($value$plusargs("MY_PARAM=%d", my_val))
            $display("MY_PARAM = %0d", my_val);
        else
            $display("MY_PARAM not provided.");
    end
endmodule

// cmd line
vsim -c tb +MY_PARAM=42

// output
MY_PARAM = 42

/*
$test$plusargs 適合檢查參數是否存在。
$value$plusargs 適合提取參數值。
*/


