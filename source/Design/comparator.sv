// Comparator module 
//
// This module compares input 1 with input 2
// Outputs the result of the comparison
//

module comparator(
    input wire      [15:0]  in1,
    input wire      [15:0]  in2,

    output types_pkg::result_t  cmp_result
);
    import types_pkg::*;
    
    // determine relationship between in1 and in2
    assign cmp_result = (in1 > in2) ? GREATER   :
                        (in1 < in2) ? LESS      :
                        (in1 == in2)? EQUAL     :
                                      UNKNOWN;

endmodule
