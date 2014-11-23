typedef enum logic[1:0]{
        NONE 		= 2'b00,
        FOURBIT     = 2'b01,
        EIGHTBIT 		= 2'b10,
        TWELVEBIT  	= 2'b11       
    } sel_t;

module sign_extender(
	input sel_t [1:0]	offset_sel,
	input wire 	[11:0]	input_value,

	output logic[15:0] 	se_value
);


	always_comb begin
		case (offset_sel)
			NONE:
				se_value = {4'h0, input_value};
			FOURBIT:
				if (input_value[3]) // Might not be sign extending these correctly
					se_value = {12'hfff, input_value[3:0]};
				else
					se_value = {12'h000, input_value[3:0]};
				
			EIGHTBIT:
				if (input_value[7]) // Might not be sign extending these correctly
					se_value = {8'hff, input_value[7:0]};
				else
					se_value = {8'h00, input_value[7:0]};
				
			TWELVEBIT:
				if (input_value[11]) // Might not be sign extending these correctly
					se_value = {4'hf, input_value[11:0]};
				else
					se_value = {4'h0, input_value[11:0]};
		endcase
	end
endmodule