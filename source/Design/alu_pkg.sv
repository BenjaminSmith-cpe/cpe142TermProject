// alu package module 
//
// This file contains the data types we are using for the ALU
// 
//

package alu_pkg;
    
    typedef logic signed [15:0] word_16;
    // the control_e signal tells the ALU what operation to perform
    typedef enum logic[3:0]{
        MULT= 4'h1,
        DIV = 4'h2,
        ROL = 4'h8,
        ROR = 4'h9,
        SHL = 4'hA,
        SHR = 4'hB,
        OR  = 4'hC,
        AND = 4'hD,
        SUB = 4'hE,
        ADD = 4'hF
    } control_e;
    
    // Status flags for ALU
    // sign asserted when positive
    typedef struct{
        logic   sign;
        logic   overflow;
        logic   zero;
        logic   div0;
    } status_t;

    // Status flags for ALU
    // sign asserted when positive
    typedef struct{
        word_16 a;
        word_16 b;
    } in_t;

endpackage
