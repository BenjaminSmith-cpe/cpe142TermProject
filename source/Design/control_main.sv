typedef enum logic[3:0]{
		ARITHM		= 4'b0000,
		LW			= 4'b1000,
		SW			= 4'b1011,
        BLT 		= 4'b0100,
        BGT	     	= 4'b0101,
        BE 			= 4'b0110,
        JMP  		= 4'b1100,
        HALT 		= 4'b1111      
} opcode_t;

module control_main(
	input opcode_t 		opcode,
	input wire 			div0,
	input wire 			overflow,

	output logic 		ALUop,
	output logic [1:0]	offset_sel;
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