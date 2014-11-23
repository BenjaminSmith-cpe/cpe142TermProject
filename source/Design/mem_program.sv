module mem_program(
	input wire 	[15:0] 	address,

	output logic[15:0]	data_out
);

	logic 	[7:0] 	memory 	[65535:0];	// Memory block. 16 bit address with 16 bit data
	
	assign data_out = {memory[address + 1], memory[address]};	// Always read the data from the address

endmodule