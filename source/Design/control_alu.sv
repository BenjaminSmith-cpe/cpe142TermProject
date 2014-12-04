// ALU control module 
//
// This module determines the proper control signals for the ALU based on
// the main control unit's ALUop and the function code in the instruction
//

module control_alu(
    input alu_pkg::control_e    func,			// instr function code
    input wire                  ALUop,		// control signal from main control

    output alu_pkg::control_e   alu_ctrl,	
    output logic                immb,			// If operation needs immediate instead of register value
    output logic                R0_en   	// If operation will need to write to R0(MUL/DIV)
);
    import alu_pkg::*;
    

    assign immb = ((func == ROR)||(func == ROL)||(func == SHR)||(func == SHL));
    assign R0_en = ((func == MULT)||(func == DIV));
    // If ALU op is low, then output the function code to the ALU. Otherwise output ADD
    assign alu_ctrl = (ALUop) ? ADD : func;

endmodule
