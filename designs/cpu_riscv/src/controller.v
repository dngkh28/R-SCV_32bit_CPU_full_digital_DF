module controller(
input [31:0]instr,
input beq,// = flag
input brlt, // < flag
output reg [2:0]imm_sel,//Connect with funct3 : 000(I_TYPE) , 001(S_TYPE)
output reg [3:0]alucontrol,
output reg reg_we,//reg_file
output reg b_sel,//mux B
output reg a_sel,
output reg [1:0]pc_sel,
output reg mem_we,//0 : read, 1 : write
output reg [1:0]wb_sel, //00 : memdata , 01 : aluresult , 10 : PC+4
output reg [1:0]rw_type, //00 : byte, 01 : hw, 10 : w;
output reg BrUn

);
localparam I_TYPE = 3'b000;
localparam S_TYPE = 3'b001;
localparam B_TYPE = 3'b010;
localparam J_TYPE = 3'b100;
always @(*)begin
    imm_sel       = 0;
    alucontrol    = 0;
    reg_we 			= 0;
    b_sel         = 0;
    mem_we        = 0;
    wb_sel        = 1;
    rw_type       = 0;
	 a_sel         = 0;
	 pc_sel     	= 0;	
	 BrUn       	= 0;
	case(instr[6:0])
		//R-type
		7'b011_0011:
		begin
			reg_we = 1;
			a_sel  = 0;
			b_sel  = 0;
			wb_sel = 2'b01;
			mem_we =	0;
			pc_sel = 2'b0;
			case(instr[14:12])
				3'b111 : alucontrol = 4'b0000;//AND
				3'b110 : alucontrol = 4'b0001;//ORR
				3'b000 : begin
				if(instr[31:25]== 7'b0000000 )alucontrol = 4'b0010;// ADD
						else if (instr[31:25] ==7'b0100000)alucontrol = 4'b0100;//SUB
				end
				3'b011 : alucontrol = 4'b1000;//SLTU
				3'b001 : alucontrol = 4'b0011;//SLL
				3'b101 : alucontrol = 4'b0101;//SRL
				3'b010 : alucontrol = 4'b0110;//SLT
				3'b100 : alucontrol = 4'b0111;//XOR
			endcase 
		end
		
		//I-type
		7'b001_0011: //calculate with I
		begin
			reg_we = 1;
			imm_sel = I_TYPE;
			b_sel = 1;
			a_sel = 0;
			pc_sel = 2'b0;
			mem_we = 0;
			wb_sel = 2'b01;
			case(instr[14:12])
				3'b111 : alucontrol = 4'b0000;//AND
				3'b110 : alucontrol = 4'b0001;//ORR
				3'b000 : alucontrol = 4'b0010;// ADD
				3'b011 : alucontrol = 4'b1000;//SLTU
				3'b001 : alucontrol = 4'b0011;//SLL
				3'b101 : alucontrol = 4'b0101;//SRL
				3'b100 : alucontrol = 4'b0111;//XOR			
			endcase
		end
		
		7'b000_0011: //load 
		begin
			wb_sel = 2'b00;
			reg_we = 1;
			b_sel = 1;
			a_sel = 0;
			pc_sel = 2'b0;
			mem_we = 0;
			alucontrol = 4'b0010;
			imm_sel = I_TYPE;
			case(instr[14:12])
				3'b000 ://byte 
					begin 
						rw_type = 2'b00; //byte
					end
				3'b001 : //Half_word
					begin 
						rw_type = 2'b01; //half_word
					end
				3'b010 : //Word
					begin 

						rw_type = 2'b10; //word
					end
				default : ;
				
			endcase
		end
		//S_TYPE
		7'b010_0011: //store
		begin
			reg_we = 0;
			b_sel= 1;
			a_sel = 0;
			pc_sel = 2'b0;
			mem_we = 1;
			alucontrol = 4'b0010;
			imm_sel = S_TYPE;
			case(instr[14:12])
				3'b000 : begin
					rw_type = 2'b00;//byte
				end
				3'b001 : begin
					rw_type = 2'b01;//half_word
				end
				3'b010 : begin
					rw_type = 2'b10;//word
				end
				default :;
			endcase
		end
		//B_TYPE
		7'b1100011 : begin
		reg_we     = 0;
		b_sel      = 1;
      a_sel      = 1;
		mem_we 	  = 0;
		alucontrol = 4'b0010;
      imm_sel     = B_TYPE;
		
      case(instr[14:12])
          3'b000 : begin // BEQ
              BrUn   = 0;
              pc_sel = (beq == 1) ? 2'b01 : 2'b00 ;
          end
          3'b001 : begin // BNE
              BrUn   = 0;
              pc_sel = (beq == 0) ? 2'b01 : 2'b00 ;
          end
          3'b100 : begin // BLT (signed)
              BrUn   = 0;
              pc_sel = (brlt == 1 ) ? 2'b01 : 2'b00;
          end
          3'b101 : begin // BGE (signed)
              BrUn   = 0;
              pc_sel = (brlt == 0) ? 2'b01 : 2'b00;
          end
          3'b110 : begin // BLTU (unsigned)
              BrUn   = 1;
              pc_sel = (brlt == 1) ? 2'b01 : 2'b00;
          end
          3'b111 : begin // BGEU (unsigned)
              BrUn   = 1;
              pc_sel = (brlt == 0) ? 2'b01 : 2'b00;
          end
          default : begin
              BrUn   = 0;
              pc_sel = 2'b0;
          end
      endcase
		end
		//J_TYPE :JAL
		7'b1101111 : begin
			reg_we		= 1;
			b_sel			= 1;
			a_sel			= 1;
			pc_sel		= 2'b01;
			wb_sel		= 2'b10;
			mem_we		= 0;
			alucontrol 	= 4'b0010;
			imm_sel     = J_TYPE;
		
		end
		//I_TYPE :JALR
		7'b1100111 : begin
			if(instr[14:12] == 3'b000) begin
				reg_we     = 1;
				b_sel      = 1;
				a_sel      = 0;
				pc_sel     = 2'b10;
				wb_sel     = 2'b10; // PC+4
				mem_we     = 0;
				alucontrol = 4'b0010; // ADD
				imm_sel    = I_TYPE;
			end
		end
		default: ;
	endcase
	
	
end
endmodule