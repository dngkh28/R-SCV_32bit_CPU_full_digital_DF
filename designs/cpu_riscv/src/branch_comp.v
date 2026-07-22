module branch_comp(
    input [31:0] a,
    input [31:0] b,
    input BrUn,

    output beq,
    output brlt
);

assign beq = (a == b);

assign brlt =
    BrUn ?
    (a < b) :
    ($signed(a) < $signed(b));

endmodule