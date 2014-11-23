module pc_adder(
	input wire 	[15:0] 	pc,

	output logic[15:0]	sum
);
	logic overflow;

	assign {overflow, sum} = pc + 2; // +2 because our instructions are 2 bytes long.

endmodule