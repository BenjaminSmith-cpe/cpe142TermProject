module stage_three(
    input   wire            clk,
    input   wire            rst,
    input   reg     [31:0]  s3_alu,
    input   wire    [1:0]   s3_memc,
    input   wire    [15:0]  s3_r1_data,
    input   wire    [15:0]  s3_instruction,
    input 	wire			halt_sys,
    
    output  reg		[31:0]  s3_data
);

	assign s3_data_out = {s3_alu[31:16], s3_data[15:0]};
	
    mux #(.SIZE(16), .IS3WAY(0)) mux9(
        .sel(s3_memc[1]),   // mem2r
        .in1(mem_data),
        .in2(s3_alu[15:0]),
        .in3(),
    
        .out(s3_data[15:0])
    );

    //| Main Memory
    //| ============================================================================
    mem_main main_memory(
        .rst(rst),
        .clk(clk),
        .halt_sys(halt_sys),


        .write_en(s3_memc[0]),  //memwr
        .address(s3_alu[15:0]),
        .write_data(s3_r1_data),

        .data_out(mem_data)
    );
 
endmodule
