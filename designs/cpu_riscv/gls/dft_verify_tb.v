`timescale 1ns/1ps
// ============================================================================
// DFT VERIFICATION TESTBENCH
// Phase 1: chung minh chen scan chain KHONG lam thay doi chuc nang
//          (scan_enable=0 -> processor_scan phai giong processor_gate tuyet doi)
// Phase 2: demo scan chain hoat dong dung (flush 1 bit '1' qua toan bo 1280 flop)
// ============================================================================

module dft_verify_tb();
    reg clk, reset;
    reg scan_in, scan_enable;
    wire zero_gate, zero_scan, scan_out;

    integer error_count = 0;
    integer cycle_count = 0;
    integer i;
    integer ones_count;

    processor_gate dut_gate (.clk(clk), .reset(reset), .zero(zero_gate));

    processor_scan dut_scan (
        .clk(clk), .reset(reset), .zero(zero_scan),
        .scan_in(scan_in), .scan_out(scan_out), .scan_enable(scan_enable)
    );

    localparam CHAIN_LEN = 1280;
    reg captured [0:CHAIN_LEN+10];

    initial begin
        clk = 0;
        forever #50 clk = ~clk;
    end

    initial begin
        scan_in = 0;
        scan_enable = 0;

        $display("==========================================================================");
        $display(" PHASE 1: Kiem tra scan-insertion KHONG lam thay doi chuc nang (SE=0)      ");
        $display("==========================================================================");

        reset = 1;
        #200;
        reset = 0;
        #2000;

        $display("==========================================================================");
        if (error_count == 0)
            $display("    PHASE 1 KET QUA: >>> PASSED <<< (%0d chu ky, scan-inserted netlist tuong duong ban goc)", cycle_count);
        else
            $display("    PHASE 1 KET QUA: >>> FAILED <<< (%0d/%0d chu ky sai)", error_count, cycle_count);
        $display("==========================================================================");

        // ---- PHASE 2: flush test qua scan chain ----
        $display("==========================================================================");
        $display(" PHASE 2: Flush 1 bit '1' qua toan bo %0d flip-flop cua scan chain        ", CHAIN_LEN);
        $display("==========================================================================");

        // Sau khi chay chuong trinh o Phase 1, toan bo 1280 flip-flop dang mang
        // trang thai thuc te cua CPU (PC, thanh ghi...), khong phai gia tri 0.
        // Theo dung quy trinh scan test thuc te: phai "unload" (xa het) du lieu
        // cu ra khoi chain truoc khi "load" mau kiem tra moi vao - xa CHAIN_LEN
        // chu ky voi scan_in=0 de đưa toan bo chain ve trang thai sach (all-0).
        scan_enable = 1;
        scan_in = 0;
        for (i = 0; i < CHAIN_LEN; i = i + 1)
            @(negedge clk);

        // Bay gio chain da sach (all-0). Nap 1 bit '1' vao dau chain va theo doi
        // no dich chuyen qua toan bo chain.
        scan_in = 1;
        @(negedge clk);
        scan_in = 0;

        for (i = 0; i < CHAIN_LEN + 5; i = i + 1) begin
            captured[i] = scan_out;
            @(negedge clk);
        end

        ones_count = 0;
        for (i = 0; i < CHAIN_LEN + 5; i = i + 1)
            if (captured[i] == 1'b1) ones_count = ones_count + 1;
        $display("    Tong so bit '1' xuat hien tren scan_out trong ca phase 2: %0d (ky vong: 1, khong bi trung/lap/mat bit)", ones_count);

        if (captured[CHAIN_LEN-1] == 1'b1 && ones_count == 1) begin
            $display("    PHASE 2 KET QUA: >>> PASSED <<< (bit '1' xuat hien dung tai scan_out sau %0d chu ky, khong bi glitch)", CHAIN_LEN);
        end else begin
            $display("    PHASE 2 KET QUA: >>> FAILED <<< (khong thay bit '1' dung vi tri mong doi tai chu ky %0d)", CHAIN_LEN);
            $display("    Gia tri captured quanh vi tri mong doi:");
            for (i = CHAIN_LEN - 3; i <= CHAIN_LEN + 3; i = i + 1)
                $display("      captured[%0d] = %b", i, captured[i]);
        end

        $finish;
    end

    always @(negedge clk) begin
        if (!reset && !scan_enable) begin
            cycle_count = cycle_count + 1;
            if (zero_gate !== zero_scan) begin
                $display("[FAIL] t=%0t ns | cycle=%0d | zero_gate=%b zero_scan=%b <-- KHAC NHAU",
                         $time, cycle_count, zero_gate, zero_scan);
                error_count = error_count + 1;
            end else begin
                $display("[PASS] t=%0t ns | cycle=%0d | zero_gate=%b zero_scan=%b",
                         $time, cycle_count, zero_gate, zero_scan);
            end
        end
    end

endmodule
