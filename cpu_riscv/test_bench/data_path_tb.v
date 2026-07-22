module data_path_tb();
   
        // --------------------------------------------------------
        // Tín hiệu kết nối DUT
        // --------------------------------------------------------
     reg        clk, reset;
     reg        pc_sel;
     reg        reg_we;
     reg [2:0]  imm_sel;
     reg        BrUn;
     reg        b_sel;
     reg        a_sel;
     reg [3:0]  alu_control;
     reg        mem_we;
     reg [1:0]  rw_type;
     reg [1:0]  wb_sel;

     wire [31:0] instr;
     wire        beq, brlt;
     wire        zero_flag;

        // --------------------------------------------------------
        // DUT
        // --------------------------------------------------------
        data_path dut(
            .pc_sel     (pc_sel),
            .instr      (instr),
            .reg_we     (reg_we),
            .imm_sel    (imm_sel),
            .BrUn       (BrUn),
            .beq        (beq),
            .brlt       (brlt),
            .b_sel      (b_sel),
            .a_sel      (a_sel),
            .alu_control(alu_control),
            .mem_we     (mem_we),
            .rw_type    (rw_type),
            .wb_sel     (wb_sel),
            .clk        (clk),
            .reset      (reset),
            .zero_flag  (zero_flag)
       );
		 initial begin 
			clk = 0;
			forever #5 clk =~clk;
		 end
			// Monitor
      initial begin
          $monitor("t=%0t | instr=%h | beq=%b brlt=%b zero=%b | pc_sel=%b",
                    $time, instr, beq, brlt, zero_flag, pc_sel);
      end

      initial begin
          // Khởi tạo tất cả tín hiệu
          reset      = 1;
          pc_sel     = 0;
          reg_we     = 0;
          imm_sel    = 3'b000;
          BrUn       = 0;   // FIX: khởi tạo BrUn
          b_sel      = 0;
          a_sel      = 0;
          alu_control = 4'b0010;
          mem_we     = 0;
          rw_type    = 2'b00;  // FIX: khởi tạo rw_type
          wb_sel     = 2'b01;
          #10;

			//////////////////////
			// ADD x1 = x0 +5
			//////////////////////
			reset = 0;
			pc_sel = 0;
			imm_sel = 3'b000;
			reg_we = 1;
			b_sel = 1;
			a_sel =0;
			alu_control = 4'b0010;
			mem_we = 0;
			wb_sel = 2'b01;
			rw_type = 2'b00;
			#10;
			//////////////////////
			// sw x1 , 0(x0) 
			//////////////////////
			reset  = 0 ;
			pc_sel = 0;
			imm_sel = 3'b001;
			reg_we = 0;
			b_sel = 1;
			a_sel = 0;
			alu_control = 4'b0010;
			rw_type = 2'b10;
			mem_we = 1;
			wb_sel = 2'b01;
			#10;
			//////////////////////
			// lw x2 , 0(x0) 
			//////////////////////
			reset  = 0 ;
			pc_sel = 0;
			imm_sel = 3'b000;
			reg_we = 1;
			b_sel = 1;
			a_sel = 0;
			alu_control = 4'b0010;
			rw_type = 2'b10;
			mem_we = 0;
			wb_sel = 2'b00;
			#10;
			
			//////////////////////
			// beq x1, x2, +8 
			//////////////////////
			reset  = 0 ;
			imm_sel = 3'b010;
			reg_we = 0;
			b_sel = 1;
			a_sel = 1;
			alu_control = 4'b0010;
			mem_we = 0;
			wb_sel = 2'b01;
			#1
			pc_sel = beq;
			#9;
			// ADD tại PC=16 bị bỏ qua do BEQ branch taken → xóa chu kỳ ADD
			//////////////////////
			// sub x3, x1, x2   (PC=20, branch taken từ BEQ)
			// x3 = 5 - 5 = 0
			//////////////////////
			reset  = 0 ;
			pc_sel = 0;
			imm_sel = 3'b000;
			reg_we = 1;
			b_sel = 0;
			a_sel = 0;
			alu_control = 4'b0100;
			mem_we = 0;
			rw_type = 2'b00;
			wb_sel = 2'b01;
			#10;
			$finish;
		 end
  
       
   endmodule
