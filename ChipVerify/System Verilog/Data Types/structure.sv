// Normal array -> a collection of variables of same data type
int array [10];         // all elements are of int type
bit [7:0] mem [256];    // all elements are of bit type

// Structures -> a collection of variables of different data types
struct {
    byte    val1;
    int     val2;
    string  val3;
} struct_name;

// Unpacked Structures
module tb;
    // Create a structure called "st_fruit"
    // which to store the fruit's name, count and expiry date in days.
    // Note: this structure declaration can also be placed outside the module
    struct {
        string fruit;
        int count;
        byte expiry;
    } st_fruit_t;

    initial begin
        // st_fruit is a structure variable, so let's initialize it
        st_fruit_t = '{"apple", 4, 15};

        // Display the structure variable
        $display("st_fruit_t = %p", st_fruit_t);

        // Change fruit to pineapple, and expiry to 7
        st_fruit_t.fruit = "pineapple";
        st_fruit_t.expiry = 7;
        $display("st_fruit_t = %p", st_fruit_t);
    end
endmodule


module tb;
  	// Create a structure called "st_fruit"
	// which to store the fruit's name, count and expiry date in days.
  	// Note: this structure declaration can also be placed outside the module
	typedef struct {
  		string fruit;
  		int    count;
  		byte 	 expiry;
	} st_fruit;

  initial begin
    // st_fruit is a data type, so we need to declare a variable of this data type
    st_fruit fruit1 = '{"apple", 4, 15};
    st_fruit fruit2;

    // Display the structure variable
    $display ("fruit1 = %p fruit2 = %p", fruit1, fruit2);

    // Assign one structure variable to another and print
    // Note that contents of this variable is copied into the other
   	fruit2 = fruit1;
    $display ("fruit1 = %p fruit2 = %p", fruit1, fruit2);

    // Change fruit1 to see if fruit2 is affected
    fruit1.fruit = "orange";
    $display ("fruit1 = %p fruit2 = %p", fruit1, fruit2);
  end
endmodule

// Packed Structures
// Create a "packed" structure data type which is similar to creating
// bit[7:0] ctrl_reg;
// ctrl_reg[0]      represents en
// ctrl_reg [3:1]   represents cfg
// ctrl_reg [7:0]   represents mode

typedef struct packed {
    bit [3:0]   mode;
    bit [2:0]   cfg;
    bit         en;
} st_ctrl;

module tb;
    st_ctrl ctrl_reg;

    initial begin
        // Initialize packed structure variable
        ctrl_reg = '{4'ha, 3'h5, 1};
        $display("ctrl_reg = %p", ctrl_reg);

        // Change packed structure member to something else
        ctrl_reg.mode = 4'h3;
        $display("ctrl_reg = %p", ctrl_reg);

        // Assign a packed value to the structure variable
        ctrl_reg = 8'hfa;
        $display("ctrl_reg = %p", ctrl_reg);

    end
endmodule

/* sim log : 
ctrl_reg = '{mode:'ha, cfg:'h5, en:'h1}
ctrl_reg = '{mode:'h3, cfg:'h5, en:'h1}
ctrl_reg = '{mode:'hf, cfg:'h5, en:'h0} */