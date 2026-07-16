module data_mem(
input [6:0] addr,
input mem_we,
input [31:0] w_data,
input reset,
input [1:0] rw_type,
input clk,
output reg [31:0] r_data
);

reg [7:0] mem [0:127];


// READ
always @(*) begin
    case(rw_type)

        // LB
        2'b00:
            r_data = {{24{mem[addr][7]}}, mem[addr]};

        // LH
        2'b01:
            r_data = {{16{mem[addr+1][7]}},
                      mem[addr+1],
                      mem[addr]};

        // LW
        2'b10:
            r_data = {mem[addr+3],
                      mem[addr+2],
                      mem[addr+1],
                      mem[addr]};

        default:
            r_data = 32'b0;

    endcase
end


integer i;

// WRITE + RESET
always @(posedge reset or posedge clk) begin

    if (reset) begin

        for(i=0; i<128; i=i+1)
            mem[i] = i[7:0];

    end

    else begin

        if(mem_we) begin

            case(rw_type)

                // SB
                2'b00:
                    mem[addr] <= w_data[7:0];

                // SH
                2'b01: begin
                    mem[addr]   <= w_data[7:0];
                    mem[addr+1] <= w_data[15:8];
                end

                // SW
                2'b10: begin
                    mem[addr]   <= w_data[7:0];
                    mem[addr+1] <= w_data[15:8];
                    mem[addr+2] <= w_data[23:16];
                    mem[addr+3] <= w_data[31:24];
                end

                default: ;

            endcase

        end

    end

end

endmodule