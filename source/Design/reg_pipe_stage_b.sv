module reg_pipe_stage_a(
	input wire			clk,
	input wire 			rst,
	input wire 			halt_sys,
	input wire			stall,

	input wire	[1:0]	in_memc,
	input wire			in_reg_wr,
	input wire	[31:0]	in_alu,
	input wire 	[15:0]	in_R1_data,

	input wire 			in_R0_en,
	input wire 	[7:0]	in_instr,	// Top 8 bits of instruction for opcode and dest reg

	output logic	[1:0]	out_memc,
	output logic			out_reg_wr,
	output logic	[31:0]	out_alu,	
	output logic 	[15:0]	out_R1_data,

	output logic 			out_R0_en,
	output logic 	[7:0]	out_instr	// Top 8 bits of instruction for opcode and dest reg
);

	always_ff@ (posedge clk or posedge rst) begin: stage_B_flop
		if (rst) begin		
			out_memc 		<= 2'd0;
			out_reg_wr 		<= 1'd0;
			out_alu 			<= 32'd0;
			out_R1_data 	<= 16'd0;
			out_R0_en 		<= 1'd0;
			out_instr 		<= 8'd0;	// Top 8 bits of instruction // If rst is asserted, we want to clear the flops
		end 
		else begin
			if(halt_sys || stall) begin
				// Stay the same value. System is halted.
			end
			else 				// Flop the input
				out_memc 		<= in_memc;
				out_reg_wr 		<= in_reg_wr;
				out_alu 			<= in_alu;
				out_R1_data 	<= in_R1_data;
				out_R0_en 		<= in_R0_en;
				out_instr 		<= in_instr;
		end
	end
endmodule