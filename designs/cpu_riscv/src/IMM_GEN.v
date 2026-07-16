module IMM_GEN(
input [31:0]instr,//instruction from 0->31
input [2:0]imm_sel,
output reg [31:0]imm_out
);
parameter I_TYPE = 3'b000;
parameter S_TYPE = 3'b001;
parameter B_TYPE = 3'b010;
parameter U_TYPE = 3'b011;
parameter J_TYPE = 3'b100;
always @(*)begin
	case(imm_sel)
		I_TYPE: imm_out = {{20{instr[31]}}, instr[31:20]};//calculate with immidiate
		S_TYPE: imm_out = {{20{instr[31]}}, instr[31:25], instr[11:7]};//store
		B_TYPE: imm_out = {{20{instr[31]}}, instr[7],
                             instr[30:25], instr[11:8], 1'b0};
		J_TYPE: imm_out = {{12{instr[31]}}, instr[19:12], 
									  instr[20], instr[30:21],1'b0};


		default:
            imm_out = 32'b0;
	endcase
end
	

endmodule