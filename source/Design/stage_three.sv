module stage_three(
    input   wire            clk,
    input   wire            rst,
    
    input   reg     [31:0]  alu,
    input   types_pkg::memc_t memc,
    input   wire    [15:0]  r1_data,
    input   wire 			r0_en,
    //output  wire    [15:0]  instruction,
    input 	wire			halt_sys,
    
    output  reg		[31:0]  data,
    output 	reg		[15:0]	mem_data,
    output types_pkg::memc_t out_memc,
    output	reg		out_r0_en
);
	
	logic [15:0] data_muxed;
	
	assign data = {alu[31:16], data_muxed[15:0]};
	assign r0_en = out_r0_en;
	
    mux #(.SIZE(16), .IS3WAY(0)) mux9(
        .sel(memc.mem2r),
        .in1(mem_data),
        .in2(alu[15:0]),
        .in3(),
    
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
