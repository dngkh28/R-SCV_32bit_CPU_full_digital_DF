`timescale 1ns/1ps
module test_isolate();
    reg clk, reset;
    wire zero_rtl, zero_gate;
    processor dut_rtl(.clk(clk), .reset(reset), .zero(zero_rtl));
    processor_gate dut_gate(.clk(clk), .reset(reset), .zero(zero_gate));
    initial begin clk=0; forever #50 clk=~clk; end
    initial begin
        $monitor("t=%0t PC_rtl=%h zero_rtl=%b zero_gate=%b", $time, dut_rtl.dp.ifu.PC, zero_rtl, zero_gate);
        reset=1; #200; reset=0; #500; $finish;
    end
endmodule
