// Jump control module
//
// This module determines whether or not the PC 
// should jump or branch based off the opcode and the
// comparator results
//

module control_jump(
    input types_pkg::result_t   cmp_result,
    input types_pkg::opcode_t   opcode,

    output logic    jmp
);

    import types_pkg::*;
    
    // compute the jmp condition based on the opcode 
    // and the results from the comparator
    always_comb begin
        case(opcode)
            BLT:
                if(cmp_result == LESS)
                    jmp = 1'b1;
                else
                    jmp = 1'b0;
            BGT:
                if(cmp_result == GREATER)
                    jmp = 1'b1;
                else
                    jmp = 1'b0;
            BE:
                if(cmp_result == EQUAL)
                    jmp = 1'b1;
                else
                    jmp = 1'b0;
            JMP: // jump no matter what is opcode is JMP
                jmp = 1'b1;
            default:
                jmp = 1'b0;
        endcase
    end 
    
endmodule
