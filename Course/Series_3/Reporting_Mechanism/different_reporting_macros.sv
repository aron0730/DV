// Defines all possible values for report severity
//
// UVM_INFO    - Informative message.
// UVM_WARNING - Indicates a potential problem
// UVM_ERROR   - Indicates a real problem. Simulation continues subject
//               to the configured message action.
// UVM_FATAL   - Indicates a problem from which simulation cannot recover.
//               recover. Simulation exits via $finish after a #0 delay.

typedef enum bit [1:0]
{
    UVM_INFO,
    UVM_WARNING,
    UVM_ERROR,
    UVM_FATAL
} uvm_severity;

`ifndef UVM_NO_DEPRECATED
typedef uvm_severity uvm_severity_type;
`endif


// Enum: uvm_verbosity
//
// Defines standard verbosity levels for reports
// 
// UVM_NONE    - Report is always printed. Verbosity level setting cannot disable it.
//
// UVM_LOW     - Report is issued if configured verbosity is set to UVM_LOW or above.
//
// UVM_MEDIUM  - Report is issued if configured verbosity is set to UVM_MEDIUM or above.
//
// UVM_HIGH    - Report is issued if configured verbosity is set to UVM_HIGH or above.
//
// UVM_FULL    - Report is issued if configured verbosity is set to UVM_FULL or above.

typedef enum 
{
    UVM_NONE   = 0,
    UVM_LOW    = 100,
    UVM_MEDIUM = 200,
    UVM_HIGH   = 300,
    UVM_FULL   = 400,
    UVM_DEBUG  = 500
} uvm_verbosity;