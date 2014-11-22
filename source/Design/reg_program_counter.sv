module reg_program_counter(
	input wire clk,
	input wire rst,

	input wire halt_sys, 	// Control signal from main control to halt cpu
	input wire stall,		// Control signal from hazard unit to stall for one cycle

	input wire in_address[15:0],	// Next PC address
	
	output logic out_address[15:0]	// Current PC address
);

always_ff@ (posedge clk or posedge rst) begin: program_counter_flop
	if (rst) begin
		out_address <= 16'd0;
	end 
	else begin
		if(halt_sys or stall) 
			out_address <= out_address; // Stay the same value. System is halted.
		else 
			out_address <= in_address; 	// Flop the input
	end
endmodule