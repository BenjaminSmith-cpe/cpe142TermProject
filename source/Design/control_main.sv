// Main control module
//
// This module determines the control signals for
// every instruction based on the opcode and func code.
// This unit will also halt the system when any exception occurs
// divide by zero, overflow, unknown opcode
//

module control_main(
    input types_pkg::opcode_t   opcode,
    input alu_pkg::control_e    func,
    input wire                  div0,
    input wire                  overflow,

    output logic                ALUop,
    output types_pkg::sel_t     offset_sel,
    output logic                mem2r,
    output logic                memwr,
    output logic                halt_sys,
    output logic                reg_wr,
    output logic                R0_read,
    output logic                se_imm_a
);
    
    import types_pkg::*;
    import alu_pkg::*;
    
    // Compute control signals
    always_comb begin
        // If an exception has occurred, zero everything out and 
        // halt system.
        if (div0 || overflow) begin // Exception
            ALUop = 1'b0;
            offset_sel = NONE;
            mem2r = 1'b0;
            memwr = 1'b0;
            halt_sys = 1'b1;
            reg_wr = 1'b0;
            R0_read = 1'b0;
            se_imm_a = 1'b0;
        end
        else begin
            // determine output signals based on opcode
            case (opcode) 
                ARITHM: begin
                    ALUop = 1'b0;
                    if((func == ROR)||(func == ROL)||(func == SHL)||(func == SHR))
                        offset_sel = FOURBIT;
                    else
                        offset_sel = NONE;
                    mem2r = 1'b0;
                    memwr = 1'b0;
                    halt_sys = 1'b0;
                    reg_wr = 1'b1;
                    R0_read = 1'b0;
                    se_imm_a = 1'b0; 
                end
                LW: begin
                    ALUop = 1'b1;
                    offset_sel = FOURBIT;
                    mem2r = 1'b1;
                    memwr = 1'b0;
                    halt_sys = 1'b0;
                    reg_wr = 1'b1;
                    R0_read = 1'b0;
                    se_imm_a = 1'b1;
                end
                SW: begin
                    ALUop = 1'b1;
                    offset_sel = FOURBIT;
                    mem2r = 1'b0;
                    memwr = 1'b1;
                    halt_sys = 1'b0;
                    reg_wr = 1'b0;
                    R0_read = 1'b0;
                    se_imm_a = 1'b1;
                end
                BLT: begin
                    ALUop = 1'b1;
                    offset_sel = EIGHTBIT;
                    mem2r = 1'b0;
                    memwr = 1'b0;
                    halt_sys = 1'b0;
                    reg_wr = 1'b0;
                    R0_read = 1'b1;
                    se_imm_a = 1'b1;
                end
                BGT: begin
                    ALUop = 1'b1;
                    offset_sel = EIGHTBIT;
                    mem2r = 1'b0;
                    memwr = 1'b0;
                    halt_sys = 1'b0;
                    reg_wr = 1'b0;
                    R0_read = 1'b1;
                    se_imm_a = 1'b1;
                end
                BE: begin
                    ALUop = 1'b1;
                    offset_sel = EIGHTBIT;
                    mem2r = 1'b0;
                    memwr = 1'b0;
                    halt_sys = 1'b0;
                    reg_wr = 1'b0;
                    R0_read = 1'b1;
                    se_imm_a = 1'b1;
                end
                JMP: begin
                    ALUop = 1'b1;
                    offset_sel = TWELVEBIT;
                    mem2r = 1'b0;
                    memwr = 1'b0;
                    halt_sys = 1'b0;
                    reg_wr = 1'b0;
                    R0_read = 1'b0;
                    se_imm_a = 1'b1;
                end
                HALT: begin
                    ALUop = 1'b0;
                    offset_sel = NONE;
                    mem2r = 1'b0;
                    memwr = 1'b0;
                    halt_sys = 1'b1;
                    reg_wr = 1'b0;
                    R0_read = 1'b0;
                    se_imm_a = 1'b1;
                end
    
                default: begin      // Exception
                    ALUop = 1'b0;
                    offset_sel = NONE;
                    mem2r = 1'b0;
                    memwr = 1'b0;
                    halt_sys = 1'b1;
                    reg_wr = 1'b0;
                    R0_read = 1'b0;
                    se_imm_a = 1'b0;
                end
            endcase
        end
    end
endmodule
