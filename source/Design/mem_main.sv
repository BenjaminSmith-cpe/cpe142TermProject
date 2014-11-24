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
	// always_comb begin : assertions
	// 	assert(!address[0]);
	// end

	logic 	[7:0][2^16:0]	memory;	// Memory block. 16 bit address with 16 bit data
	
	assign data_out = {memory[address + 1], memory[address]};	// Always read the data from the address

	always_ff@ (posedge clk or posedge rst) begin: mem_main_flop
		if (rst) memory <= 0;// If rst is asserted, we want to clear the flops
		else begin
			if(halt_sys || !write_en) begin
				memory[address] <= memory[address]; // Stay the same value. System is halted.
				memory[address + 1] <= memory[address + 1]; // Stay the same value. System is halted.
			end
			else 
				{memory[address + 1], memory[address]} <= write_data; 	// Flop the input
		end
	end
endmodule

