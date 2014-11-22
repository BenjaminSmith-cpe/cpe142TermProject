//all control lines for interface
//
interface alu_interface;
    import alu_pkg::*;

    status_t                stat;
    in_t                    in;
    control_e               control;

    logic signed [31:0]     out;

    modport tb (
    	stat, control, out,
    	in
    );
endinterface