// Integer
// ubyte is converted to signed type and assigned to si
si = signed'(ubyte);

// Signed
module tb;
    // By default int data types are signed which means
    // that MSB is the sign bit and the integer variables can
    // also store negative numbers
    shortint var_a;
    int      var_b;
    longint  var_c;

    initial begin
        // Print initial values of the integer variables
        $display("Sizes var_a=%0d var_b=%0d var_c=%0d", $bits(var_a), $bits(var_b), $bits(var_c));
        // sim log : Sizes var_a=16 var_b=32 var_c=64

        // Assign the maximun value for each of the variables
        // MSB of each variable represents the sign bit and is set ot 0
        // Rest of the bit positions are filled with 1 and hence you
        // get the maximum value that these variables can hold
        #1  var_a = 'h7FFF;
            var_b = 'h7FFF_FFFF;
            var_c = 'h7FFF_FFFF_FFFF_FFFF;

        // When added a 1, the sign changes to negative because this is a signed variable
        #1  var_a += 1;     // Value becomes 'h8000 => which is a rollover from + sign to - sign
            var_b += 1;     // Value becomes 'h8000_0000 => which is a rollover from + sign to - sign
            var_c += 1;
    end

    // Start a monitor to print out values of each variables as they change
    initial
        $monitor("var_a=%0d var_b=%0d var_c=%0d", var_a, var_b, var_c);
        // sim log : var_a=32767 var_b=2147483647 var_c=9223372036854775807
        // sim log : var_a=-32768 var_b=-2147483648 var_c=-9223372036854775808
endmodule

// Unsigned
module tb;
    // In this case, we are going to make it unsigned which means
    // that MSB no longer holds the sign information and hence these
    // variables can only store positive values
    shortint unsigned var_a;
    int      unsigned var_b;
    longint  unsigned var_c;

    initial begin
        // Print initial values of the integer variables
        $display("Sizes var_a=%0d var_b=%0d var_c=%0d", $bits(var_a), $bits(var_b), $bits(var_c));
        // sim log : Sizes var_a=16 var_b=32 var_c=64

        // Assign the maximum value for each of the variables
        #1  var_a = 'hFFFF;
            var_b = 'hFFFF_FFFF;
            var_c = 'hFFFF_FFFF_FFFF_FFFF;

        // When added a 1, value rolls over to 0
        #1  var_a += 1;     // Value becomes 'h0
            var_b += 1;     // Value becomes 'h0
            var_c += 1;
    end

    // Start a monitor to print out values of each variables as they change
    initial
        $monitor("var_a=%0d var_b=%0d var_c=%0d", var_a, var_b, var_c);
        // sim log : var_a=65535 var_b=4294967295 var_c=18446744073709551615
        // sim log : var_a=0 var_b=0 var_c=0
endmodule

// byte
module tb;
    byte          s_byte;   // By default byte is signed
    byte unsigned u_byte;   // Byte is set to unsigned

    initial begin
        $display("Size s_byte=%0d, u_byte=%0d", $bits(s_byte), $bits(u_byte));

        // Assign the "assumed" maximum value to both variables
        #1  s_byte = 'h7F;
            u_byte = 'h7F;

        // Invrement by 1, and see that s_byte rolled over to negative because
        // byte is signed by default. u_byte keeps increasing because it is 
        // unsigned and can go upto 255
        #1  s_byte += 1;
            u_byte += 1;
        
        // Assign 255 (8'hFF) to u_byte -> this is the max value it can hold
        #1  u_byte = 'hFF;

        // Add 1 and see that it rolls over to 0
        #1  u_byte += 1;
    end

    initial begin
        $monitor("[%0t ns] s_byte=%0d u_byte=%0d", $time, s_byte, u_byte);
    end

endmodule

/*
Size s_byte=8, u_byte=8
[0 ns] s_byte=0 u_byte=0
[1 ns] s_byte=127 u_byte=127
[2 ns] s_byte=-128 u_byte=128
[3 ns] s_byte=-128 u_byte=255
[4 ns] s_byte=-128 u_byte=0
*/