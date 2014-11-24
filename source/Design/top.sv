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

	wire [10:0] 	haz;

	wire 	[1:0]	memc;
	wire 	[1:0]	s2_memc;
	wire 	[1:0]	s3_memc;

	wire 	[31:0]	s3_data;
	wire 	[31:0]	s3_alu;


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
		.offset(offset_shifted),
		.sum(PC_no_jump)
	);

	//| Jump adder instantiation
	//| ============================================================================
	adder jump_adder(
		.pc(PC_address),
		.offset(offset_shifted),
		.sum(PC_jump)
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

		.halt_sys(halt_sys), 	// Control signal from main control to halt cpu
		.stall(stall),		// Control signal from hazard unit to stall for one cycle

		.in_address(PC_next),	// Next PC address
		.out_address(PC_address)	// Current PC address
	);

	//| Register File
	//| ============================================================================
	mem_register register_file (
		.rst(rst),
		.clk(clk),
		.halt_sys(halt_sys),

		.R0_read(R0_read),
	  	.ra1(instruction[11:8]),
	  	.ra2(instruction[7:4]),

		.write_en(s3_write_en),
		.R0_en(s3_R0_en),
		.write_address(s3_write_address),
		.write_data(s3_data),

		.rd1(r1_data),
		.rd2(r2_data)
	);
	

	//| Main Control Unit
	//| ============================================================================
	control_main Control_unit(
		.opcode(opcode),
		.func(func_code),
		.div0(1'b0),
		.overflow(1'b0),

		.ALUop(ALUop),
		.offset_sel(offset_sel),
		.mem2r(mem2r),
		.memwr(memwr),
		.halt_sys(halt_sys),
		.reg_wr(reg_wr),
		.R0_read(R0_read),
		.se_imm_a(se_imm_a)
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
		.s2_R0_en(s2_R0_en),
		.s3_R0_en(s3_R0_en),
		.opcode(opcode),
		.s2_opcode(s2_opcode),
		.s3_opcode(s3_opcode),

		.r1(instruction[11:8]),
		.r2(instruction[7:4]),
		.s2_r1(s2_r1),
		.s3_r1(s3_r1),

		.haz(haz),
		.stall(stall)
	);

	//| Stage 1 Flip-Flop
	//| ============================================================================
	reg_pipe_stage_a stage_one(
		.clk(clk),
		.rst(rst),
		.halt_sys(halt_sys),
		.stall(stall),

		.in_memc({mem2r, memwr}),
		.in_reg_wr(reg_wr),
		.in_alu_a(in_alu_a),
		.in_alu_b(in_alu_b),
		.in_R1_data(r1_data),

		.in_R0_en(R0_en),
		.in_alu_ctrl(alu_ctrl),
		.in_instr(instruction[15:8]),	// Top 8 bits of instruction for opcode and dest reg

		// outputs
		.out_memc(s2_memc),
		.out_reg_wr(s2_reg_wr),
		.out_alu_a(s2_alu_a),
		.out_alu_b(s2_alu_b),
		.out_R1_data(s2_r1_data),

		.out_R0_en(s2_R0_en),
		.out_alu_ctrl(s2_alu_ctrl),
		.out_instr(s2_instruction)	// Top 8 bits of instruction for opcode and dest reg
	);
	
	//| Stage 2 Flip-Flop
	//| ============================================================================
	reg_pipe_stage_a stage_two(
		.clk(clk),
		.rst(rst),
		.halt_sys(halt_sys),
		.stall(stall),

		.in_memc(s2_memc),
		.in_reg_wr(s2_reg_wr),
		.in_alu(aluout),
		.in_R1_data(s1_r1_data),	// Muxed

		.in_R0_en(R0_en),
		.in_instr(s2_instruction),	// Top 8 bits of instruction for opcode and dest reg

		//outputs
		.out_memc(s3_memc),
		.out_reg_wr(s3_reg_wr),
		.out_alu(s3_alu),	
		.out_R1_data(s3_r1_data),

		.out_R0_en(s3_R0_en),
		.out_instr(s3_instruction)	// Top 8 bits of instruction for opcode and dest reg
	);

	//| Sign Extending unit
	//| ============================================================================
	sign_extender sign_extend(
		.offset_sel(offset_sel),
		.input_value(instruction[11:0]),	// 11:0 to handle all 3 different sized offsets.

		.se_value(offset_se)
	);

	//| Shift Left Unit
	//| ============================================================================
	shift_one shift1(
		.in(offset_se),
		.out(offset_shifted)
	);

	//| Comparator
	//| ============================================================================
	comparator cmp(
		.in1(cmp_a),
		.in2(cmp_b),

		.cmp_result(cmp_result)
	);
	
	//| Main Memory
	//| ============================================================================
	mem_main main_memory(
		.rst(rst),
		.clk(clk),
		.halt_sys(halt_sys),


		.write_en(s3_memc[0]),	//memwr
		.address(s3_alu),
		.write_data(s3_r1_data),

		.data_out(mem_data)
	);


	//| ====================================================================
	//| Stage 1
	//| 
	//| ====================================================================

	//| Mux
	//| ============================================================================
	mux #(.SIZE(16), .IS3WAY(0)) mux0(
		.sel(jmp),
	
		.in1(PC_no_jump),
		.in2(PC_jump),
		.in3(),
	
		.out(PC_next)
	);

	//| Mux before comparator with R1
	//| ============================================================================
	mux #(.SIZE(16), .IS3WAY(1)) mux1(
		.sel({haz[4], haz[5]}),
	
		.in1(r1_data),
		.in2(aluout[15:0]),
		.in3(s3_data[15:0]),
	
		.out(cmp_a)
	);

	//| Mux before comparator with R2
	//| ============================================================================
	mux #(.SIZE(16), .IS3WAY(1)) mux2(
		.sel({haz[6], haz[7]}),
	
		.in1(r2_data),
		.in2(aluout[31:16]),
		.in3(s3_data[31:16]),
	
		.out(cmp_b)
	);
	
	//| Mux for r1_data
	//| ============================================================================
	mux #(.SIZE(16), .IS3WAY(1)) mux3(
		.sel({haz[9], haz[10]}), 	// mem2r
	
		.in1(r1_data),
		.in2(aluout[15:0]),
		.in3(mem_data),
	
		.out(s1_r1_data)
	);
	
	//| Mux for ALU_a
	//| ============================================================================
	mux #(.SIZE(16), .IS3WAY(1)) mux4(
		.sel({se_imm_a, haz[0]}),
	
		.in1(r1_data),
		.in2(offset_se), //sign extended
		.in3(s3_data[15:0]),
	
		.out(alu_a_in)
	);
	
	//| Mux for ALU_B
	//| ============================================================================
	mux #(.SIZE(16), .IS3WAY(1)) mux5(
		.sel(),
	
		.in1(),
		.in2(),
		.in3(),
	
		.out(in_alu_b)
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
	mux #(.SIZE(16), .IS3WAY(0)) mux3(
		.sel(s3_memc[1]), 	// mem2r
	
		.in1(mem_data),
		.in2(s3_alu[15:0]),
		.in3(),
	
		.out(s3_data)
	);
	
endmodule