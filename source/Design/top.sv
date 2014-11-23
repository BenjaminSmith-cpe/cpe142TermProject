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

	opcode_t opcode;
	control_e func_code;

	assign opcode = opcode_t'(instruction[15:12]);
	assign func_code = control_e'(instruction[3:0]);

	//| ALU instantiation
	//| ============================================================================
	in_t  aluin;
	control_e alucontrol;
	status_t alustat;
	word_16 aluout;

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

		.halt_sys(1'b0), 	// Control signal from main control to halt cpu
		.stall(1'b0),		// Control signal from hazard unit to stall for one cycle

		.in_address(PC_next_nojump),	// Next PC address
		.out_address(PC_address)	// Current PC address
	);

	//| Register File
	//| ============================================================================
	mem_register register_file (
		.rst(rst),
		.clk(clk),
		.halt_sys(1'b0),

		.R0_read(1'b0),
	  	.ra1(instruction[11:8]),
	  	.ra2(instruction[7:4]),

		.write_en(1'b0),
		.R0_en(1'b0),
		.write_address(4'b0),
		.write_data(32'b0),

		.rd1(aluin.a),
		.rd2(aluin.b)
	);
	

	//| Main Control Unit
	//| ============================================================================
	control_main Control_unit(
		.opcode(opcode),
		.func(func_code),
		.div0(1'b0),
		.overflow(1'b0),

		.ALUop(ALUop),
		.offset_sel(),
		.mem2r(),
		.memwr(),
		.halt_sys(),
		.reg_wr(),
		.R0_read(),
		.se_imm_a()
	);

	//| ALU Control Unit
	//| ============================================================================
	control_alu alu_control(
		.func(func_code),
		.ALUop(ALUop),

		.alu_ctrl(alucontrol)
	);

	//| Hazard Detection Unit
	//| ============================================================================
	hazard_detection_unit HDU(
	.R0_en(R0_en),
	.s2_R0_en(),
	.s3_R0_en(),
	.opcode(),
	.s2_opcode(),
	.s3_opcode(),

	.r1(),
	.r2(),
	.s2_r1(),
	.s3_r1(),

	.haz(),
	.stall()
	);

	//| Stage 1 Flip-Flop
	//| ============================================================================
	reg_pipe_stage_a stage_one(
	.clk(clk),
	.rst(rst),
	.halt_sys(),
	.stall(),

	.in_memc(),
	.in_reg_wr(),
	.in_alu_a(),
	.in_alu_b(),
	.in_R1_data(),

	.in_R0_en(),
	.in_alu_ctrl(),
	.in_instr(),	// Top 8 bits of instruction for opcode and dest reg

	// outputs
	.out_memc(),
	.out_reg_wr(),
	.out_alu_a(),
	.out_alu_b(),
	.out_R1_data(),

	.out_R0_en(),
	.out_alu_ctrl(),
	.out_instr()	// Top 8 bits of instruction for opcode and dest reg
	);
	
	//| Stage 2 Flip-Flop
	//| ============================================================================
	reg_pipe_stage_a stage_two(
	.clk(clk),
	.rst(rst),
	.halt_sys(),
	.stall(),

	.in_memc(),
	.in_reg_wr(),
	.in_alu(),
	.in_R1_data(),

	.in_R0_en(),
	.in_instr(),	// Top 8 bits of instruction for opcode and dest reg

	//outputs
	.out_memc(),
	.out_reg_wr(),
	.out_alu(),	
	.out_R1_data(),

	.out_R0_en(),
	.out_instr()	// Top 8 bits of instruction for opcode and dest reg
	);

	//| Sign Extending unit
	//| ============================================================================
	sign_extender sign_extend(
	.offset_sel(),
	.input_value(),

	.se_value()
	);

	//| Shift Left Unit
	//| ============================================================================
	shift_one shift1(
	.in(),
	.out()
	);

	//| Comparator
	//| ============================================================================
	comparator cmp(
	.in1(),
	.in2(),

	.cmp_result()
	);
	
	//| Main Memory
	//| ============================================================================
	mem_main main_memory(
	.rst(rst),
	.clk(clk),
	.halt_sys(),


	.write_en(),
	.address(),
	.write_data(),

	.data_out()
	);


	//| ====================================================================
	//| Stage 1
	//| 
	//| ====================================================================

	//| Mux
	//| ============================================================================
	mux #(.SIZE(16), .IS3WAY(1)) mux0(
		.sel(),
	
		.in1(),
		.in2(),
		.in3(),
	
		.out()
	);

	//| Mux
	//| ============================================================================
	mux #(.SIZE(16), .IS3WAY(1)) mux1(
		.sel(),
	
		.in1(),
		.in2(),
		.in3(),
	
		.out()
	);

	//| Mux
	//| ============================================================================
	mux #(.SIZE(16), .IS3WAY(1)) mux2(
		.sel(),
	
		.in1(),
		.in2(),
		.in3(),
	
		.out()
	);
	
	//| Mux
	//| ============================================================================
	mux #(.SIZE(16), .IS3WAY(1)) mux3(
		.sel(),
	
		.in1(),
		.in2(),
		.in3(),
	
		.out()
	);
	
	//| Mux
	//| ============================================================================
	mux #(.SIZE(16), .IS3WAY(1)) mux4(
		.sel(),
	
		.in1(),
		.in2(),
		.in3(),
	
		.out()
	);
	
	//| Mux
	//| ============================================================================
	mux #(.SIZE(16), .IS3WAY(1)) mux5(
		.sel(),
	
		.in1(),
		.in2(),
		.in3(),
	
		.out()
	);
	
	//| ====================================================================
	//| Stage 2
	//| 
	//| ====================================================================

	//| Mux
	//| ============================================================================
	mux #(.SIZE(16), .IS3WAY(1)) mux6(
		.sel(),
	
		.in1(),
		.in2(),
		.in3(),
	
		.out()
	);
	
	//| Mux
	//| ============================================================================
	mux #(.SIZE(16), .IS3WAY(1)) mux7(
		.sel(),
	
		.in1(),
		.in2(),
		.in3(),
	
		.out()
	);
	
	//| Mux
	//| ============================================================================
	mux #(.SIZE(16), .IS3WAY(1)) mux8(
		.sel(),
	
		.in1(),
		.in2(),
		.in3(),
	
		.out()
	);
	
	//| ====================================================================
	//| Stage 3
	//| 
	//| ====================================================================

	//| Mux
	//| ============================================================================
	mux #(.SIZE(16), .IS3WAY(1)) mux9(
		.sel(),
	
		.in1(),
		.in2(),
		.in3(),
	
		.out()
	);
	
endmodule