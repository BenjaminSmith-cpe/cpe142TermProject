//===========================================================
// Main memory block
// Word addressable (16-bit)
//
//===========================================================

module mem_main(
	input wire 			rst,
	input wire 			clk,
	input wire 			halt_sys,

	input wire 			write_en,
	input wire 	[15:0] 	address,
	input wire 	[15:0] 	write_data,

	output logic[15:0]	data_out
);


	logic 	[15:0] 	memory 	[65535:0];	// Memory block. 16 bit address with 16 bit data
	
	assign data_out = memory[address];	// Always read the data from the address

	always_ff@ (posedge clk or posedge rst) begin: mem_main_flop
		if (rst) begin		
			memory <= '0;// If rst is asserted, we want to clear the flops
		end 
		else begin
			if(halt_sys or stall or !write_en) 
				memory[address] <= memory[address]; // Stay the same value. System is halted.
			else 
				memory[address] <= write_data; 	// Flop the input
		end
	end
endmodule

