package alu_pkg;

    typedef enum [1:0]{
        add      = 2'b00,
        subtract = 2'b01,
        bitw_or  = 2'b10,
        bitw_and = 2'b11
    } control_e;
    
    // Status flags for ALU
    // sign asserted when positive
    typedef struct{
        logic   sign;
        logic   overflow;
        logic   zero;
    } status_t;

    // Status flags for ALU
    // sign asserted when positive
    typedef struct{
        logic signed [31:0]  a;
        logic signed [31:0]  b;
    } in_t;

endpackage