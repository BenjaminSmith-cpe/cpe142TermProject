module comparator(
    input wire      [15:0]  in1,
    input wire      [15:0]  in2,

    output types_pkg::result_t  cmp_result
);
    import types_pkg::*;
    
    assign cmp_result = (in1 > in2) ? GREATER   :
                        (in1 < in2) ? LESS      :
                        (in1 == in2)? EQUAL     :
                                      UNKNOWN;

endmodule
