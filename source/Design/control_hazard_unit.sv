import types_pkg::*;
import alu_pkg::*;

module hazard_detection_unit(
	input wire  			R0_en,
	input wire 				s2_R0_en,
	input wire				s3_R0_en,
	input opcode_t			opcode,
	input opcode_t			s2_opcode,
	input opcode_t			s3_opcode,

	input wire		[3:0]	r1,
	input wire		[3:0]	r2,
	input wire		[3:0]	s2_r1,
	input wire		[3:0]	s3_r1,

	output logic	[10:0]	haz,
	output logic 			stall
);
	// Arithmetic or load followed two instructions later
	// another arithmetic(Or STORE) using same destination
	// register for R1.
	assign haz0 = ((opcode == ARITHM)||(opcode == SW))
					&&((s3_opcode == ARITHM)||(s3_opcode == LW))
					&&((r1 == s3_r1));
	assign haz[0] = (haz0) ? 1'b1 : 1'b0 ;
	
	// Arithmetic or load directly followed by an arithmetic
	// op with the R1 as the first destination.
	assign haz1 = ((opcode == ARITHM))
					&&((s2_opcode == ARITHM)||(s2_opcode == LW))
					&&((r1 == s2_r1));
	assign haz[1] = (haz1) ? 1'b1: 1'b0;
	
	// Arithmetic or load directly followed by an arithmetic
	// op with the R2 as the first destination.
	assign haz2 = ((opcode == ARITHM))
					&&((s2_opcode == ARITHM)||(s2_opcode == LW))
					&&((r2 == s3_r1));
	assign haz[2] = (haz2) ? 1'b1: 1'b0;
	
	// Arithmetic or load followed 2 instructions later by an
	// arithmetic op with the R2 as the first destination
	assign haz3 = ((opcode == ARITHM))
					&&((s3_opcode == ARITHM)||(s3_opcode == LW))
					&&((r2 == s3_r1));
	assign haz[3] = (haz3) ? 1'b1: 1'b0;
	
	// An Arithmetic operation is followed directly by a
	// branch instruction
	assign haz4 = ((opcode == BE)||(opcode == BLT)||(opcode == BGT))
					&&((s2_opcode == ARITHM));
	assign haz[4] = (haz4) ? 1'b1: 1'b0;
	
	// LOAD is followed directly, or second instruction, by a
	// branch instruction using the dest register for compare.
	// Also if an arithmetic op was followed 2 instructions
	// later by a branch instruction using its dest register
	assign haz5 = ((opcode == BE)||(opcode == BLT)||(opcode == BGT))
					&&((s3_opcode == LW)||(s2_opcode == LW)||(s3_opcode == ARITHM))
					&&((r1 == s2_r1)||(r1 == s3_r1)&&!(s2_opcode == LW));
	assign haz[5] = (haz5) ? 1'b1: 1'b0;
	
	// Multiply or divide is followed directly by a branch
	// instruction(What registers they specify does not matter.
	// This is for R0 which is implicitly used by all 3 types)
	assign haz6 = ((opcode == BE)||(opcode == BLT)||(opcode == BGT))
					&&((s2_R0_en)); // Only if MULT or DIV
	assign haz[6] = (haz6) ? 1'b1: 1'b0;
	
	// Multiply or divide is followed 2 instructions later by
	// a branch instruction(What registers they specify does
	// not matter. This is for R0 which is implicitly used by
	// all 3 types)
	assign haz7 = ((opcode == BE)||(opcode == BLT)||(opcode == BGT))
					&&((s3_R0_en)); // Only if MULT or DIV
	assign haz[7] = (haz7) ? 1'b1: 1'b0;
	

	// ==================================================
	// These LW/SW things might be checking the wrong registers
	// Check here if problems occur
	//=======================================================

	// LOAD is followed directly by a STORE instruction
	// using same reg for dest(load)/src(store)
	assign haz8 = ((opcode == SW))
					&&((s2_opcode == LW))
					&&((r1 == s2_r1)||(r2 == s2_r1));
	assign haz[8] = (haz8) ? 1'b1: 1'b0;
	
	// LOAD is followed 2 instructions later by a STORE
	// instruction using same reg for dest(load)/src(store)
	assign haz9 = ((opcode == SW))
					&&((s3_opcode == LW))
					&&((r1 == s3_r1)||(r2 == s3_r1));
	assign haz[9] = (haz9) ? 1'b1: 1'b0;
	// Arithmetic instruction followed directly by a STORE
	// instruction using same reg for dest/src
	assign haz10 = ((opcode == SW))
					&&((s2_opcode == ARITHM))
					&&((r1 == s2_r1)||(r2 == s2_r1));
	assign haz[10] = (haz10) ? 1'b1: 1'b0;
	// LOAD is followed directly by a branch instruction
	// using the dest register for compare
	assign stall_logic = ((opcode == BE)||(opcode == BLT)||(opcode == BGT))
					&&((s2_opcode == LW))
					&&((r1 == s2_r1)||(r2 == s2_r1));
	assign stall = (stall_logic) ? 1'b1: 1'b0;

	always_comb begin
		assert($oneshot(haz));
	end
endmodule
