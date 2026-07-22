module IFU_tb();
reg clk, reset;
reg [1:0] pc_sel;
wire [31:0] instruction_code;
wire [31:0] pc_next, pc_current;
reg [31:0] pc_bran, pc_jalr;

IFU U1 (
    .clk(clk),
    .reset(reset),
    .pc_sel(pc_sel),
    .pc_bran(pc_bran),
    .pc_jalr(pc_jalr),
    .instruction_code(instruction_code),
    .pc_next(pc_next),
    .pc_current(pc_current)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    // Reset
    reset = 1;
    pc_sel = 2'b00;
    pc_bran = 32'd0;
    pc_jalr = 32'd0;
    #10;

    // Sequential: PC + 4
    reset = 0;
    pc_sel = 2'b00;
    #40;

    // Branch
    pc_bran = 32'd8;
    pc_sel = 2'b01;
    #20;

    // JALR
    pc_jalr = 32'd20;
    pc_sel = 2'b10;
    #20;

    // Back to sequential
    pc_sel = 2'b00;
    #20;

    $stop;
end

initial begin
    $monitor("Time=%0t reset=%b pc_sel=%b pc_current=%h pc_next=%h instr=%h",
             $time, reset, pc_sel, pc_current, pc_next, instruction_code);
end

endmodule
