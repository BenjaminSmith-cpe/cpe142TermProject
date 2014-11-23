interface alu_interface;
    import alu_pkg::*;

    status_t   stat;
    in_t       in;
    control_e  control;
    word_16    out;

    modport tb(
    	 stat, control, out,
    	 in
    );
endinterface