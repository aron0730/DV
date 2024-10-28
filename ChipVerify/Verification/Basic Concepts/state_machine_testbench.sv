module dut(input logic clk, rst, [7:0] data_in, 
           output logic [7:0] data_out);
    
    // Simple DUT that just passes the input data to the output data
    always_ff @(posedge clk) begin
        if (rst) begin
            data_out <= 8'b0;
        end else begin
            data_out <= data_in;
        end
    end
endmodule

typedef enum logic [2:0]{
    STATE_IDLE,
    STATE_WRITE,
    STATE_READ
} tb_state_e;

module tb();
    // Declare inputs and outputs
    logic clk;
    logic rst;
    logic [7:0] data_in;
    logic [7:0] data_out;

    // Declare the state machine and state variables
    tb_state_e state, next_state;

    // Initialize state machine to IDLE state
    initial begin
        state = STATE_IDLE;
        next_state = STATE_IDLE;
    end

    // Clock generator
    always #(5ns) clk = ~clk;

    // Instantiate DUT
    dut u_dut(.clk(clk), .rst(rst), .data_in(data_in), .data_out(data_out));

    // Define state machine
    always_ff @ (posedge clk) begin
        
        case(state)
            STATE_IDLE: begin
                // Generate initial input data
                data_in <= 8'hFF;

                // Transition to WRITE state
                next_state = STATE_WRITE;
            end

            STATE_WRITE: begin
                // Write data to DUT input
                data_in <= 8'hAA;

                // Transition to READ state
                next_state = STATE_READ;
            end

            STATE_READ: begin
                // Check that DUT output matches input data
                if (data_out != 8'hAA) begin
                    $error("DUT output does not match input data");
                end

                // Transition back to IDLE state
                next_state = STATE_IDLE;
            end

            default:begin
                $error("Invalid state");
            end
        endcase

        // Update state
        state <= next_state;
    end
endmodule