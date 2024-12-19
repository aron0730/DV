// Implication operator "->" tells that len should be
// greater than 10 when mode is equal to 2
constraint c_mode { mode == 2 -> len > 10; }

// Same thing can be achieved with "if-else" construct
constraint c_mode { if (mode == 2)
                        len > 10; }

// Example
class ABC;
    rand bit [2:0] mode;
    rand bit [3:0] len;

    constraint c_mode { mode == 2 -> len > 10; }
endclass

module tb;
    initial begin
        ABC abc = new();
        for (int i = 0; i < 10; i++) begin
            abc.randomize();
            $display("mode=%0d len=%0d", abc.mode, abc.len);
        end
    end
endmodule
/* sim log :
mode=1 len=11
mode=6 len=3
mode=3 len=9
mode=7 len=11
mode=3 len=15
mode=2 len=12
mode=3 len=6
mode=2 len=12
mode=4 len=9
mode=7 len=13 */

// Implication Operator
// Example
class ABC;
    rand bit [3:0]  mode;
    rand bit        mod_en;

    // If 5 <= mode <= 11, mod_en should be 1
    constraint c_mode { mode inside {4'h5:4'hB} -> mod_en == 1; }
endclass

module tb;
    initial begin
        ABC abc = new;
        for (int i = 0; i < 10; i++) begin
            abc.randomize();
        $display ("mode=0x%0h mod_en=0x%0h", abc.mode, abc.mod_en);
        end
    end
endmodule
/* sim log :
mode=0xf mod_en=0x1
mode=0x9 mod_en=0x1
mode=0x3 mod_en=0x1
mode=0xe mod_en=0x1
mode=0x1 mod_en=0x1
mode=0x0 mod_en=0x0
mode=0x1 mod_en=0x0
mode=0xe mod_en=0x0
mode=0x5 mod_en=0x1
mode=0x0 mod_en=0x0 */


// if_else Constraint
class ABC;
    rand bit [3:0]  mode;
    rand bit        mod_en;

    constraint  c_mode  {
                            // If 5 <= mode <= 11, then constrain mod_en to 1
                            // This part only has 1 statement and hence do not
                            // require curly braces {}
                            if (mode inside {[4'h5:4'hB]})
                                mod_en == 1;

                            // If the above condition is false, then do the following
                            else {
                                // If mode is constrained to be 1, then mod_en should be 1
                                if(mode == 4'h1) {
                                    mod_en == 1;
                                    // If mode is any other value than 1 and not within
                                    // 5:11, then mod_en should be constrained to 0
                                } else {
                                    mod_en == 0;
                                }
                            }
                        }
endclass

module tb;
    initial begin
        ABC abc = new;
        for(int i = 0; i < 10; i++) begin
            abc.randomize();
            $display("mode=0x%0h mod_en=0x%0h", abc.mode, abc.mod_en);
        end
    end
endmodule
/* sim log :
mode=0xb mod_en=0x1
mode=0x1 mod_en=0x1
mode=0x6 mod_en=0x1
mode=0x7 mod_en=0x1
mode=0x2 mod_en=0x0
mode=0x2 mod_en=0x0
mode=0x2 mod_en=0x0
mode=0x9 mod_en=0x1
mode=0x7 mod_en=0x1
mode=0x8 mod_en=0x1 */
