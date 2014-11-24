import types_pkg::*;

module comparator(
	input wire		[15:0]	in1,
	input wire 		[15:0]	in2,

	output result_t	cmp_result
);

	assign cmp_result = (in1 > in2) ? GREATER 	:
						(in1 < in2) ? LESS		:
						(in1 == in2)? EQUAL		:
						UNKNOWN;

endmodule