virtual class <class_name>
    // class definition
endclass


// Normal Class Example
class BaseClass;
    int data;

    function new();
        data = 32'hc0de_c0de;
    endfunction
endclass

module tb;
    BaseClass base;
    initial begin
        base = new();
        $display("data=0x%0h", base.data);
    end
endmodule
/* sim log :
data=0xc0dec0de */




// Abstract Class Example
virtual class BaseClass;
    int data;

    function new();
        data = 32'hc0de_c0de;
    endfunction
endclass

module tb;
    BaseClass base;  // ERROR! Abstract classes are not allowed to be instantiated.
    initial begin
        base = new();
        $display("data=0x%0h", base.data);
    end
endmodule
/* sim log :
An abstract (virtual) class cannot be instantiated. */




// Extending Abstract Classes
virtual class BaseClass;
    int data;

    function new();
        data = 32'hc0de_c0de;
    endfunction
endclass

class ChildClass extends BaseClass;
    
    function new();
        data = 32'hfade_fade;
    endfunction

endclass

module tb;
    ChildClass child;

    initial begin
        child = new();
        $display("data=0x%0h", child.data);
    end
endmodule
/* sim log :
data=0xfadefade */




// Pure Virtual Methods
virtual class BaseClass;
    int data;

    pure virtual function int getData();
endclass

class ChildClass extends BaseClass;
    virtual function int getData();  // The pure virtual method prototype and its implementation should have the same arguments and return type.
        data = 32'hcafe_cafe;
        return data;
    endfunction
endclass

module tb;
    ChildClass child;
    
    initial begin
        child = new();
        $display("data = 0x%0h", child.getData());
    end
endmodule
/* sim log :
data = 0xcafecafe */