class Item;
    rand bit [7:0] id;
    
    constraint c_id { id < 25; }

endclass

module tb;
    initial begin
        Item itm = new();
        itm.randomize() with { id == 10 };      // In-line constraint using with construct
        $display("Item ID = %0d", tem.id);
    end
endmodule
/* sim log :
# KERNEL: Item Id = 10 */

class Item;
    rand bit [7:0] id;

    constraint c_id { id == 25; }
endclass

module tb;
    initial begin
        if (!itm.randomize() with { id < 10; }) {
            $display("Randomization failed");
        }
        $display("Item Id = %0d", itm.id);
    end
endmodule
/* sim log :
Randomization failed */

