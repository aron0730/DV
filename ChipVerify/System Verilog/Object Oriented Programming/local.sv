// When accessed from outside the class
class ABC;
    // By default, all variables are public and for this example,
    // let's create two variables - one public and the other "local"
    byte        public_var;
    local byte  local_var;

    // This function simply prints these variable contents
    function void display();
        $display("public_var=0x%0h, local_var=0x%0h", public_var, local_var);
    endfunction
endclass

module tb;
    initial begin
        
        // Create a new class object, and call display method
        ABC abc = new();
        abc.display();

        // Public variables can be accessed via the class handle
        $display("public_var = 0x%0h", abc.public_var);

        // However, local variables cannot be accessed from outside
        $display("local_var = 0x%0h", abc.local_var);
    end
endmodule
/* sim log :
Access to local member 'local_var' in class 'ABC' is not allowed here. */

module tb;
    initial begin
        
        ABC abc = new();

        // This should be able to print local members of class ABC
        // because display() is a member of ABC also
        abc.display();

        // Public variables can always be accessed via the class handle
        $display("public_var = 0x0%h", abc.public_var);
    end
endmodule
/* sim log :
public_var=0x0, local_var=0x0
public_var = 0x0 */



// When accessed by child classes
// Define a base class and let the variable be "local" to this class
class baseClass;
    local byte local_var;
endclass

// Define another class that extends ABC and have a function that tries
// to access the local variable in ABC
class childClass extends baseClass;
    function show();
        $display("local_var = 0x%0h", local_var);
    endfunction
endclass

module tb;
    initial begin
        
        // Create a new object of the child class, and call the show method
        // This will give a compile time error because child classes connot access
        // base class "local" variables and methods
        childClass child = new();
        child.show();
    end
endmodule
/* sim log :
Access to local member 'local_var' in class 'ABC' is not allowed here. */