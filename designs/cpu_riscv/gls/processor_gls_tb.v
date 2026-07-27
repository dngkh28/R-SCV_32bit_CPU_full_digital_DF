`timescale 1ns/1ps
// ============================================================================
// GATE-LEVEL SIMULATION (GLS) EQUIVALENCE CHECK
// So sanh song song: RTL (processor) vs Gate-level netlist sau Synthesis
// (processor_gate, tu 02-yosys-synthesis/processor.nl.v, dong bo voi RTL hien tai)
// Dung lai kich ban kich thich (clock/reset) tu processor_tb.v goc.
// ============================================================================

module processor_gls_tb();

    reg clk;
    reg reset;
    wire zero_rtl;
    wire zero_gate;

    integer error_count = 0;
    integer cycle_count = 0;

    wire [31:0] gate_pc, gate_x4, gate_x7;
    assign gate_pc = {dut_gate.\dp.ifu.PC[31] , dut_gate.\dp.ifu.PC[30] , dut_gate.\dp.ifu.PC[29] , dut_gate.\dp.ifu.PC[28] , dut_gate.\dp.ifu.PC[27] , dut_gate.\dp.ifu.PC[26] , dut_gate.\dp.ifu.PC[25] , dut_gate.\dp.ifu.PC[24] , dut_gate.\dp.ifu.PC[23] , dut_gate.\dp.ifu.PC[22] , dut_gate.\dp.ifu.PC[21] , dut_gate.\dp.ifu.PC[20] , dut_gate.\dp.ifu.PC[19] , dut_gate.\dp.ifu.PC[18] , dut_gate.\dp.ifu.PC[17] , dut_gate.\dp.ifu.PC[16] , dut_gate.\dp.ifu.PC[15] , dut_gate.\dp.ifu.PC[14] , dut_gate.\dp.ifu.PC[13] , dut_gate.\dp.ifu.PC[12] , dut_gate.\dp.ifu.PC[11] , dut_gate.\dp.ifu.PC[10] , dut_gate.\dp.ifu.PC[9] , dut_gate.\dp.ifu.PC[8] , dut_gate.\dp.ifu.PC[7] , dut_gate.\dp.ifu.PC[6] , dut_gate.\dp.ifu.PC[5] , dut_gate.\dp.ifu.PC[4] , dut_gate.\dp.ifu.PC[3] , dut_gate.\dp.ifu.PC[2] , dut_gate.\dp.ifu.PC[1] , dut_gate.\dp.ifu.PC[0] };
    assign gate_x4 = {dut_gate.\dp.rf.mem_reg[4][31] , dut_gate.\dp.rf.mem_reg[4][30] , dut_gate.\dp.rf.mem_reg[4][29] , dut_gate.\dp.rf.mem_reg[4][28] , dut_gate.\dp.rf.mem_reg[4][27] , dut_gate.\dp.rf.mem_reg[4][26] , dut_gate.\dp.rf.mem_reg[4][25] , dut_gate.\dp.rf.mem_reg[4][24] , dut_gate.\dp.rf.mem_reg[4][23] , dut_gate.\dp.rf.mem_reg[4][22] , dut_gate.\dp.rf.mem_reg[4][21] , dut_gate.\dp.rf.mem_reg[4][20] , dut_gate.\dp.rf.mem_reg[4][19] , dut_gate.\dp.rf.mem_reg[4][18] , dut_gate.\dp.rf.mem_reg[4][17] , dut_gate.\dp.rf.mem_reg[4][16] , dut_gate.\dp.rf.mem_reg[4][15] , dut_gate.\dp.rf.mem_reg[4][14] , dut_gate.\dp.rf.mem_reg[4][13] , dut_gate.\dp.rf.mem_reg[4][12] , dut_gate.\dp.rf.mem_reg[4][11] , dut_gate.\dp.rf.mem_reg[4][10] , dut_gate.\dp.rf.mem_reg[4][9] , dut_gate.\dp.rf.mem_reg[4][8] , dut_gate.\dp.rf.mem_reg[4][7] , dut_gate.\dp.rf.mem_reg[4][6] , dut_gate.\dp.rf.mem_reg[4][5] , dut_gate.\dp.rf.mem_reg[4][4] , dut_gate.\dp.rf.mem_reg[4][3] , dut_gate.\dp.rf.mem_reg[4][2] , dut_gate.\dp.rf.mem_reg[4][1] , dut_gate.\dp.rf.mem_reg[4][0] };
    assign gate_x7 = {dut_gate.\dp.rf.mem_reg[7][31] , dut_gate.\dp.rf.mem_reg[7][30] , dut_gate.\dp.rf.mem_reg[7][29] , dut_gate.\dp.rf.mem_reg[7][28] , dut_gate.\dp.rf.mem_reg[7][27] , dut_gate.\dp.rf.mem_reg[7][26] , dut_gate.\dp.rf.mem_reg[7][25] , dut_gate.\dp.rf.mem_reg[7][24] , dut_gate.\dp.rf.mem_reg[7][23] , dut_gate.\dp.rf.mem_reg[7][22] , dut_gate.\dp.rf.mem_reg[7][21] , dut_gate.\dp.rf.mem_reg[7][20] , dut_gate.\dp.rf.mem_reg[7][19] , dut_gate.\dp.rf.mem_reg[7][18] , dut_gate.\dp.rf.mem_reg[7][17] , dut_gate.\dp.rf.mem_reg[7][16] , dut_gate.\dp.rf.mem_reg[7][15] , dut_gate.\dp.rf.mem_reg[7][14] , dut_gate.\dp.rf.mem_reg[7][13] , dut_gate.\dp.rf.mem_reg[7][12] , dut_gate.\dp.rf.mem_reg[7][11] , dut_gate.\dp.rf.mem_reg[7][10] , dut_gate.\dp.rf.mem_reg[7][9] , dut_gate.\dp.rf.mem_reg[7][8] , dut_gate.\dp.rf.mem_reg[7][7] , dut_gate.\dp.rf.mem_reg[7][6] , dut_gate.\dp.rf.mem_reg[7][5] , dut_gate.\dp.rf.mem_reg[7][4] , dut_gate.\dp.rf.mem_reg[7][3] , dut_gate.\dp.rf.mem_reg[7][2] , dut_gate.\dp.rf.mem_reg[7][1] , dut_gate.\dp.rf.mem_reg[7][0] };

    // RTL (gold)
    processor dut_rtl (
        .clk(clk),
        .reset(reset),
        .zero(zero_rtl)
    );

    // Gate-level netlist sau synthesis (gate)
    processor_gate dut_gate (
        .clk(clk),
        .reset(reset),
        .zero(zero_gate)
    );

    // Chu ky clock keo dai (100ns) de logic to hop gate-level (co UNIT_DELAY tren
    // moi UDP/gate khi mo phong voi -DFUNCTIONAL) co du thoi gian on dinh truoc
    // khi lay mau, tranh nham glitch tam thoi voi loi chuc nang thuc su.
    initial begin
        clk = 0;
        forever #50 clk = ~clk;
    end

    initial begin
        // $dumpfile("gls_compare.vcd");
        // $dumpvars(0, processor_gls_tb);

        $display("==========================================================================");
        $display("     GLS EQUIVALENCE CHECK: RTL (processor) vs GATE (processor_gate)      ");
        $display("==========================================================================");

        reset = 1;
        #200;
        reset = 0;
        #2000; // du dai de chay het chuong trinh test (ADDI/SW/LW/BEQ/SUB/JAL/JALR)

        $display("==========================================================================");
        if (error_count == 0) begin
            $display("    KET QUA: >>> RTL va GATE-LEVEL NETLIST TUONG DUONG (PASSED) <<< (%0d chu ky da kiem tra)", cycle_count);
        end else begin
            $display("    KET QUA: >>> PHAT HIEN SAI KHAC GIUA RTL VA GATE (FAILED) <<< (%0d/%0d chu ky sai)", error_count, cycle_count);
        end
        $display("==========================================================================");
        $finish;
    end

    // So sanh 'zero' moi canh len clock, sau khi het reset
    always @(negedge clk) begin
        if (!reset) begin
            cycle_count = cycle_count + 1;
            if (zero_rtl !== zero_gate) begin
                $display("[FAIL] t=%0t ns | cycle=%0d | zero_rtl=%b  zero_gate=%b  <-- KHAC NHAU",
                         $time, cycle_count, zero_rtl, zero_gate);
                error_count = error_count + 1;
            end else begin
                $display("[PASS] t=%0t ns | cycle=%0d | zero_rtl=%b  zero_gate=%b",
                         $time, cycle_count, zero_rtl, zero_gate);
            end
            $display("        PC   : rtl=%h gate=%h",
                     dut_rtl.dp.ifu.PC, gate_pc);
            $display("        instr: rtl=%h",
                     dut_rtl.dp.instr);
            $display("        x4   : rtl=%h gate=%h   x6(RTL only): rtl=%h   x7: rtl=%h gate=%h",
                     dut_rtl.dp.rf.mem_reg[4], gate_x4,
                     dut_rtl.dp.rf.mem_reg[6],
                     dut_rtl.dp.rf.mem_reg[7], gate_x7);
        end
    end

endmodule
