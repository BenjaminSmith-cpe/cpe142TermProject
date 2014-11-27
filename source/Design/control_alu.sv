module control_alu(
	input alu_pkg::control_e 	func,
	input wire 			ALUop,

	output alu_pkg::control_e	alu_ctrl,
	output logic			immb,
	output logic 			R0_en
);
	
	assign immb = ((func == ROR)||(func == ROL)||(func == SHR)||(func == SHL));
	assign R0_en = ((func == MULT)||(func == DIV));
	assign alu_ctrl = (ALUop) ? ADD : func;

endmodule
