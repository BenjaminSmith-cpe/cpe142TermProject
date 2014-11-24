module reg_pipe_stage_a(
	input wire			clk,
	input wire 			rst,
	input wire 			halt_sys,
	input wire			stall,

	input wire	[1:0]	in_memc,
	input wire			in_reg_wr,
	input wire	[15:0]	in_alu_a,
	input wire 	[15:0] 	in_alu_b,
	input wire 	[15:0]	in_R1_data,

	input wire 			in_R0_en,
	input wire 	[3:0]	in_alu_ctrl,
	input wire 	[7:0]	in_instr,	// Top 8 bits of instruction for opcode and dest reg
	input wire 				in_haz2,
	input wire				in_haz1,
	output	logic			out_haz1,
	output 	logic			out_haz2,
	output logic	[1:0]	out_memc,
	output logic			out_reg_wr,
	output logic	[15:0]	out_alu_a,
	output logic 	[15:0] 	out_alu_b,
	output logic 	[15:0]	out_R1_data,

	output logic 			out_R0_en,
	output logic 	[3:0]	out_alu_ctrl,
	output logic 	[7:0]	out_instr	// Top 8 bits of instruction for opcode and dest reg
	
);

	always_ff@ (posedge clk or posedge rst) begin: stage_A_flop
		if (rst) begin		
			out_memc 		<= 2'd0;
			out_reg_wr 		<= 1'd0;
			out_alu_a 		<= 16'd0;
			out_alu_b 		<= 16'd0;
			out_R1_data 	<= 16'd0;
			out_haz1			<= 1'b0;
			out_haz2			<= 1'b0;
			out_R0_en 		<= 1'd0;
			out_alu_ctrl 	<= 4'd0;
			out_instr 		<= 8'd0;	// Top 8 bits of instruction // If rst is asserted, we want to clear the flops
		end 
		else begin
			if(halt_sys || stall) begin
				// Stay the same value. System is halted.
			end
			else 				// Flop the input
				out_memc 		<= in_memc;
				out_reg_wr 		<= in_reg_wr;
				out_alu_a 		<= in_alu_a;
				out_alu_b 		<= in_alu_b;
				out_R1_data 	<= in_R1_data;
				out_haz1			<= in_haz1;
				out_haz2			<= in_haz2;
				out_R0_en 		<= in_R0_en;
				out_alu_ctrl 	<= in_alu_ctrl;
				out_instr 		<= in_instr;
		end
	end
endmodule