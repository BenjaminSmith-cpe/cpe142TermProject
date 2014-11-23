module jump_adder(
	input wire 	[15:0] 	pc,
	input wire 	[15:0]	offset,

	output logic[15:0]	sum
);

	logic overflow; // If there is an overflow, that is bad!

	assign {overflow, sum} = pc + offset;
endmodule