// Random Distribution Example
class ABC;
    rand bit [2:0] b;
endclass

module tb;
    initial begin
        ABC abc = new;
        for (int i = 0; i < 10; i++) begin
            abc.randmoize();
            $display("b=%0d", abc.b);
        end
    end
endmodule
/* sim log :
b=7
b=7
b=2
b=1
b=6
b=4
b=2
b=4
b=0
b=1 */


// Without solve - before
class ABC;
    rand bit        a;
    rand bit [1:0]  b;

    constraint c_ab { a -> b == 3'h3; }
endclass

module tb;
    initial begin
        ABC abc = new();
        for (int i = 0; i < 8; i++) begin
            abc.randomize();
            $display("a = %0d b = %0d", abc.a, abc.b);
        end
    end
endmodule
/* sim log :
Note that a and b are determined together and not one after the other.
a=0 b=0
a=0 b=1
a=0 b=0
a=0 b=1
a=0 b=2
a=1 b=3
a=0 b=3
a=0 b=3 */

/*
a	b	Probability
0	0	1/(1 + 2^2)
0	1	1/(1 + 2^2)
0	2	1/(1 + 2^2)
0	3	1/(1 + 2^2)
1	3	1/(1 + 2^2)
*/


// With solve - before
class ABC;
    rand  bit			a;
    rand  bit [1:0] 	b;

    constraint c_ab { a -> b == 3'h3;

                    // Tells the solver that "a" has
                    // to be solved before attempting "b"
                    // Hence value of "a" determines value
                    // of "b" here
                        solve a before b;
                    }
endclass

module tb;
    initial begin
        ABC abc = new;
        for (int i = 0; i < 8; i++) begin
        abc.randomize();
        $display ("a=%0d b=%0d", abc.a, abc.b);
        end
    end
endmodule
/* sim log :
a=1 b=3
a=1 b=3
a=0 b=1
a=0 b=0
a=0 b=0
a=0 b=1
a=1 b=3
a=0 b=2 */

/*
a	b	Probability
0	0	1/2 * 1/2^2
0	1	1/2 * 1/2^2
0	2	1/2 * 1/2^2
0	3	1/2 * 1/2^2
1	3	1/2 
*/
