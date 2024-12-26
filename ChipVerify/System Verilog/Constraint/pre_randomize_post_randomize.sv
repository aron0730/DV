class Beverage;
    rand bit [7:0]  beer_id;

    constraint c_beer_id {
        beer_id >= 10;
        beer_id <= 50;
    }
endclass

module tb;
    Beverage b;

    initial begin
        b = new();
        $display("Initial beerID = %0d", b.beer_id);
        if (b.randomize())
            $display("Randomization successful !");
        $display("After randomization beerId = %0d", b.beer_id);
    end
endmodule
/* sim log :
# KERNEL: Initial beerId = 0
# KERNEL: Randomization successful !
# KERNEL: After randomization beerId = 25 */

