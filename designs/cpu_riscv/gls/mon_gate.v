`timescale 1ns/1ps
module mon_gate_tb();
    reg clk, reset;
    wire zero;
    processor_gate dut(.clk(clk), .reset(reset), .zero(zero));
    initial begin clk=0; forever #50 clk=~clk; end
    initial begin
        $monitor("t=%0t zero=%b reset=%b", $time, zero, reset);
        reset=1; #200; reset=0; #2000; $finish;
    end
endmodule
