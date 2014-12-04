//
// Shift one module
//
// This module just shifts the 16 input to the left
// by one. This is used for the jump and branch offset
// since the instructions are 2 bytes long
//

module shift_one(
    input wire   [15:0] in,

    output logic [15:0] out
);

    assign out = {in << 1};

endmodule   
