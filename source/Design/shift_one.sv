module shift_one(
    input wire   [15:0] in,

    output logic [15:0] out
);

    assign out = {in << 1};

endmodule   
