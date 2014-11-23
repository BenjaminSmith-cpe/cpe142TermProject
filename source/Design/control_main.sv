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


		case (opcode)
			ARITHM:
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
				se_imm_a = 1'b1;
			LW:
				ALUop = 1'b1;
				offset_sel = 2'b10;
				mem2r = 1'b1;
				memwr = 1'b0;
				halt_sys = 1'b0;
				reg_wr = 1'b1;
				R0_read = 1'b0;
				se_imm_a = 1'b0;
			SW:
				ALUop = 1'b1;
				offset_sel = 2'b10;
				mem2r = 1'b0;
				memwr = 1'b1;
				halt_sys = 1'b0;
				reg_wr = 1'b0;
				R0_read = 1'b0;
				se_imm_a = 1'b0;
			BLT:
				ALUop = 1'b0;
				offset_sel = 2'b10;
				mem2r = 1'b0;
				memwr = 1'b0;
				halt_sys = 1'b0;
				reg_wr = 1'b0;
				R0_read = 1'b1;
				se_imm_a = 1'b1;
			BGT:
				ALUop = 1'b0;
				offset_sel = 2'b00;
				mem2r = 1'b0;
				memwr = 1'b0;
				halt_sys = 1'b0;
				reg_wr = 1'b1;
				R0_read = 1'b0;
				se_imm_a = 1'b1;
			BE:
				ALUop = 1'b0;
				offset_sel = 2'b00;
				mem2r = 1'b0;
				memwr = 1'b0;
				halt_sys = 1'b0;
				reg_wr = 1'b1;
				R0_read = 1'b0;
				se_imm_a = 1'b1;
			JMP:
				ALUop = 1'b0;
				offset_sel = 2'b00;
				mem2r = 1'b0;
				memwr = 1'b0;
				halt_sys = 1'b0;
				reg_wr = 1'b1;
				R0_read = 1'b0;
				se_imm_a = 1'b1;
			HALT: 
				ALUop = 1'b0;
				offset_sel = 2'b00;
				mem2r = 1'b0;
				memwr = 1'b0;
				halt_sys = 1'b0;
				reg_wr = 1'b1;
				R0_read = 1'b0;
				se_imm_a = 1'b1;

			default: 			// Exception
				ALUop = 1'b0;
				offset_sel = 2'b00;
				mem2r = 1'b0;
				memwr = 1'b0;
				halt_sys = 1'b1;
				reg_wr = 1'b0;
				R0_read = 1'b0;
				se_imm_a = 1'b0;
		endcase
	end
endmodule