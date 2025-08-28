class first;  // parent class
    int data = 12;

    virtual function void display();  // Key point : virtual
        $display("FIRST  : Value of data : %0d", data);
    endfunction

endclass

class second extends first;  // child class
    
    int temp = 34;

    function void display();
        $display("SECOND : Value of data : %0d", data);
    endfunction

    function void add();
        $display("Value after process : %0d", temp+4);
    endfunction
endclass

module tb;
    first f;
    second s;

    initial begin
        f = new();
        s = new();

        f = s;
        f.display();

    end
endmodule