import types_pkg::*;
import alu_pkg::*;

module top (
	input wire clk,
	input wire rst
);
	//| Local logic instantiations
	//| ============================================================================
	uword PC_address, PC_next_jump, PC_next_nojump;
	logic [15:0] instruction;

	//| ALU instantiation
	//| ============================================================================
	in_t  aluin;
	control_e alucontrol;
	status_t alustat;
	word_16 aluout;

	assign aluin.a = 0;
	assign aluin.b = 0;
	assign alucontrol = ADD;

	alu main_alu(
		.in 	(aluin),
		.control(alucontrol),
		.stat   (alustat),
		.out	(aluout)
	);

	//| PC adder instantiation
	//| ============================================================================
	adder pc_adder(
		.pc(PC_address),
		.offset(16'd2),

		.sum(PC_next_nojump)
	);

	//| Jump adder instantiation
	//| ============================================================================
	adder jump_adder(
		.pc(PC_address),
		.offset(16'd4),

		.sum(PC_next_jump)
	);

	//| ALU instantiation
	//| ============================================================================
	mem_program program_memory(
		.address(PC_address),	
		.data_out(instruction)
	);

	//| Program counter
	//| ============================================================================
	always_ff @(posedge clk or posedge rst) begin : program_counter
		if(rst) begin
			PC_address <= 0;
		end else begin
			PC_address <= PC_next_nojump;
		end
	end

	//| ALU instantiation
	//| ============================================================================

	//| ALU instantiation
	//| ============================================================================
endmodule