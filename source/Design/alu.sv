import alu_pkg::*;

module alu(
    input in_t       in,
    input control_e  control,
    
    output status_t   stat,
    output integer    out
);
    logic carry;

    always_comb begin    
        case(control)
            OR : out = in.a | in.b;
            AND: out = in.a & in.b;
            MULT: out = in.a * in.b;
            ROL : out = {in.a, in.a} << in.b;
            ROR : out = {in.a, in.a} >> in.b;
            SHL : out = in.a <<< in.b;
            SHR : out = in.a >>> in.b;
            SUB : out = in.a - in.b;
            ADD : out = in.a + in.b;
            DIV : begin
                assert(in.b != 0);
                out[15:0] = in.a / in.b;
                out[31:16] = in.a % in.b;
            end
            default:
                out = 32'bZ;
        endcase
    end

    always_comb begin
        stat.zero = !(|out);
        stat.sign = out[15];
        stat.overflow = (!control[1]) ? out[16]^out[15] : 1'b0; 
    end
endmodule