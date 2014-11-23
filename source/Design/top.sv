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
	reg_program_counter pc_reg(
		.clk(clk),
		.rst(rst),

		.halt_sys(0), 	// Control signal from main control to halt cpu
		.stall(0),		// Control signal from hazard unit to stall for one cycle

		.in_address(PC_next_nojump),	// Next PC address
		.out_address(PC_address)	// Current PC address
	);

	//| Register File
	//| ============================================================================
	mem_register register_file (
	.rst(rst),
	.clk(clk),
	//.halt_sys(),

	//.R0_read,
  	.ra1(instruction[11:8]),
  	.ra2(instruction[7:4]),

	//.write_en(),
	//.R0_en(),
	//.write_address(),
	//.write_data(),

	.rd1(aluin.a),
	.rd2(aluin.b)
);
	


	//| Main Control Unit
	//| ============================================================================

	//| ALU Control Unit
	//| ============================================================================

	//| Hazard Detection Unit
	//| ============================================================================


	//| Stage 1 Flip-Flop
	//| ============================================================================

	
	//| Stage 2 Flip-Flop
	//| ============================================================================

	//| ALU instantiation
	//| ============================================================================
	
	//| ALU instantiation
	//| ============================================================================
	
	//| ALU instantiation
	//| ============================================================================

endmodule