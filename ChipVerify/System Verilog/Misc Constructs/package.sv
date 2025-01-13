package <package_name>;
  // Typedef declarations
  // Function/Task definitions
  // ...
endpackage

// Example
package my_pkg;

    // Create typedef declarations that can be reused in multiple modules
    typedef enum bit [1:0] { RED, YELLOW, GREEN, RSVD } e_signal;

    typedef struct {
        bit [3:0] signal_id;
        bit       active;
        bit [1:0] timeout;
    } e_sig_param;

    // Create function and task definitions that can be reused
    // Note that it will be a 'static' method if the keyword 'automatic' is not used
    function int calc_parity();
        $display("Called from somewhere");
    endfunction 

endpackage

