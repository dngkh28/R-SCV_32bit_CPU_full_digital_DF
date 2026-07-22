`timescale 1ns/1ps

module data_mem_tb();

reg  [9:0]  addr;
reg         mem_we;
reg  [31:0] w_data;
reg         reset;
reg  [1:0]  rw_type;
reg         clk;

wire [31:0] r_data;


// ========================================
// DUT
// ========================================

data_mem dut(
    .addr(addr),
    .mem_we(mem_we),
    .w_data(w_data),
    .reset(reset),
    .rw_type(rw_type),
    .clk(clk),
    .r_data(r_data)
);


// ========================================
// CLOCK
// ========================================

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end


// ========================================
// MONITOR
// ========================================

initial begin
    $monitor(
        "time=%0t | mem_we=%b | rw_type=%b | addr=%d | w_data=%d | r_data=%d | mem0=%d mem1=%d mem2=%d mem3=%d",
        $time,
        mem_we,
        rw_type,
        addr,
        w_data,
        r_data,
        dut.mem[0],
        dut.mem[1],
        dut.mem[2],
        dut.mem[3]
    );
end


// ========================================
// TEST
// ========================================

initial begin

    // =========================
    // INIT
    // =========================

    addr    = 0;
    mem_we  = 0;
    w_data  = 0;
    reset   = 0;
    rw_type = 0;

    
    // =========================
    // RESET MEMORY
    // =========================

    #2;
    reset = 1;

    #10;
    reset = 0;


    // ==================================================
    // TEST 1 : STORE WORD
    // MEM[0] = 32'h12345678
    // ==================================================

    @(negedge clk);

    mem_we  = 1;
    rw_type = 2'b10; // SW
    addr    = 0;

    w_data  = 32'h12345678;

    @(posedge clk);

    #1;

    $display("AFTER STORE WORD");
    $display("mem0 = %h", dut.mem[0]);
    $display("mem1 = %h", dut.mem[1]);
    $display("mem2 = %h", dut.mem[2]);
    $display("mem3 = %h", dut.mem[3]);


    // ==================================================
    // TEST 2 : LOAD WORD
    // ==================================================

    @(negedge clk);

    mem_we  = 0;
    rw_type = 2'b10;
    addr    = 0;

    #1;

    $display("LOAD WORD r_data = %h", r_data);


    // ==================================================
    // TEST 3 : STORE HALF WORD
    // MEM[4] = 16'hABCD
    // ==================================================

    @(negedge clk);

    mem_we  = 1;
    rw_type = 2'b01; // SH
    addr    = 4;

    w_data  = 32'h0000ABCD;

    @(posedge clk);

    #1;

    $display("AFTER STORE HALF");
    $display("mem4 = %h", dut.mem[4]);
    $display("mem5 = %h", dut.mem[5]);


    // ==================================================
    // TEST 4 : LOAD HALF WORD
    // ==================================================

    @(negedge clk);

    mem_we  = 0;
    rw_type = 2'b01;
    addr    = 4;

    #1;

    $display("LOAD HALF r_data = %h", r_data);


    // ==================================================
    // TEST 5 : STORE BYTE
    // MEM[8] = 8'hAA
    // ==================================================

    @(negedge clk);

    mem_we  = 1;
    rw_type = 2'b00; // SB
    addr    = 8;

    w_data  = 32'h000000AA;

    @(posedge clk);

    #1;

    $display("AFTER STORE BYTE");
    $display("mem8 = %h", dut.mem[8]);


    // ==================================================
    // TEST 6 : LOAD BYTE
    // ==================================================

    @(negedge clk);

    mem_we  = 0;
    rw_type = 2'b00;
    addr    = 8;

    #1;

    $display("LOAD BYTE r_data = %h", r_data);


    // ==================================================
    // FINISH
    // ==================================================

    #20;

    $stop;

end

endmodule