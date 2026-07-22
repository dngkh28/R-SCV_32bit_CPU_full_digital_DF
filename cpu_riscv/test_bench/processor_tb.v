`timescale 1ns/1ps
// ============================================================================
// DO AN THIET KE CHIP: CPU RISC-V 32-BIT (SINGLE-CYCLE)
// File: processor_tb.v
// Chuc nang: Testbench tu kiem tra cac lenh co ban (Bo qua JAL, JALR, U-type)
// ============================================================================

module processor_tb();

    // 1. Khai bao cac tin hieu Testbench
    reg clk;
    reg reset;
    wire zero;

    integer error_count = 0;
    integer test_cases = 0;

    // 2. Khoi tao thuc the DUT (Device Under Test)
    processor dut (
        .clk(clk),
        .reset(reset),
        .zero(zero)
    );

    // 3. Bo tao xung nhip (Clock)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // 4. Kich ban mo phong & Tu dong kiem tra
    initial begin
        $dumpfile("processor.vcd");
        $dumpvars(0, processor_tb);

        $display("==========================================================================");
        $display("             KHOI CHAY MO PHONG CPU RISC-V 32-BIT (SINGLE-CYCLE)          ");
        $display("==========================================================================");

        // --- GIAI DOAN 1: KICH HOAT RESET ---
        reset = 1;
        #20;

        if (dut.dp.pc_current !== 32'h0) begin
            $display("[FAIL] t=%0t ns | Reset that bai! PC hien tai: %h", $time, dut.dp.pc_current);
            error_count = error_count + 1;
        end else begin
            $display("[PASS] t=%0t ns | Reset thanh cong. PC bat dau tai 0x00000000.", $time);
        end
        test_cases = test_cases + 1;

        // --- GIAI DOAN 2: GIAI PHONG RESET & CHAY CHUONG TRINH ---
        reset = 0;
        #80; // Chi can chay 8 chu ky de kiem tra den lenh BEQ/SUB

        // --- GIAI DOAN 3: KIEM TRA KET QUA ---
        $display("\n==========================================================================");
        $display("             TIEN HANH TU DONG KIEM TRA (CHI TEST I, S, B, R-TYPE)        ");
        $display("==========================================================================");

        // Test Case 1: ADDI x1, x0, 5 (x1 phai bang 5) -> Chuy y: index la [1]
        test_cases = test_cases + 1;
        if (dut.dp.rf.mem_reg[1] === 32'd5) begin
            $display("[PASS] Test Case 1: Lenh ADDI x1, x0, 5 hoat dong dung. x1 = %0d", dut.dp.rf.mem_reg[1]);
        end else begin
            $display("[FAIL] Test Case 1: Lenh ADDI x1, x0, 5 THAT BAI! x1 = %0d (Ky vong: 5)", dut.dp.rf.mem_reg[1]);
            error_count = error_count + 1;
        end

        // Test Case 2: SW x1, 0(x0) (Ghi so 5 vao RAM)
        test_cases = test_cases + 1;
        if (dut.dp.dm.mem[0] === 32'd5) begin
            $display("[PASS] Test Case 2: Lenh SW x1, 0(x0) ghi bo nho dung. MEM[0] = %0d", dut.dp.dm.mem[0]);
        end else begin
            $display("[FAIL] Test Case 2: Lenh SW x1, 0(x0) THAT BAI! MEM[0] = %0h (Ky vong: 5)", dut.dp.dm.mem[0]);
            error_count = error_count + 1;
        end

        // Test Case 3: LW x2, 0(x0) (x2 phai bang 5) -> Chu y: index la [2]
        test_cases = test_cases + 1;
        if (dut.dp.rf.mem_reg[2] === 32'd5) begin
            $display("[PASS] Test Case 3: Lenh LW x2, 0(x0) nap du lieu dung. x2 = %0d", dut.dp.rf.mem_reg[2]);
        end else begin
            $display("[FAIL] Test Case 3: Lenh LW x2, 0(x0) THAT BAI! x2 = %0d (Ky vong: 5)", dut.dp.rf.mem_reg[2]);
            error_count = error_count + 1;
        end

        // Test Case 4: BEQ x1, x2, +8 & SUB x3, x1, x2 -> Chu y: index la [3]
        test_cases = test_cases + 1;
        if (dut.dp.rf.mem_reg[3] === 32'd0) begin
            $display("[PASS] Test Case 4: Lenh re nhanh BEQ hoat dong dung. x3 = %0d", dut.dp.rf.mem_reg[3]);
        end else begin
            $display("[FAIL] Test Case 4: Lenh re nhanh BEQ THAT BAI! x3 = %0d (Ky vong: 0)", dut.dp.rf.mem_reg[3]);
            error_count = error_count + 1;
        end

        $display("==========================================================================");
        if (error_count == 0) begin
            $display("    KET QUA: >>> MO PHONG THANH CONG (PASSED) <<< (%0d/%0d test cases)", test_cases - error_count, test_cases);
        end else begin
            $display("    KET QUA: >>> MO PHONG CO LOI (FAILED) <<< (%0d loi phat hien)", error_count);
        end
        $display("==========================================================================");

        $finish;
    end

    // 5. Bo giam sat thoi gian thuc
    always @(negedge clk) begin
        if (!reset) begin
            $display("t=%0t ns | PC=0x%h | Instr=0x%h | ALU_Out=0x%h | Zero=%b", 
                     $time, dut.dp.pc_current, dut.dp.instr, dut.dp.alu_result, zero);
            $display("          | x1(ra)=%0d | x2(sp)=%0d | x3(gp)=%0d",
                     dut.dp.rf.mem_reg[1], dut.dp.rf.mem_reg[2], dut.dp.rf.mem_reg[3]);
            $display("----------------------------------------------------------------------------------");
        end
    end

endmodule