module control_jump(
    input types_pkg::result_t   cmp_result,
    input types_pkg::opcode_t   opcode,

    output logic    jmp
);

import types_pkg::*;

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
        JMP:
            jmp = 1'b1;
        default:
            jmp = 1'b0;
    endcase
end 

endmodule
