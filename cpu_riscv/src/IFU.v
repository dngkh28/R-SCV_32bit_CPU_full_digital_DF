module IFU(pc_sel,pc_bran, pc_jalr,clk,reset,pc_next,pc_current, instruction_code);
input clk, reset;
input [1:0]pc_sel;
input [31:0]pc_bran, pc_jalr;
output [31:0] instruction_code;
output [31:0]pc_next, pc_current;
reg [31:0] PC= 32'b0;
INSTR_MEM instr_mem(PC,reset, instruction_code);
wire [31:0]pc_in = pc_sel == 2'b0 ? PC+4 :
						 pc_sel == 2'b1 ? pc_bran :
						 pc_sel == 2'b10 ? {pc_jalr [31:1],1'b0} : PC+4   ;
always @(posedge clk or posedge reset)begin
	if(reset == 1)begin
		PC <= 32'b0;
	end
	else begin
		PC <=pc_in;
		
	end
end
assign pc_next = PC+4;
assign pc_current = PC;
endmodule