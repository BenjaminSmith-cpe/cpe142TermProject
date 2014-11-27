module mem_program(
	input wire 	[15:0] 	address,
	output logic[15:0]	data_out
);
	
	logic rst = 0;
	
	// logic 	[65535:0][7:0] memory = 0;	// Memory block. 16 bit address with 16 bit data
    logic  [7:0] memory[100:0] = '{default:8'b0};  // Memory block. 16 bit address with 16 bit data
            
	assign data_out = {memory[address], memory[address+1]};	// Always read the data from the address

endmodule
