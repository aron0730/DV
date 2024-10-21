module tb;
    integer fd;

    initial begin
        // Open a new file by the name "my_file.txt"
        fd = $fopen ("my_file.txt", "w");

        $fclose(fd);
    end

endmodule

/*
r rb
w wb
a ab
r+ r+b rb+
w+ w+b wb+
a+ a+b ab+
*/

/*
$fdisplay
$fwrite
$fstrobe
$fmonitor
*/

/* ------How to write files------ */
module tb;
    integer fd;
    integer i;
    reg [7:0] my_var;

    initial begin
        // Create a new file
        fd = $fopen("my_file.txt", "w");
        my_var = 0;

        $fdisplay(fd, "Value displayed with $fdisplay");

        #10 my_var = 8'h1A;
        $fdisplay(fd, my_var);      // Displays in decimal
        $fdisplayb(fd, my_var);     // Displays in binary
        $fdisplayo(fd, my_var);     // Displays in octal
        $fdisplayh(fd, my_var);     // Displays in hex

        // $fwrite does not print the newline char automatically at
        // the end of each line; So we can predict all the values printed
        // below to appear on the same line
        $fdisplay(fd, "Value displayed with $fwirte");
        #10 my_var = 8'h2B;
        $fwrite(fd, my_var);
        $fwriteb(fd, my_var);
        $fwriteo(fd, my_var);
        $fwriteh(fd, my_var);

        // Jump to new line with '', and print with strobe which takes
        // the final value of the variable after non-blocking assignments are done
        $fdisplay(fd, "Value displayed with $fstrobe");
        #10 my_var <= 8'h3C;
        $fstrobe(fd, my_var);
        $fstrobeb(fd, my_var);
        $fstrobeo(fd, my_var);
        $fstrobeh(fd, my_var);

        #10 $display(fd, "Value displayed with $fmonitor");
        $fmonitor(fd, my_var);

            for (i = 0; i < 5; i++) begin
                #5 my_var <= i;
            end

        #10 $fclose(fd);
    end

endmodule

/* ------How to read files------ */

module tb1;
    ret [ 8*45 : 1] str;
    integer fd;

    initial begin
        fd = $fopen("my_file.txt", "r");

        // Keep reding lines until EOF is found
        // EOF : End of File
        while (!$feof(fd)) begin
            
            // Get current line into the variable 'str'
            $fgets(str, fd);

            // Display contents of the variable 
            $display("%0s", str);
        end
        $fclose(fd);
    end
endmodule

/*
$fgets：從檔案中讀取一行資料並將其存入變數 str。該函數會持續讀取，直到變數 str 被填滿或遇到換行符或遇到檔案結尾（EOF）。
*/

/* ------Multiple arguments to fdisplay------ */
module tb2;
    reg [3:0] a, b, c, d;
    reg [8*30 : 0] str;
    integer fd;

    initial begin
        a = 4'ha;
        b = 4'hb;
        c = 4'hc;
        d = 4'bd;

        fd = $fopen("my_file.txt", "w");
        $fdisplay(fd, a, b, c, d);
        // sim log : 10111213
        
        $fclose(fd);
    end
endmodule

/* ------Formatting data to a string------ */

module tb3;
    reg [8*19 : 0]str;
    reg [3:0] a, b;

    initial begin
        a = 4'hA;
        b = 4'hB;

        // Format 'a' and 'b' into a string given
        // by the format, and store into 'str' variable
        $sformat(str, "a=%0d b=0x%0h", a, b);
        $display("%0x", str);
        // sim log : a=10 b=0xb
    end
endmodule

