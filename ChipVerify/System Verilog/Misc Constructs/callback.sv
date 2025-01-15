// Step1: Callback Class
class MyCallback;
    virtual function void callback_function();
        // Default implementation (optional)
    endfunction
endclass

// Step2: Registration of Callbacks
class MyTest;
    MyCallback cb;

    // 2. Registration of callback
    function void register_callback(MyCallback callback);
        cb = callback;
    endfunction

    function void execute();
        if (cb != null) begin
            cb.callback_function();
        end
    endfunction
endclass

// Step3: Implementation of Callbacks
class UserCallback extends MyCallback;
    function void callback_function();
        $display("User-defined callback called!");
    endfunction
endclass

// Step4: Invoking the Callback
module tb;
    initial begin
        MyTest          test;
        UserCallback    user_cb;

        test = new();
        user_cb = new();

        // Register user-defined callback
        test.register_callback(user_cb);

        // 4. Execute which will invoke the callback
        test.execute();
    end 
endmodule
/*
MyCallback class defines a virtual function callback_function().
MyTest class has a function to register a callback and later executes the callback function when needed.
UserCallback extends MyCallback and overrides the callback_function() method.
The testbench registers the UserCallback object and calls execute(), which invokes the registered callback function. */