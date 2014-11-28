module stage_two(
        input rst,
        input clk,

        input reg halt_sys,
        input reg stall,

        input types_pkg::memc_t in_memc,
        input alu_pkg::in_t in_alu,
        input in_R1_data,
        input in_R0_en,
        input wire [15:0] in_instr,
        
        output types_pkg::memc_t out_memc,   
        output reg [31:0] out_alu,  
        output reg out_R1_data,  
        output reg out_R0_en,  
        output reg [15:0] out_instr
    );
    
	import alu_pkg::*;
	import types_pkg::*;
	
    in_t  aluin;
    control_e alucontrol;
    status_t alustat;
    integer aluout;

    wire    [15:0]  s2_alu_a;
    wire    [15:0]  s2_alu_b;
    control_e       s2_alu_ctrl;
    
    wire    [15:0]  s2_r1_muxed;
    wire    [15:0]  s2_r1_data;
    wire    [7:0]   s2_instruction;
    wire    [15:0]  s1_r1_data;

    //| Stage B flip flop
    //| =======================================================
    always_ff@ (posedge clk or posedge rst) begin: stage_B_flop
        if (rst) begin      
            out_memc        <= memc_t'(2'd0);
            out_alu         <= 32'd0;
            out_R1_data     <= 16'd0;
            out_R0_en       <= 1'd0;
            out_instr       <= 8'd0;    // Top 8 bits of instruction // If rst is asserted, we want to clear the flops
        end 
        else begin
            if(halt_sys || stall) begin
                // Stay the same value. System is halted.
            end
            else                // Flop the input
                out_memc        <= in_memc;
                out_alu         <= aluout;
                out_R1_data     <= in_R1_data;
                out_R0_en       <= in_R0_en;
                out_instr       <= in_instr;
        end
    end

    //| ALU instantiation
    //| ============================================================================

    alu main_alu(
        .in     (aluin),
        .control(s2_alu_ctrl),
        .stat   (alustat),
        .out    (aluout)
    );


endmodule
