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
	logic clockg;

	logic 	[7:0] memory[65536:0];	// Memory block. 16 bit address with 16 bit data
	logic 	[7:0] shadow_memory[65536:0] = '{default:0};
	
	always_comb begin: clock_gating
	 clockg = (halt_sys == 1'b1|| write_en == 1'b0)?1'b0:clk; //flop clock gated
	end
	
	always_comb begin: memory_read_logic
		data_out = {memory[address + 1], memory[address]};	// Always read the data from the address
	end
	
	always_ff@(posedge clockg ,posedge rst) begin: memory_rst_and_write
		if(rst == 1'b1) memory <=  shadow_memory;// If rst is asserted, we want to clear the flops
		else if (write_en)          {memory[address + 1], memory[address]} <= write_data; 	// Flop the input
	end
endmodule

