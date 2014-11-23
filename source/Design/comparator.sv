typedef enum logic[1:0]{
        GREATER 		= 2'b00,
        LESS	     	= 2'b01,
        EQUAL 			= 2'b10,
        UNKNOWN  		= 2'b11       
    } result_t;

module comparator(
	input wire		[15:0]	in1,
	input wire 		[15:0]	in2,

	output result_t	[1:0]	cmp_result
);

	assign cmp_result = (in1 > in2) ? GREATER 	:
						(in1 < in2) ? LESS		:
						(in1 == in2)? EQUAL		:
						UNKNOWN;

endmodule