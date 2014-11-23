import types_pkg::*;

module control_main(
	input opcode_t 		opcode,
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

			LW:

			SW:

			BLT:

			BGT:

			BE:

			JMP:

			HALT: 

			default: 			// Exception
		endcase
	end
endmodule