module data_path(
//IFU
input [1:0]pc_sel,
output [31:0]instr,
//regfile
input reg_we,
//immgen
input [2:0]imm_sel,
//branch compare
input BrUn,
output beq,
output brlt,
//muxB
input b_sel,
//muxA
input a_sel,
//alu
input [3:0]alu_control,
//data_mem
input mem_we,
input [1:0]rw_type,
//muxWB
input [1:0]wb_sel,
input clk,
input reset,
output zero_flag

);
//IFU
wire [31:0]instr_wire;
wire [31:0]pc_next;
wire [31:0]pc_current;
wire [31:0]pc_jalr;
//regfile
wire [31:0]read_data1;
wire [31:0]read_data2;
//imm_gen
wire [31:0]imm_out;
//muxasel
wire [31:0]muxasel_out;
//muxbsel
wire [31:0]muxbsel_out;
//aluresult
wire [31:0]alu_result;
//mem
wire [31:0]r_data;
//mux wb
wire [31:0]mux_wbout;

IFU ifu( .pc_sel(pc_sel),
			.pc_bran(alu_result),
			.pc_jalr(alu_result),
			.clk(clk),
			.reset(reset),
			.pc_next(pc_next),
			.pc_current(pc_current),
			.instruction_code(instr_wire)
			);
reg_file rf(.rs1(instr_wire[19:15]),
				.rs2(instr_wire[24:20]),
				.rd(instr_wire[11:7]),
				.reg_write(reg_we),
				.write_data(mux_wbout),
				.clk(clk),
				.reset(reset),
				.read_data1(read_data1),
				.read_data2(read_data2)
				);
IMM_GEN geni(.instr(instr_wire),
				 .imm_sel(imm_sel),
				 .imm_out(imm_out)
				);
mux muxasel(.sel(a_sel),
				.b0(read_data1),
				.b1(pc_current),
				.result(muxasel_out)
				);
mux muxbsel(.sel(b_sel),
				.b0(read_data2),
				.b1(imm_out),
				.result(muxbsel_out)
				);
branch_comp brc(.a(read_data1),
					 .b(read_data2),
					 .BrUn(BrUn),
					 .beq(beq),
					 .brlt(brlt)
					 );
mux3 muxwb(.sel(wb_sel),
			 .b0(r_data),
			 .b1(alu_result),
			 .b2(pc_next),
			 .result(mux_wbout)
			);
alu A(.a(muxasel_out),
		.b(muxbsel_out),
		.alu_control(alu_control),
		.result(alu_result),
		.zero(zero_flag)
		);
data_mem dm(.addr(alu_result[6:0]),
			.mem_we(mem_we),
			.w_data(read_data2),
			.reset(reset),
			.rw_type(rw_type),
			.clk(clk),
			.r_data(r_data)
		);
assign instr = instr_wire;		

endmodule