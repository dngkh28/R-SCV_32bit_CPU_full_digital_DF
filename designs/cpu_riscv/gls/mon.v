`timescale 1ns/1ps
module mon_tb();
    reg clk, reset;
    wire zero;
    processor dut(.clk(clk), .reset(reset), .zero(zero));
    initial begin clk=0; forever #50 clk=~clk; end
    initial begin
        $monitor("t=%0t PC=%h instr=%h pc_sel=%b reset=%b", $time, dut.dp.ifu.PC, dut.dp.instr, dut.dp.pc_sel, reset);
        reset=1; #200; reset=0; #500; $finish;
    end
endmodule
