interface alu_interface;
    import alu_pkg::*;

    status_t   stat;
    in_t       in;
    control_e  control;
    word_16    out;

    modport tb(
    	 output stat, control, out,
    	 input in
    );
endinterface

interface adder_interface;
    input wire  [15:0]  pc,
    input wire  [15:0]  offset,

    output logic[15:0]  sum

    modport tb(
         output pc, offset
         input sum
    );
endinterface