module top (
	input wire clk,
	input wire rst
);
	
	import types_pkg::*;
	import alu_pkg::*;

    //| Stage One
    reg [31:0]  aluout;
    reg [15:0]  s2_instruction;
    reg         s2_R0_en;
    reg         s3_R0_en;
    reg         in_memc;

    reg         in_reg_wr; 
    reg         in_R1_data;
    reg         in_haz1;
    reg         in_haz2;
    reg         in_R0_en;
    control_e         in_alu_ctrl;
    reg [15:0]        in_instr;

    reg         out_memc;    
    reg         out_reg_wr;  
    reg         halt_sys;
    reg         stall;
    in_t        s1_alu_inputs;    
    reg         out_R1_data; 
    reg         out_haz1;    
    reg         out_haz2;    
    reg         out_R0_en;   
    control_e   out_alu_ctrl;
    reg [15:0]  out_instr;

    //| Stage Two
    in_t in_alu;
    reg [31:0] s2_alu_out;

    //| stage 3
    reg     [31:0]  s3_alu;
    wire    [1:0]   s3_memc;
    wire    [15:0]  s3_r1_data;
    wire    [15:0]  s3_instruction;
    wire    [15:0]  s3_data;

	stage_one st1(
        .clk(clk),
        .rst(rst),
        .s3_data(s3_data),
        .aluout(aluout),
        .s2_instruction(s2_instruction),
        .s3_instruction(s3_instruction),
        .s2_R0_en(s2_R0_en),
        .s3_R0_en(s3_R0_en),
        .s3_alu(s3_alu),
        .in_memc(in_memc),

        .in_reg_wr(in_reg_wr), 
        .in_R1_data(in_R1_data),
        .in_haz1(in_haz1),
        .in_haz2(in_haz2),
        .in_R0_en(in_R0_en),
        .in_alu_ctrl(in_alu_ctrl),
        .in_instr(in_instr),

        //flopped outputs
        .out_memc(out_memc),    
        .out_reg_wr(out_reg_wr),  
        .halt_sys(halt_sys),
        .stall(stall),
        .out_alu(s1_alu_inputs),    
        .out_R1_data(out_R1_data), 
        .out_haz1(out_haz1),    
        .out_haz2(out_haz2),    
        .out_R0_en(out_R0_en),   
        .out_alu_ctrl(out_alu_ctrl),
        .out_instr(out_instr)
	);

	stage_two st2(
        .rst(rst),
        .clk(clk),

        .halt_sys(halt_sys),
        .stall(stall),

        .in_reg_wr(in_reg_wr),
        .in_alu(s1_alu_inputs),
        .in_R1_data(in_R1_data),
        .in_R0_en(in_R0_en),
        .in_instr(in_instr),
        .in_memc(in_memc),
        
        .out_memc(out_memc),  
        .out_reg_wr(out_reg_wr),  
        .out_alu(s2_alu_out),  
        .out_R1_data(out_R1_data),  
        .out_R0_en(out_R0_en),  
        .out_instr(out_instr)
	);

    stage_three st3(
        .clk(clk),
        .rst(rst),

		.halt_sys(halt_sys),
        .s3_alu(s3_alu),
        .s3_memc(s3_memc),
        .s3_r1_data(s3_r1_data),
        .s3_instruction(s3_instruction),
        .s3_data_out(s3_data)
    );
endmodule
