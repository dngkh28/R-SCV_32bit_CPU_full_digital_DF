module alu(
input [31:0] a,
input	[31:0] b,
input [3:0] alu_control,
output reg [31:0] result,
output reg zero
);
always @(*)
begin
	case (alu_control)
		4'b0000 : result = a&b;
		4'b0001 : result = a|b;
		4'b0010 : result = a+b;
		4'b0100 : result = a-b;
		4'b1000 : begin
			if(a<b)
				result = 1;
			else 
				result = 0;
		end
		4'b0011 : result = a<<b;
		4'b0101 : result = a>>b;
		4'b0110 : result = (a<b) ? 1 : 0;
		4'b0111 : result = a^b;
		default : result = 0;
	endcase
	if(result == 0)
		zero =1;
	else zero =0;
end
endmodule