// forever
module tb;
    // This initial block has a forever loop which will "run forever"
    // Hence this block will never finish in simulation
    initial begin
        forever begin
            #5 $display("Hello World !");
        end
    end

    // Because the other initial block will run forever, our simulation will hang!
    // To avoid that, we will explicity terminate simulation after 50ns using $finish
    initial
        #50 $finish;
endmodule

// repeat
module tb;
    
    // This initial block will execute a repeat statement that will run 5 times and exit
    initial begin
        
        // Repeat everything within begin end 5 times and exit "repeat" block
        repeat(5) begin
            $display("Hello World !");
        end
    end
endmodule

// while
module tb;
    bit clk;

    always #10 clk = ~clk;
    initial begin
        bit [3:0] counter;

        $display("Counter = %0d", counter);     // Counter = 0
        while (counter < 10) begin
            @(posedge clk);
            counter++;
            $display("Counter = %0d", counter);     // Counter increments
        end

        $display("Counter = %0d", counter);     // Counter = 10
        $finish;
    end
endmodule

// for
module tb;
    bit clk;

    always #10 clk = ~clk;
    initial begin
        bit [3:0] counter;

        $display("Counter = %0d", counter);     // Counter = 0
        for (counter = 2; counter < 14; counter = counter + 2) begin
            @(posedge clk);
            $display("Counter = %0d", counter);     // Counter increments
        end

        $display("Counter = %0d", counter);     // Counter = 14
        $finish;
    end 
endmodule

// do while
module tb;
    bit clk;

    always #10 clk = ~clk;
    initial begin
        bit [3:0] counter;
        $display("Counter = %0d", counter);

        do begin
            @(posedge clk);
            counter++;
            $display("Counter = %0d", counter);
            
        end while (counter < 5);

        $display("Counter = %0d", counter);
        $finish;
    end
endmodule

// foreach
module tb;
    bit [7:0] array[8];     // Create a fixed size array

    initial begin
        
        // Assign a value to each location in the array
        foreach (array[index]) begin
            array[index] = index;
        end

        // Iterate through each location and print the value of current location
        foreach (array[index]) begin
            $display("array[%0d] = %0d", index, array[index]);
        end
    end
endmodule