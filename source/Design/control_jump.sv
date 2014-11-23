typedef enum logic[1:0]{
        GREATER 		= 2'b00,
        LESS	     	= 2'b01,
        EQUAL 			= 2'b10,
        UNKNOWN  		= 2'b11       
} result_t;


typedef enum logic[3:0]{
        BLT 		= 4'b0100,
        BGT	     	= 4'b0101,
        BE 			= 4'b0110,
        JMP  		= 4'b1100      
} opcode_t;


module jump_control(
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