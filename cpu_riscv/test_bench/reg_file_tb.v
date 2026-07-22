module reg_file_tb();
reg [4:0] reg_num_1;
reg [4:0] reg_num_2;
reg [4:0] write_reg;
reg reg_write;
reg [31:0] write_data;
reg clk;
reg reset;

wire [31:0] read_data1;
wire [31:0] read_data2;

reg_file dut(
    reg_num_1,
    reg_num_2,
    write_reg,
    reg_write,
    write_data,
    clk,
    reset,
    read_data1,
    read_data2
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin

    reset = 1;
    reg_write = 0;
    reg_num_1 = 0;
    reg_num_2 = 0;
    write_reg = 0;
    write_data = 0;
	 #10
	 
    reset = 0;

    reg_num_1 = 1;
    reg_num_2 = 2;

    write_reg = 3;
    write_data = 7;
    reg_write = 0;
	 #10
	 
	 reset = 1;

    reg_num_1 = 1;
    reg_num_2 = 2;

    write_reg = 3;
    write_data = 7;
    reg_write = 1;
    #10

    reg_write = 1;
    #10

    $stop;

end

endmodule