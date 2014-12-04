module alu(
    input alu_pkg::in_t       in,
    input alu_pkg::control_e  control,
    
    output alu_pkg::status_t   stat,
    output integer   out
);
    import alu_pkg::*;

    logic carry;
    logic signed [17:0] arith;
    
    always_comb begin    
        case(control)
            OR  : out = {16'b0,in.a | in.b};
            AND : out = {16'b0,in.a & in.b};
            MULT: out = in.a * in.b;
            ROL : out = {16'b0,({in.a, in.a} << in.b%16)};
            ROR : out = {16'b0,({in.a, in.a} >> in.b%16)};
            SHL : out = {16'b0,in.a <<< in.b};
            SHR : out = {16'b0,in.a >>> in.b};
            SUB : begin
                arith = in.a - in.b;
                out = {16'b0, arith[15:0]};
            end
            ADD : begin
                arith = in.a + in.b;
                out = {16'b0, arith[15:0]};
            end
            DIV : begin
                if(in.b != 0) begin
                    out[15:0] = in.a / in.b;
                    out[31:16] = in.a % in.b;
                end
                else begin
                    out = 32'b0;
                    assert(0);
                end
            end
         endcase
    end

    always_comb begin:flag_logic
        stat.zero = !(|out);
        stat.div0 = ((control == DIV)&&(in.b == 32'd0)) ? 1'b1 : 1'b0;
        
        stat.overflow = (control == ADD || control == SUB) ? arith[17]^arith[16] : 1'b0; 
        
        if(control == MULT) stat.sign = out[31];
        else                stat.sign = out[15];
    end
endmodule
