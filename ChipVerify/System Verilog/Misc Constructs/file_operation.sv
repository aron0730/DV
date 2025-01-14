module tb;
    initial begin
        // 1. Declare an integer variable to hold the file descriptor
        int fd;

        // 2. Open a file called "note.txt" in the current folder with a "read" permission
        // If the file does not exist, then fd will be zero
        fd = $fopen("./note.txt", "r");
        if (fd)
            $display("File was opened successfully : %0d", fd);
        else
            $display("File was NOT opened successfully : %0d", fd);

        // 2. Open a file called "note.txt" in the current folder with a "write" permission
        fd = $fopen("./note.txt", "w");
        if (fd)  
            $display("File was opened successfully : %0d", fd);
        else
            $display("File was NOT opened successfully : %0d", fd);

        // 3. Close the file descriptor
        $fclose(fd);
    end
endmodule

/*
"r"	以唯讀模式開啟檔案。檔案必須存在，否則會出錯。
"w"	以寫入模式開啟檔案。如果檔案已存在，內容會被覆蓋；如果檔案不存在，則建立新檔案。
"a"	以附加模式開啟檔案。如果檔案不存在，則建立新檔案；寫入內容時會追加到檔案末尾。
"r+"	以更新模式開啟檔案，允許讀取與寫入。檔案必須存在，否則會出錯。
"w+"	以覆蓋或建立模式開啟檔案，允許讀取與寫入。如果檔案已存在，內容會被清空；如果檔案不存在，則建立新檔案。
"a+"	以附加更新模式開啟檔案，允許讀取與寫入。新增的內容會追加到檔案末尾。
*/

// Example
module tb;
    initial begin
        int fd_w, fd_r, fd_a, fd_wp, fd_rp, fd_ap;

        fd_w = $fopen ("./todo.txt", "w"); 	// Open a new file in write mode and store file descriptor in fd_w
        fd_r = $fopen ("./todo.txt", "r"); 	// Open in read mode
        fd_a = $fopen ("./todo.txt", "a"); 	// Open in append mode


        if (fd_w)     $display("File was opened successfully : %0d", fd_w);
        else      	  $display("File was NOT opened successfully : %0d", fd_w);

        if (fd_r)     $display("File was opened successfully : %0d", fd_r);
        else      	  $display("File was NOT opened successfully : %0d", fd_r);

        if (fd_a)     $display("File was opened successfully : %0d", fd_a);
        else      	  $display("File was NOT opened successfully : %0d", fd_a);

        // Close the file descriptor
        $fclose(fd_w);
        $fclose(fd_r);
        $fclose(fd_a);
    end
endmodule


// How to read and write to a file?
// Example
module tb;
    int fd;         // Variable for file descriptor handle
    string line;    // String value read from the file

    initial begin
        // 1. Lets first open a new file and write some contents into it
        fd = $fopen("trail", "w");

        // Write each index in the for loop to the file using $fdisplay
        // File handle should be the first argument
        for (int i = 0; i < 5; i++) begin
            $fdisplay(fd, "Iteration = %0d", i);
        end

        // Close this file handle
        $fclose(fd);

        // 2. Let us now read back the data we wrote in the previous step
        fd = $fopen("trail", "r");

        // Use $fgets to read a single line into variable "line"
        $fgets(line, fd);
        $display("Line read : %s", line);

        // Get the next line and display
        $fgets(line, fd);
        $display("Line read : %s", line);

        // Close this file handle
        $fclose(fd);
    end
endmodule
/* sim log :
Line read : Iteration = 0

Line read : Iteration = 1 */

// How to read until end of file?
// Example
module tb;
    int fd;         // Variable for file descriptor handle
    string line;    // String value read from the file

    initial begin
        // 1. Lets first open a new file and write some contents into it
        fd = $fopen("trial", "w");
        for (int i = 0; i < 5; i++) begin
            $fdisplay(fd, "Iteration = %0d", i);
        end
        $fclose;

        // 2. Let us now read back the data we wrote in the previous step
        fd = $fopen("trial", "r");

        while (!$feof(fd)) begin
            $fgets(line, fd);
            $display("Line: %s", line);
        end

        // Close this file handle
        $fclose(fd);
    end
endmodule
/* sim log :
Line: Iteration = 0

Line: Iteration = 1

Line: Iteration = 2

Line: Iteration = 3

Line: Iteration = 4 */



// How to parse a line for values
module tb;
    int fd;         // Variable for file descriptor handle
    int idx;
    string str;

    initial begin
        // 1. Lets first open a new file and write some contents into it
        fd = $fopen ("trial", "w");
        for (int i = 0; i < 5; i++)
            $fdisplay (fd, "Iteration = %0d", i);
        $fclose(fd);

        // 2. Let us now read back the data we wrote in the previous step
        fd = $fopen("trial", "r");

        // fscanf returns the number of matches
        while ($fscanf(fd, "%s = %0d", str, idx) == 2) begin
            $display("Line %s = %0d", str, idx);
        end

        // Close this file handle
        $fclose(fd);
    end
endmodule
/* sim log :
Line: Iteration = 0
Line: Iteration = 1
Line: Iteration = 2
Line: Iteration = 3
Line: Iteration = 4 */
