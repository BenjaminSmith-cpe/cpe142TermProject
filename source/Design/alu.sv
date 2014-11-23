import alu_pkg::*;

module alu(alu_interface io);

    logic carry;
    logic [31:0] arith_temp;

    always_comb begin    
        case(io.control)
            add     : {carry, io.out} = io.in.a + io.in.b;
            subtract: {carry, io.out} = io.in.a - io.in.b;
            bitw_or : io.out = io.in.a | io.in.b;
            bitw_and: io.out = io.in.a & io.in.b;
        endcase
    end

    always_comb begin
        io.stat.zero = !(|io.out);
        io.stat.sign = io.out[31];
        io.stat.overflow = (!io.control[1]) ? carry^io.out[31] : 1'b0; 
    end
endmodule