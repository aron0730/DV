// Non-static Constraints
class ABC;
    rand bit [3:0] a;

    // Both are non-static constraints
    constraint c1 { a > 5; }
    constraint c2 { a < 12; }
endclass

module tb;
    initial begin
        ABC obj1 = new;
        ABC obj2 = new;
        for (int i = 0; i < 5; i++) begin
            obj1.randomize();
            obj2.randomize();
            $display("obj1.a = %0d, obj2.a = %0d", obj1.a, obj2.a);
        end
    end
endmodule
/* sim log :
obj1.a = 9, obj2.a = 6
obj1.a = 7, obj2.a = 11
obj1.a = 6, obj2.a = 6
obj1.a = 9, obj2.a = 11
obj1.a = 6, obj2.a = 9 */


// Static Constraints
class ABC;
    rand bit [3:0] a;
    
    // "c1" is non-static, but "c2" is static
    constraint c1 { a > 5;}
    static constraint c2 { a < 12; }
endclass

module tb;
    initial begin
        ABC obj1 = new;
        ABC obj2 = new;

        // Turn off non-static constraint
        obj1.c1.constraint_mode(0);

        for (int i = 0; i < 5; i++) begin
            obj1.randomize();
            obj2.randomize();
            $display("obj1.a = %0d, obj2.a = %0d", obj1.a, obj2.a);
        end
    end   
endmodule
/* sim log :
obj1.a = 3, obj2.a = 6
obj1.a = 7, obj2.a = 11
obj1.a = 6, obj2.a = 6
obj1.a = 9, obj2.a = 11
obj1.a = 6, obj2.a = 9 */



// Turn off static constraint
/* the static constraint called c2 will be turned off. 
We expect both the object instances obj1 and obj2 to be affected by this. */
class ABC;
    rand bit [3:0] a;
    
    // "c1" is non-static, but "c2" is static
    constraint c1 { a > 5;}
    static constraint c2 { a < 12; }
endclass

module tb;
    initial begin
        ABC obj1 = new;
        ABC obj2 = new;

        // Turn off non-static constraint
        obj1.c2.constraint_mode(0);

        for (int i = 0; i < 5; i++) begin
            obj1.randomize();
            obj2.randomize();
            $display("obj1.a = %0d, obj2.a = %0d", obj1.a, obj2.a);
        end
    end   
endmodule
/* sim log :
obj1.a = 15, obj2.a = 12
obj1.a = 9, obj2.a = 15
obj1.a = 14, obj2.a = 6
obj1.a = 11, obj2.a = 11
obj1.a = 12, obj2.a = 11 */

/* Note that both objects of the same class have the constraint c2 turned off as expected. 
Both variables have values of a outside the constraint range. */