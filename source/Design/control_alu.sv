import alu_pkg::*;

module control_alu(
	input control_e 	func,
	input wire 			ALUop,

	output control_e	alu_ctrl
);

	assign alu_ctrl = (ALUop) ? ADD : func;

endmodule