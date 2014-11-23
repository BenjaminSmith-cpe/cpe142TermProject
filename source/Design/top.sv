module top (
	input wire clk
);




mux s3_alu_mux(
	.out(s3_data)
;)

mux s2_a_mux(
	.ina(alu_a),
	.inb(s3_data),
	.out(alu_interface.in)
);

mux s2_b_mux(
	.ina(alu_b),
	.inb(s3_data),
	.out(in_alu_b)
);

alu main_alu(
	.ina(in_alu_a),
	.inb(in_alu_b),

	.out(output)
);