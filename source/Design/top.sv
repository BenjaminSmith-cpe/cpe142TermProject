module top (
	input wire clk,
	input wire rst
);
	
	import types_pkg::*;
	import alu_pkg::*;

    //| Stage One
    memc_t		    memc;
    
    reg             in_reg_wr; 
    reg             in_R1_data;
    reg     [15:0]  s1_instr;
    reg             s1_R0_en;
    reg             in_R0_en;
	reg		[15:0]	s1_R1_data;
    
    reg     [15:0]  in_instr;

    types_pkg::memc_t s1_memc;    
    reg             s1_reg_wr;  
    reg             halt_sys;
    reg             stall;
    in_t            s1_alu_inputs;    
    reg   [15:0]      s1_R1_data; 
    reg             out_haz1;    
    reg             out_haz2;    
    reg             out_R0_en;   
    control_e       out_alu_ctrl;
    
    //| Stage Two
    in_t            s2_in_alu;
    reg     [31:0]  s2_alu_out;
    memc_t   		s2_memc;
    reg     	    s2_reg_wr;
    reg     	    s2_r1_data;
    reg             s2_R0_en;
    reg     [15:0]  s2_instruction;
       
    //| stage 3
    reg     [31:0]  s3_alu;
    memc_t   		s3_memc;
    wire    [15:0]  s3_r1_data;
    wire    [15:0]  s3_instruction;
    wire    [31:0]  s3_data;
    reg             s3_R0_en;
    
    stage_one st1(
        .clk(clk),
        .rst(rst),
        .s3_data(s3_data),
        .aluout(s2_alu_out),
        .s2_instruction(s2_instruction),
        .s3_instruction(s3_instruction),
        .s2_R0_en(s2_R0_en),
        .s3_R0_en(s3_R0_en),
        .memc(memc),

		.s3_alu(s3_alu),
		.s2_R1_data(s1_R1_data),
		.s3_reg_wr(s3_memc.mem2r),

        //outputs
        .out_memc(s1_memc), 
        .out_R1_data(s1_R1_data),   
        .out_reg_wr(s1_reg_wr),  
        .halt_sys(halt_sys),
        .stall(stall),
        .out_alu(s1_alu_inputs),    
        .out_haz1(out_haz1),    
        .out_haz2(out_haz2),    
        .out_R0_en(s1_R0_en),   
        .out_alu_ctrl(out_alu_ctrl),
        .out_instr(s1_instr)
	);

	stage_two st2(
        .rst(rst),
        .clk(clk),

        .halt_sys(halt_sys),
        .stall(stall),

        .in_alu(s1_alu_inputs),
        .in_R1_data(s1_R1_data),
        .in_R0_en(s1_R0_en),
        .in_instr(s1_instr),
        .in_memc(s1_memc),
          
        .out_memc(s2_memc),  
        .out_alu(s2_alu_out),  
        .out_R1_data(s2_r1_data),  
        .out_R0_en(s3_R0_en),  
        .out_instr(s3_instruction)
	);

    stage_three st3(
        .clk(clk),
        .rst(rst),
		.memc(s2_memc),
		
		.halt_sys(halt_sys),
        .alu(s3_alu),
        .out_memc(s3_memc),
        .r0_en(s3_R0_en),
        .r1_data(s3_r1_data),
        //.instruction(s3_instruction),
        .data(s3_data),
        .mem_data()
    );
endmodule
