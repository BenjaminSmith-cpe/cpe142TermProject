module top (
	input wire clk,
	input wire rst
);
	
	import types_pkg::*;
	import alu_pkg::*;

    //| Stage One
    memc_t		    memc;
    
    reg             s1_R0_en;

    types_pkg::memc_t s1_memc;    
    reg             s1_reg_wr;  
    reg             halt_sys;
    reg             stall;
    in_t            s1_alu_inputs;    
    uword		    s1_R1_data; 
    uword		    s1_instruction; 
    uword		    s2_instruction; 
    control_e       s1_alu_control;
    
    //| Stage Two
    memc_t   		s2_memc;
       
    //| stage 3
    wire 	[31:0]	s3_alu;
    memc_t   		s3_memc;
    uword		    s3_R1_data;
    uword		    s3_instruction;
    wire    [31:0]  s3_data;
    reg             s3_R0_en;
    reg				s1_haz2;
    reg				s1_haz1;
    reg             s1_haz8;
    wire    [31:0]  s2_alu_result;
    uword 			s2_R1_data;
    
    stage_one st1(
        .clk(clk),
        .rst(rst),
        .s3_data(s3_data),
        .s2_instruction(s2_instruction),
        .s3_instruction(s3_instruction),
        .s2_R0_en(s1_R0_en),
        .s3_R0_en(s3_R0_en),
        .s2_alu(s2_alu_result),
        .memc(memc),

		.s3_alu(s3_alu),
		.s3_reg_wr(s3_memc.mem2r),

        //outputs
        .out_memc(s1_memc), 
        .out_R1_data(s1_R1_data),   
        .out_reg_wr(s1_reg_wr),  
        .halt_sys(halt_sys),
        .stall(stall),
        .out_alu(s1_alu_inputs),    
        .out_haz1(s1_haz1),    
        .out_haz2(s1_haz2),    
        .out_haz8(s1_haz8),
        .out_R0_en(s1_R0_en),   
        .out_alu_ctrl(s1_alu_control),
        .out_instr(s1_instruction)
	);

	stage_two st2(
        .rst(rst),
        .clk(clk),

        .halt_sys(halt_sys),
        .stall(stall),

        .in_alu(s1_alu_inputs),
        .in_R1_data(s1_R1_data),
        .in_R0_en(s1_R0_en),
        .in_instr(s1_instruction),
        .in_memc(s1_memc),
        .haz1(s1_haz1),
        .haz2(s1_haz2),
        .haz8(s1_haz8),
        .s3_data(s3_data),
        .alu_control(s1_alu_control),
        
        .out_memc(s2_memc),
        .out_alu_result(s2_alu_result),  
        .out_alu(s3_alu),  
        .out_R1_data(s2_R1_data),  
        .out_R0_en(s3_R0_en),  
        .out_instr(s2_instruction)
	);

    stage_three st3(
        .clk(clk),
        .rst(rst),
		.memc(s2_memc),
		.instruction(s2_instruction),
        .r1_data(s2_R1_data),
        		
		.halt_sys(halt_sys),
        .alu(s3_alu),
        .out_memc(s3_memc),
        .r0_en(s3_R0_en),
        
        .instruction_out(s3_instruction),
        .out_r0_en(),
        .r1_data_out(s3_R1_data),
        .data(s3_data)
    );
endmodule
