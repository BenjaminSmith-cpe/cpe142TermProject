module stage_three(

    );
    
    wire    [1:0]   s2_memc;
    wire    [1:0]   s3_memc;
    wire    [31:0]  s3_data;
    wire    [31:0]  s3_alu;

    wire    [15:0]  s3_r1_data;
    wire    [7:0]   s3_instruction;

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