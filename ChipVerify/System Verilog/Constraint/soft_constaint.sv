class ABC;
    rand bit [3:0] data;

    // This constraint is defined as "soft"
    constraint c_data {
        soft data >= 4;
        data <= 4;
    }
endclass

module tb;
  ABC abc;

  initial begin
    abc = new;
    for (int i = 0; i < 5; i++) begin
      abc.randomize();
      $display ("abc = 0x%0h", abc.data);
    end
  end
endmodule
/* sim log :
abc = 0x4
abc = 0x8
abc = 0x4
abc = 0x7
abc = 0x7 */



class ABC;
    rand bit [3:0] data;

    // This constraint is defined as "soft"
    constraint c_data {
        soft data >= 4;
        data <= 4;
    }
endclass

module tb;
  ABC abc;

  initial begin
    abc = new;
    for (int i = 0; i < 5; i++) begin
      abc.randomize() with { data == 2; }
      $display ("abc = 0x%0h", abc.data);
    end
  end
endmodule
/* sim log :
abc = 0x2
abc = 0x2
abc = 0x2
abc = 0x2
abc = 0x2 */
