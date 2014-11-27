module top (
	input wire clk,
	input wire rst
);
	
	import types_pkg::*;
	import alu_pkg::*;

	stage_one st1(
		.clk(clk),
		.rst(rst)
	);

	stage_two st2(
		.clk(clk),
		.rst(rst)
	);


endmodule
