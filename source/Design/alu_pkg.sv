package alu_pkg;
    
    typedef logic signed [15:0] word_16;

    typedef enum logic[1:0]{
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
        word_16 a;
        word_16 b;
    } in_t;

endpackage