module adder(
	input logic 	[15:0] 	pc,
	input logic 	[15:0]	offset,

	output logic    [15:0]	sum
);

	logic overflow; // If there is an overflow, that is bad!

	assign {overflow, sum} = pc + offset;
endmodule