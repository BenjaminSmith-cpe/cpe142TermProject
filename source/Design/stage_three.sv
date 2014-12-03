module stage_three(
    input   wire                clk,
    input   wire                rst,
    input   types_pkg::uword    instruction,
    
    input   reg     [31:0]      alu,
    input   types_pkg::memc_t   memc,
    input   types_pkg::uword    r1_data,
    input   wire                r0_en,
    input   wire                halt_sys,
    
    output  reg     [31:0]      data,
    output  types_pkg::uword    r1_data_out,
    output  types_pkg::memc_t   out_memc,
    output  reg                 out_r0_en,
    output  types_pkg::uword    instruction_out
);
    import types_pkg::*;
    
    logic [15:0]    data_muxed;
    uword           mem_data;
    opcode_t        opcode;
    
    assign data            = {alu[31:16], data_muxed[15:0]};
    assign out_r0_en       = r0_en;
    assign out_memc        = memc;
    assign instruction_out = instruction;
    assign r1_data_out     = r1_data;
    assign opcode          = opcode_t'(instruction[15:12]);

    mux #(
        .SIZE(16), 
        .IS3WAY(0)
    )mux9(
        .sel(memc.mem2r),
        .in1(alu[15:0]),
        .in2(mem_data),
        .in3(16'b0),
    
        .out(data_muxed[15:0])
    );

    //| Main Memory
    //| ============================================================================
    mem_main main_memory(
        .rst(rst),
        .clk(clk),
        .halt_sys(halt_sys),

        .write_en(memc.memwr),
        .address(alu[15:0]),
        .write_data(r1_data),

        .data_out(mem_data)
    );
 
endmodule
