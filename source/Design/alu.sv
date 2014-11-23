import alu_pkg::*;

module alu(
    input in_t       in,
    input control_e  control,
    
    output status_t   stat,
    output word_16    out
);
    logic carry;

    always_comb begin    
        case(control)
            ADD: {carry, out} = in.a + in.b;
            SUB: {carry, out} = in.a - in.b;
            OR : out = in.a | in.b;
            AND: out = in.a & in.b;
        endcase
    end

    always_comb begin
        stat.zero = !(|out);
        stat.sign = out[15];
        stat.overflow = (!control[1]) ? carry^out[15] : 1'b0; 
    end
endmodule