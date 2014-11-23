package types_pkg;
    import alu_pkg::*;

    typedef enum logic[1:0]{
            GREATER         = 2'b00,
            LESS            = 2'b01,
            EQUAL           = 2'b10,
            UNKNOWN         = 2'b11       
    } result_t;

    typedef enum logic[3:0]{
        ARITHM      = 4'b0000,
        LW          = 4'b1000,
        SW          = 4'b1011,
        BLT         = 4'b0100,
        BGT         = 4'b0101,
        BE          = 4'b0110,
        JMP         = 4'b1100,
        HALT        = 4'b1111      
    } opcode_t;
endpackage