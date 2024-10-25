class Adder;

    // Define the inputs and output
    rand bit [3:0] A, B;
    rand bit [4:0] C;

    // Define the constraints
    constraint c_addr { A inside {[0:15]};
                        B inside {[0:15]};
                        C == A + B;
                      }

    function void display();
        $display("A=0x%0h B=0x%0h" C=0x%0h, A, B, C);
    endfunction
endclass

module tb;
    initial begin
        Adder m_adder = new();

        // Generate A and B randomly with the constraint that A and B cannot be the same
        m_adder.randomize() with { A != B };

        m_adder.display();
    end

endmodule