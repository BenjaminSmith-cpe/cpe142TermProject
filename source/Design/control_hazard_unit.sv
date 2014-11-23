module hazard_detection_unit(
	input wire  			r0_en,
	input wire		[3:0]	opcode,
	input wire		[3:0]	s2_opcode,
	input wire		[3:0]	s3_opcode,

	input wire		[3:0]	r1,
	input wire		[3:0]	r2,
	input wire		[3:0]	s2_r1,
	input wire		[3:0]	s3_r1,

	output logic	[10:0]	haz,
	output logic 			stall
);

always_comb 
	assert($oneshot(haz));



endmodule
