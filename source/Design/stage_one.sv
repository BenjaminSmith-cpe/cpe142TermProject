module stage_one(
    	input wire          clk,
    	input wire          rst,
        
        input wire [15:0]   s2_instruction,
        input wire [15:0]   s3_instruction,
         
        input wire          s2_R0_en,
        input wire          s3_R0_en,

        input wire [31:0]   s2_alu,
        input wire [31:0]   s3_alu,
        input wire [31:0]   s3_data,
        
        input wire          s3_reg_wr,
        input wire          s3_mem2r,

        //flopped outputs
        output reg          stall,
        output reg          halt_sys,
        output types_pkg::memc_t  out_memc,    
        output reg          out_reg_wr,  
        output alu_pkg::in_t         out_alu,    
        output reg          out_haz1,    
        output reg          out_haz2,
        output reg          out_haz8, 
        output reg          out_R0_en,  
        output alu_pkg::control_e    out_alu_ctrl,
        output types_pkg::uword	    out_instr,
        output types_pkg::uword	    out_R1_data,
        
        output types_pkg::memc_t memc
    );

    import types_pkg::*;
	import alu_pkg::*;
	
    //| Local logic instantiations
    //| ============================================================================
    uword PC_address;

    logic [15:0] instruction;

    opcode_t        opcode;
    control_e       func_code;

    sel_t           offset_sel;
    wire    [15:0]  offset_se;
    wire    [15:0]  offset_shifted;

    wire    [15:0]  cmp_a;
    wire    [15:0]  cmp_b;
    result_t        cmp_result;

    wire    [15:0]  PC_no_jump;
    wire    [15:0]  PC_jump;
    wire    [15:0]  PC_next;

    uword   		R1_data;
    uword			R1_data_muxed;
    wire    [15:0]  r2_data;

    wire    [10:0]  haz;
	wire 			R0_en;
	
	reg 		R0_read;
	memc_t 		s3_memc;
	reg 		ALUop;
	reg 		reg_wr;
	reg 		se_imm_a;
	control_e 	alucontrol;
	reg 		immb;
	reg 		jmp;
	in_t		alu_muxed;
	
    assign opcode = opcode_t'(instruction[15:12]);
    assign func_code = control_e'(instruction[3:0]);

    //| Stage 1 Flip-Flop
    //| ============================================================================
    always_ff@ (posedge clk or posedge rst) begin: stage_A_flop
        if (rst) begin      
            out_memc        <= memc_t'(2'd0);
            out_reg_wr      <= 1'd0;
            out_alu.a       <= 16'd0;
            out_alu.b       <= 16'd0;
            out_R1_data     <= 16'd0;
            out_haz1        <= 1'b0;
            out_haz2        <= 1'b0;
            out_haz8        <= 1'b0;
            out_R0_en       <= 1'd0;
            out_alu_ctrl    <= ADD;
            out_instr       <= 8'd0;    // Top 8 bits of instruction // If rst is asserted, we want to clear the flops
        
        end 
        else begin
            if(halt_sys || stall) begin
                // Stay the same value. System is halted.
            end
            else                // Flop the input
                out_memc        <= memc;
                out_reg_wr      <= reg_wr;
                out_alu       	<= alu_muxed;
                out_R1_data     <= R1_data_muxed;
                out_haz1        <= haz[1];
                out_haz2        <= haz[2];
                out_haz8        <= haz[8];
                out_R0_en       <= R0_en;
                out_alu_ctrl    <= alucontrol;
                out_instr       <= instruction;
        end
    end

    //| PC adder instantiation
    //| ============================================================================
    adder pc_adder(
        .pc(PC_address),
        .offset(16'd2),
        .sum(PC_no_jump)
    );

    //| Jump adder instantiation
    //| ============================================================================
    adder jump_adder(
        .pc(PC_no_jump),
        .offset(offset_shifted),
        .sum(PC_jump)
    );

    //| Memory Instantiations
    //| ============================================================================
    mem_program program_memory(
        .address(PC_address),   
        .data_out(instruction)
    );

    reg_program_counter pc_reg(
        .clk(clk),
        .rst(rst),

        .halt_sys(halt_sys),    // Control signal from main control to halt cpu
        .stall(stall),          // Control signal from hazard unit to stall for one cycle

        .in_address(PC_next),   // Next PC address
        .out_address(PC_address)// Current PC address
    );

    mem_register register_file (
        .rst(rst),
        .clk(clk),
        .halt_sys(halt_sys),

        .R0_read(R0_read),
        .ra1(instruction[11:8]),
        .ra2(instruction[7:4]),

        .write_en(s3_reg_wr || s3_mem2r),
        .R0_en(s3_R0_en),
        .write_address(s3_instruction[11:8]), // r1 address
        .write_data(s3_data),

        .rd1(R1_data),
        .rd2(r2_data)
    );
    

    //| Main Control Unit
    //| ============================================================================
    control_main Control_unit(
        .opcode(opcode),
        .func(func_code),
        .div0(1'b0),
        .overflow(1'b0),

        .ALUop(ALUop),
        .offset_sel(offset_sel),
        
        .mem2r(memc.mem2r),
        .memwr(memc.memwr),
        .halt_sys(halt_sys),
        .reg_wr(reg_wr),
        .R0_read(R0_read),
        .se_imm_a(se_imm_a)
    );

    control_alu alu_control(
        .func(func_code),
        .ALUop(ALUop),

        .alu_ctrl(alucontrol),
        .immb(immb),
        .R0_en(R0_en)
    );

    control_jump jump_unit(
        .cmp_result(cmp_result),
        .opcode(opcode),

        .jmp(jmp)
    );

    //| Hazard Detection Unit
    //| ============================================================================
    control_hazard_unit HDU(
        .s2_R0_en(s2_R0_en),
        .s3_R0_en(s3_R0_en),
        .opcode(opcode),
        .s2_opcode(opcode_t'(out_instr[15:12])), // s2 and s3 instructions hold
        .s3_opcode(opcode_t'(s3_instruction[15:12])), // top 8 bits of that instr 

        .r1(instruction[11:8]),
        .r2(instruction[7:4]),
        .s2_r1(out_instr[11:8]),
        .s3_r1(s3_instruction[11:8]),

        .haz(haz),
        .stall(stall)
    );


    //| Sign Extending unitw
    //| ============================================================================
    sign_extender sign_extend(
        .offset_sel(offset_sel),
        .input_value(instruction[11:0]),    // 11:0 to handle all 3 different sized offsets.

        .se_value(offset_se)
    );

    //| Shift Left Unit
    //| ============================================================================
    shift_one shift1(
        .in(offset_se),
        .out(offset_shifted)
    );


    //| Comparator
    //| ============================================================================
    comparator cmp(
        .in1(cmp_a),
        .in2(cmp_b),

        .cmp_result(cmp_result)
    );

    //| Mux
    //| ============================================================================
    mux #(
        .SIZE(16), 
        .IS3WAY(0)
    )Mux0(
        .sel(jmp),
        .in1(PC_no_jump),
        .in2(PC_jump),
    	.in3(16'b0),
    	
        .out(PC_next)
    );

    //| Mux before comparator with R1
    //| ============================================================================
    mux #(
        .SIZE(16), 
        .IS3WAY(1)
    )mux1(
        .sel({haz[4], haz[5]}),
    
        .in1(R1_data),
        .in2(s2_alu[15:0]),
        .in3(s3_data[15:0]),
    
        .out(cmp_a)
    );

    //| Mux before comparator with R2
    //| ============================================================================
    mux #(
        .SIZE(16), 
        .IS3WAY(1)
    )mux2(
        .sel({haz[6], haz[7]}),
    
        .in1(r2_data),
        .in2(s2_alu[31:16]),
        .in3(s3_data[31:16]),
    
        .out(cmp_b)
    );
    
    //| Mux for R1_data
    //| ============================================================================
    mux #(
        .SIZE(16), 
        .IS3WAY(1)
    )mux3(
        .sel({haz[10], haz[9]}),    // mem2r
    
        .in1(R1_data),
        .in2(s2_alu[15:0]),
        .in3(s3_data[15:0]),
    
        .out(R1_data_muxed)
    );
    
    //| Mux for ALU_a
    //| ============================================================================
    mux #(
        .SIZE(16), 
        .IS3WAY(1)
    )mux4(
        .sel({haz[0], se_imm_a}),    
        .in1(R1_data),
        .in2(s3_data[15:0]),
    	.in3(offset_se),
    	
        .out(alu_muxed.a)
    );
    
    //| Mux for ALU_B
    //| ============================================================================
    mux #(
        .SIZE(16), 
        .IS3WAY(1)
    )mux5(
        .sel({immb, haz[3]}),
        .in1(r2_data),
        .in2({12'd0, instruction[7:4]}),
        .in3(s3_data[15:0]),
    
        .out(alu_muxed.b)
    );
    
endmodule
