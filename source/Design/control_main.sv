import types_pkg::*;
import alu_pkg::*;

module control_main(
	input opcode_t 		opcode,
	input control_e		func,
	input wire 			div0,
	input wire 			overflow,

	output logic 		ALUop,
	output logic [1:0]	offset_sel,
	output logic 		mem2r,
	output logic 		memwr,
	output logic 		halt_sys,
	output logic 		reg_wr,
	output logic 		R0_read,
	output logic 		se_imm_a
);

	always_comb begin
		if (div0 || overflow) begin // Exception
			ALUop = 1'b0;
			offset_sel = 2'b00;
			mem2r = 1'b0;
			memwr = 1'b0;
			halt_sys = 1'b1;
			reg_wr = 1'b0;
			R0_read = 1'b0;
			se_imm_a = 1'b0;
		end
		else begin
			case (opcode) 
				ARITHM: begin
					ALUop = 1'b0;
					if((func == ROR)||(func == ROL)||(func == SHL)||(func == SHR))
						offset_sel = 2'b01;
					else
						offset_sel = 2'b00;
					mem2r = 1'b0;
					memwr = 1'b0;
					halt_sys = 1'b0;
					reg_wr = 1'b1;
					R0_read = 1'b0;
					se_imm_a = 1'b1; // Not soooo sure bout this one
				end
				LW: begin
					ALUop = 1'b1;
					offset_sel = 2'b10;
					mem2r = 1'b1;
					memwr = 1'b0;
					halt_sys = 1'b0;
					reg_wr = 1'b1;
					R0_read = 1'b0;
					se_imm_a = 1'b0;
				end
				SW: begin
					ALUop = 1'b1;
					offset_sel = 2'b10;
					mem2r = 1'b0;
					memwr = 1'b1;
					halt_sys = 1'b0;
					reg_wr = 1'b0;
					R0_read = 1'b0;
					se_imm_a = 1'b0;
				end
				BLT: begin
					ALUop = 1'b0;
					offset_sel = 2'b10;
					mem2r = 1'b0;
					memwr = 1'b0;
					halt_sys = 1'b0;
					reg_wr = 1'b0;
					R0_read = 1'b1;
					se_imm_a = 1'b1;
				end
				BGT: begin
					ALUop = 1'b0;
					offset_sel = 2'b10;
					mem2r = 1'b0;
					memwr = 1'b0;
					halt_sys = 1'b0;
					reg_wr = 1'b0;
					R0_read = 1'b1;
					se_imm_a = 1'b1;
				end
				BE: begin
					ALUop = 1'b0;
					offset_sel = 2'b10;
					mem2r = 1'b0;
					memwr = 1'b0;
					halt_sys = 1'b0;
					reg_wr = 1'b0;
					R0_read = 1'b1;
					se_imm_a = 1'b1;
				end
				JMP: begin
					ALUop = 1'b0;
					offset_sel = 2'b11;
					mem2r = 1'b0;
					memwr = 1'b0;
					halt_sys = 1'b0;
					reg_wr = 1'b0;
					R0_read = 1'b0;
					se_imm_a = 1'b1;
				end
				HALT: begin
					ALUop = 1'b0;
					offset_sel = 2'b00;
					mem2r = 1'b0;
					memwr = 1'b0;
					halt_sys = 1'b1;
					reg_wr = 1'b0;
					R0_read = 1'b0;
					se_imm_a = 1'b1;
				end
	
				default: begin		// Exception
					ALUop = 1'b0;
					offset_sel = 2'b00;
					mem2r = 1'b0;
					memwr = 1'b0;
					halt_sys = 1'b1;
					reg_wr = 1'b0;
					R0_read = 1'b0;
					se_imm_a = 1'b0;
				end
			endcase
		end // if(exception)
	end
endmodule