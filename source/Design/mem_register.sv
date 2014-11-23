module register_file(
	input wire 			rst,
	input wire 			clk,
	input wire 			halt_sys,

	input wire 			R0_read,
  	input wire 	[3:0]	ra1,
  	input wire 	[3:0]	ra2,

	input wire 			write_en,
	input wire 			R0_en,
	input wire 	[3:0] 	write_address,
	input wire 	[31:0] 	write_data,

	output logic[15:0]	rd1,
	output logic[15:0] 	rd2
);

	wire 	[15:0]			write_data_high;
	wire 	[15:0]			write_data_low;

	logic 	[15:0]	registers[15:0];	// Memory block. 16 bit address with 16 bit data

	assign {write_data_high, write_data_low} = write_data; 	// Split the input data
															// into two words
	assign rd1 = registers[ra1];	// Always read the data from the address
	// If a branch instruction(R0_read is high) then R0 contents are output at rd2
	assign rd2 = (R0_read) ? registers[0] : registers[ra2];	

	always_ff@ (posedge clk or posedge rst) begin: mem_reg_flop
		if (rst) begin		
			registers <= '{default:8'b0};// If rst is asserted, we want to clear the flops
			$readmemh("verif/register_memory.hex", registers);
		end 
		else begin
			if(halt_sys || !write_en) 
				registers[write_address] <= registers[write_address]; // Stay the same value. System is halted.
			else begin // Write data to reg, and write top 16 bits to R0 if R0_en is high 
				if (R0_en)
					registers[0] <= write_data_high;
				registers[write_address] <= write_data_low; 	// Flop the input
			end
		end
	end
endmodule