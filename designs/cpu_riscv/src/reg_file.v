// Just writing need clock and reading don't need
//Prepare data before clock 
module reg_file(
input [4:0]rs1,
input [4:0]rs2,
input [4:0]rd,
input reg_write,
input [31:0]write_data,
input clk,
input reset,
output [31:0]read_data1,
output [31:0]read_data2
);
reg [31:0] mem_reg[31:0];// 32 addresses, each with 32 bits.
always @(posedge reset or posedge clk )begin 
	if (reset)begin
		mem_reg[0] <= 0; mem_reg[16] <= 16; 
		mem_reg[1] <= 1; mem_reg[17] <= 17; 
		mem_reg[2] <= 2; mem_reg[18] <= 18; 
		mem_reg[3] <= 3; mem_reg[19] <= 19; 
		mem_reg[4] <= 4; mem_reg[20] <= 20; 
		mem_reg[5] <= 5; mem_reg[21] <= 21; 
		mem_reg[6] <= 6; mem_reg[22] <= 22; 
		mem_reg[7] <= 7; mem_reg[23] <= 23; 
		mem_reg[8] <= 8; mem_reg[24] <= 24; 
		mem_reg[9] <= 9; mem_reg[25] <= 25; 
		mem_reg[10] <= 10; mem_reg[26] <= 26; 
		mem_reg[11] <= 11; mem_reg[27] <= 27; 
		mem_reg[12] <= 12; mem_reg[28] <= 28; 
		mem_reg[13] <= 13; mem_reg[29] <= 29; 
		mem_reg[14] <= 14; mem_reg[30] <= 30; 
		mem_reg[15] <= 15; mem_reg[31] <= 31; 
	end
	else begin
		if(reg_write == 1 && rd != 5'b00000)begin
			mem_reg[rd] <= write_data;
		end
	end
	
end

assign read_data1 = mem_reg[rs1];
assign read_data2 = mem_reg[rs2];

endmodule