// Code your testbench here
// or browse Examples
module tb;
  int arr[$];  // queue
    
    initial begin
      	int j = 0;
        arr = {1, 2, 3};  // queue do not need apostrophe(')
        $display("arr : %0p", arr);

        arr.push_front(7);
        $display("arr : %0p", arr);
      
      	arr.push_back(9);
      	$display("arr : %0p", arr);
      
      	arr.insert(2, 10);  // Insert 10 at index 2
      	$display("arr : %0p", arr);

        j = arr.pop_front();
        $display("arr : %0p", arr);
        $display("value of j : %0d", j);

        j = arr.pop_back();
        $display("arr : %0p", arr);
        $display("value of j : %0d", j);

        arr.delete(1);  // delete the element at indes 1
        $display("arr : %0p", arr);

    end

endmodule