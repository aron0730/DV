module ram_single_port #(parameter ADDR_WIDTH = 16, DATA_WIDTH = 32) 
(input wire clk, 
 input wire we, 
 input wire [ADDR_WIDTH-1:0] addr, 
 input wire [DATA_WIDTH-1:0] din, 
 output wire [DATA_WIDTH-1:0] dout);

    reg [DATA_WIDTH - 1 : 0] mem[2**ADDR_WIDTH - 1 : 0];

    always @ (posedge clk) begin
        if (we == 1)
            mem[addr] <= din;  // write data to address 'addr'
    end

    // read data from current addr
    assign dout = mem[addr];

endmodule

// Write-Through Logic
module ram_single_port #(parameter ADDR_WIDTH = 16, DATA_WIDTH = 32) 
(input wire clk, 
 input wire we, 
 input wire [ADDR_WIDTH-1:0] addr, 
 input wire [DATA_WIDTH-1:0] din, 
 output wire [DATA_WIDTH-1:0] dout);

    reg [DATA_WIDTH - 1 : 0] mem[2**ADDR_WIDTH - 1 : 0];

    always @ (posedge clk) begin
        if (we == 1) begin
            mem[addr] <= din;  // write data to address 'addr'
            dout <= din;
        end else begin
            dout <= mem[addr];  // read data
        end
    end

endmodule


// Write-Back Logic
module ram_single_port #(parameter ADDR_WIDTH = 16, DATA_WIDTH = 32) 
(input wire clk, 
 input wire we, 
 input wire [ADDR_WIDTH-1:0] addr, 
 input wire [DATA_WIDTH-1:0] din, 
 output wire [DATA_WIDTH-1:0] dout);

    reg [DATA_WIDTH - 1 : 0] mem[2**ADDR_WIDTH - 1 : 0];
    reg [ADDR_WIDTH - 1 : 0] last_write_addr;  
    reg write_back_flag;

    always @ (posedge clk) begin
        if (we) begin
            mem[addr] <= din;  // Write data to mem
            last_write_addr <= addr;  // restore current write in addr
            write_back_flag <= 1;
        end else begin
            if (write_back_flag && (addr == last_write_addr))
                dout <= din;
            else
                dout <= mem[addr];
            write_back_flag <= 0;
        end
    end
endmodule