//
// Stage two instantiation and wiring
//
// This module instantiates and connects together all of the 
// individual components in the second stage of the processor. 
// it also contains the second pipeline flip flop.
// The ALU is the main module that resides here
//

module stage_two(
        input rst,
        input clk,

        input reg halt_sys,
        input reg stall,

        input types_pkg::memc_t in_memc,
        input alu_pkg::in_t in_alu,
        input alu_pkg::control_e alu_control,
        input [15:0] in_R1_data,
        input in_R0_en,
        input wire [15:0] in_instr,
        input wire haz1,    
        input wire haz2,
        input wire haz8, 
        input wire [31:0] s3_data,
        input wire in_reg_wr,
        output reg out_reg_wr,
        output types_pkg::memc_t out_memc,   
        output reg [31:0] out_alu,  
        output reg [31:0] out_alu_result,
        output reg [15:0] out_R1_data,  
        output reg out_R0_en,  
        output reg [15:0] out_instr,
        output alu_pkg::status_t out_alu_stat
    );
    
    import alu_pkg::*;
    import types_pkg::*;
    
    control_e alucontrol;
    integer aluout;
    reg     [15:0]  in_R1_data_muxed;

    in_t alu_muxed;

    assign out_alu_result = aluout;
    //| Stage B flip flop
    //| =======================================================
    always_ff@ (posedge clk or posedge rst) begin: stage_B_flop
        if (rst) begin      
            out_memc        <= memc_t'(2'd0);
            out_alu         <= 32'd0;
            out_R1_data     <= 16'd0;
            out_R0_en       <= 1'd0;
            out_instr       <= 8'd0;    // Top 8 bits of instruction // If rst is asserted, we want to clear the flops
            out_reg_wr      <= 1'd0;
        end 
        else begin
            if(halt_sys || stall) begin
                // Stay the same value. System is halted.
            end
            else                // Flop the input
                out_memc        <= in_memc;
                out_alu         <= aluout;
                out_R1_data     <= in_R1_data_muxed;
                out_R0_en       <= in_R0_en;
                out_instr       <= in_instr;
                out_reg_wr      <= in_reg_wr;
        end
    end

    mux #(
        .SIZE(16), 
        .IS3WAY(0)
    )muxa(
        .sel(haz1),    
        .in1(in_alu.a),
        .in2(s3_data[15:0]),
        .in3(16'b0),
        
        .out(alu_muxed.a)
    );
    
    mux #(
        .SIZE(16), 
        .IS3WAY(0)
    )muxb(
        .sel(haz2),    
        .in1(in_alu.b),
        .in2(s3_data[15:0]),
        .in3(16'b0),
        
        .out(alu_muxed.b)
    );
    
    mux #(
        .SIZE(16),
        .IS3WAY(0)
    )muxc(
        .sel(haz8),
        .in1(in_R1_data),
        .in2(s3_data[15:0]),
        .in3(16'b0),

        .out(in_R1_data_muxed)
    );

    //| ALU instantiation
    //| ============================================================================
    alu main_alu(
        .in     (alu_muxed),
        .control(alu_control),
        .stat   (out_alu_stat),
        .out    (aluout)
    );


endmodule
