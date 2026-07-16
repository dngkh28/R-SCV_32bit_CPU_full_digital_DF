module mux(
input sel,
input [31:0]b0,
input [31:0]b1,
output [31:0]result
);
assign result = (sel)?b1:b0;
endmodule