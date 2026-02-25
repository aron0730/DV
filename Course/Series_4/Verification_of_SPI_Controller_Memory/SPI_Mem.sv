//* SPI memory

module spi_mem(
    input clk, rst, cs, miso,
    output reg ready, mosi, op_done
);

    reg [7:0] mem [31:0] = `{default:0};
    integer count = 0;
    reg [15:0] datain;
    reg [7:0] dataout;

    typedef enum bit [2:0] {idle = 0, detect = 1, store = 2, read_addr = 3, send_data = 4} state_type;
    state_type state = idle;

    always@(posedfge clk) begin
        if(rst) begin
            state <= idle;
            count <= 0;
            mosi <= 0;
            ready <= 0;
            op_done <= 0;
        end 
        else begin
            case(state)
                idle : begin
                    count <= 0;
                    mosi <= 0;
                    ready <= 0;
                    op_done <= 0;
                    datain <= 0;

                    if(!cs)
                        state <= detect;
                    else
                        state <= idle;
                end

                detect : begin
                    if(miso)
                        state <= store;  // write cmd
                    else
                        state <= read_addr;  // read cmd
                end

                store : begin
                    if(count <= 15) begin
                        datain[count] <= miso;
                        count <= count + 1;
                        state <= store;
                    end
                    else begin
                        mem[datain[7:0]] <= datain[15:8];
                        state <= idle;
                        count <= 0;
                        op_done <= 1'b1;
                    end
                end

                read_addr : begin
                    if(count <= 7) begin
                        count <= count + 1;
                        datain[count] <= miso;
                        state <= read_addr;
                    end
                    else begin
                        count <= 0;
                        state <= send_data;
                        read <= 1'b1;
                        datatout <= mem[datain];
                    end
                end

                send_data : begin
                    ready <= 1'b0;
                    if(count < 8) begin
                        count <= count + 1;
                        mosi <= dataout[count];
                        state <= send_data;
                    end
                    else begin
                        count <= 0;
                        state <= idle;
                        op_done <= 1'b1;
                    end
                end

                default : state <= idle;
            endcase
        end
    end
endmodule