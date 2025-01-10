// Disables randomization of variable [variable_name] inside [class_object] class
[class_object].[variable_name].rand_mode(0);

// Enables randomization of variable [variable_name] inside [class_object] class
[class_object].[variable_name].rand_mode (1);

// Example
// Without using rand mode()
// Create a class that contains random variables
class Fruits;
    rand bit [3:0] var1;
    rand bit [1:0] var2;
endclass

module tb;
    initial begin
        // Instantiate an object of the class
        Fruits f = new();

        // Print values of those variables before randomization
        $display("Before randomization var1=%0d var2=%0d", f.var1, f.var2);

        // rand_mode() is called as a function which returns the state of the given variable
        // If it is enabled, then print a statement
        if (f.var1.rand_mode())
            if (f.var2.rand_mode())
                $display("Randomization of all variables enabled");

        // Randomize the class object which in turn randomizes all internal variables
        // declared using rand/randc keywords
        f.randomiza();

        // Print the value of these variables after randomization
        $display("After randomization var1=%0d var2=%0d", f.var1, f.var2);
    end
endmodule
/* sim log :
Before randomization var1=0 var2=0
Randomization of all variables enabled
After randomization var1=15 var2=3 */


// After using rand mode()
// Create a class that contains random variables
class Fruits;
    rand bit [3:0] var1;
    rand bit [1:0] var2;
endclass

module tb;
    initial begin
        Fruits f = new();
        $display ("Before randomization var1=%0d var2=%0d", f.var1, f.var2);

        // Turn off randomization for var1
        f.var1.rand_mode (0);

        // Print if var1 has randomization enabled/disabled
        if (f.var1.rand_mode())
            $display ("Randomization of var1 enabled");
        else
            $display ("Randomization of var1 disabled");

        f.randomize();

        $display ("After randomization var1=%0d var2=%0d", f.var1, f.var2);
    end
endmodule
/* sim log :
Before randomization var1=0 var2=0
Randomization of var1 disabled
After randomization var1=0 var2=3 */


// Create a class that contains random variables
class Fruits;
    rand bit [3:0] var1;
    rand bit [1:0] var2;
endclass

module tb;

    initial begin
        Fruits f = new();
        $display ("Before randomization var1=%0d var2=%0d", f.var1, f.var2);

        // Turns off randomization for all variables
        f.rand_mode (0);

        if (! f.var1.rand_mode())
            if (! f.var2.rand_mode())
                $display ("Randomization of all variables disabled");

        f.randomize();

        $display ("After randomization var1=%0d var2=%0d", f.var1, f.var2);
    end
endmodule
/* sim log :
Before randomization var1=0 var2=0
Randomization of all variables disabled
After randomization var1=0 var2=0 */
