module alu_tb();

reg [31:0] A,B;
reg [3:0] alu_control;

wire [31:0] alu_result;
wire zero;

alu uut(
    .a(A),
    .b(B),
    .alu_control(alu_control),
    .result(alu_result),
    .zero(zero)
);

initial begin
	A = 5; B =2; alu_control = 4'b0000;
	#10;
	$display("AND: A=%d B=%d result=%d zero=%b", A,B,alu_result,zero);
	
	alu_control = 4'b0001;
	#10;
	$display("OR : A=%d B=%d result=%d zero=%d", A,B,alu_result,zero);
		
	alu_control = 4'b0010;
	#10;
	$display("ADD : A=%d B=%d result=%d zero=%d", A,B,alu_result,zero);
	
	alu_control = 4'b0100;
	#10;
	$display("SUB : A=%d B=%d result=%d zero=%d", A,B,alu_result,zero);
	
	alu_control = 4'b1000;
	#10;
	$display("SLT : A=%d B=%d result=%d zero=%d", A,B,alu_result,zero);
	
	alu_control = 4'b0011;
	#10;
	$display("SLL : A=%d B=%d result=%d zero=%d", A,B,alu_result,zero);
	
	alu_control = 4'b0101;
	#10;
	$display("SRL : A=%d B=%d result=%d zero=%d", A,B,alu_result,zero);
	
	alu_control = 4'b0110;
	#10;
	$display("MUL : A=%d B=%d result=%d zero=%d", A,B,alu_result,zero);
	
	alu_control = 4'b0111;
	#10;
	$display("XOR : A=%d B=%d result=%d zero=%d", A,B,alu_result,zero);
end

endmodule