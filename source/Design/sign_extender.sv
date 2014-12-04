//
// Sign extender module
//
// This module is capable of sign extending extending a 4, 
// 8, or 12-bit value to a signed 16 bit value.
//

module sign_extender(
    input types_pkg::sel_t          offset_sel,
    input wire              [11:0]  input_value,

    output logic            [15:0]  se_value
);
    import types_pkg::*;

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
