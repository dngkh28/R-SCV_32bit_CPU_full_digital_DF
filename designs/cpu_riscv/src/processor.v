module processor(clk,reset,zero);
input clk;
input reset;
output zero;

wire [1:0]pc_sel;
wire [31:0]instr;
wire reg_we;
wire [2:0]imm_sel;
wire BrUn;
wire beq;
wire brlt;
wire b_sel;
wire a_sel;
wire [3:0]alu_control;
wire mem_we;
wire [1:0]rw_type;
wire [1:0]wb_sel;


data_path dp(.pc_sel(pc_sel),
				 .instr(instr)	,
				 .reg_we(reg_we),
				 .imm_sel(imm_sel),
				 .BrUn(BrUn),
				 .beq(beq),
				 .brlt(brlt),
				 .b_sel(b_sel),
				 .a_sel(a_sel),
				 .alu_control(alu_control),
				 .mem_we(mem_we),
				 .rw_type(rw_type),
				 .wb_sel(wb_sel),
				 .clk(clk),
				 .reset(reset),
				 .zero_flag(zero)
);
controller con(.instr(instr),
					.beq(beq),
					.brlt(brlt),
					.imm_sel(imm_sel),
					.alucontrol(alu_control),
					.reg_we(reg_we),
					.a_sel(a_sel),
					.b_sel(b_sel),
					.pc_sel(pc_sel),
					.mem_we(mem_we),
					.wb_sel(wb_sel),
					.rw_type(rw_type),
					.BrUn(BrUn));

endmodule