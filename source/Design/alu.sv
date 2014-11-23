import alu_pkg::*;

module alu(alu_interface io);

    logic carry;

    always_comb begin    
        case(io.control)
            ADD: {carry, io.out} = io.in.a + io.in.b;
            SUB: {carry, io.out} = io.in.a - io.in.b;
            OR : io.out = io.in.a | io.in.b;
            AND: io.out = io.in.a & io.in.b;
        endcase
    end

    always_comb begin
        io.stat.zero = !(|io.out);
        io.stat.sign = io.out[16];
        io.stat.overflow = (!io.control[1]) ? carry^io.out[16] : 1'b0; 
    end
endmodule