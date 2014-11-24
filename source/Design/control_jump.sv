import types_pkg::*;

module control_jump(
	input result_t 	cmp_result,
	input opcode_t 	opcode,

	output logic 	jmp
);

always_comb begin
	case(opcode)
		BLT:
			if(cmp_result == LESS)
				jmp = 1'b1;
			else
				jmp = 1'b0;
		BGT:
			if(cmp_result == GREATER)
				jmp = 1'b1;
			else
				jmp = 1'b0;
		BE:
			if(cmp_result == EQUAL)
				jmp = 1'b1;
			else
				jmp = 1'b0;
		JMP:
			jmp = 1'b1;
		default:
			jmp = 1'b0;
	endcase
end 

endmodule