module stage_one(
    	input wire          clk,
    	input wire          rst,
        
        input wire          R1_data,
        input wire          alu_ctrl,

        input wire [31:0]   aluout,
        
        input wire          instr,
        input wire [16:0]   s2_instruction,
        input wire [16:0]   s3_instruction,
        
        input wire          R0_en,
        input wire          s2_R0_en,
        input wire          s3_R0_en,
        
        input wire          s3_alu,
        input wire          s3_data,


        //flopped outputs
        output reg          stall,
        output reg          halt_sys,
        output reg          out_memc,    
        output reg          out_reg_wr,  
        output in_t         out_alu,    
        output reg          out_R1_data, 
        output reg          out_haz1,    
        output reg          out_haz2,    
        output reg          out_R0_en,   
        output control_e    out_alu_ctrl,
        output reg [15:0]   out_instr
    );

   import types_pkg::*;

    //| Local logic instantiations
    //| ============================================================================
    uword PC_address;
    uword PC_next_jump;
    uword PC_next_nojump;

    logic [15:0] instruction;

    opcode_t        opcode;
    control_e       func_code;

    sel_t           offset_sel;
    wire    [15:0]  offset_se;
    wire    [15:0]  offset_shifted;

    wire    [15:0]  cmp_a;
    wire    [15:0]  cmp_b;
    result_t        cmp_result;

    wire    [15:0]  in_alu_a;
    wire    [15:0]  in_alu_b;
    
    wire    [15:0]  mem_data;

    wire    [15:0]  PC_no_jump;
    wire    [15:0]  PC_jump;
    wire    [15:0]  PC_next;

    wire    [15:0]  r1_data;
    wire    [15:0]  r2_data;

    wire    [10:0]  haz;

    assign s3_data[31:16] = s3_alu[31:16];
    assign opcode = opcode_t'(instruction[15:12]);
    assign func_code = control_e'(instruction[3:0]);

    //| Stage 1 Flip-Flop
    //| ============================================================================
    always_ff@ (posedge clk or posedge rst) begin: stage_A_flop
        if (rst) begin      
            out_memc        <= 2'd0;
            out_reg_wr      <= 1'd0;
            out_alu.a       <= 16'd0;
            out_alu.b       <= 16'd0;
            out_R1_data     <= 16'd0;
            out_haz1        <= 1'b0;
            out_haz2        <= 1'b0;
            out_R0_en       <= 1'd0;
            out_alu_ctrl    <= ADD;
            out_instr       <= 8'd0;    // Top 8 bits of instruction // If rst is asserted, we want to clear the flops
        end 
        else begin
            if(halt_sys || stall) begin
                // Stay the same value. System is halted.
            end
            else                // Flop the input
                out_memc        <= in_memc;
                out_reg_wr      <= in_reg_wr;
                out_alu.a       <= in_alu_a;
                out_alu.b       <= in_alu_b;
                out_R1_data     <= in_R1_data;
                out_haz1        <= in_haz1;
                out_haz2        <= in_haz2;
                out_R0_en       <= in_R0_en;
                out_alu_ctrl    <= in_alu_ctrl;
                out_instr       <= in_instr;
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
        .pc(PC_address),
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

        .write_en(s3_reg_wr),
        .R0_en(s3_R0_en),
        .write_address(s3_instruction[3:0]), // r1 address
        .write_data(s3_data),

        .rd1(r1_data),
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
        
        .mem2r(mem2r),
        .memwr(memwr),
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
        .R0_en(R0_en),
        .s2_R0_en(s2_R0_en),
        .s3_R0_en(s3_R0_en),
        .opcode(opcode),
        .s2_opcode(opcode_t'(s2_instruction[7:4])), // s2 and s3 instructions hold
        .s3_opcode(opcode_t'(s3_instruction[7:4])), // top 8 bits of that instr 

        .r1(instruction[11:8]),
        .r2(instruction[7:4]),
        .s2_r1(s2_instruction[3:0]),
        .s3_r1(s3_instruction[3:0]),

        .haz(haz),
        .stall(stall)
    );


    //| Sign Extending unit
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
    
        .out(PC_next)
    );

    //| Mux before comparator with R1
    //| ============================================================================
    mux #(
        .SIZE(16), 
        .IS3WAY(1)
    )mux1(
        .sel({haz[4], haz[5]}),
    
        .in1(r1_data),
        .in2(aluout[15:0]),
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
        .in2(aluout[31:16]),
        .in3(s3_data[31:16]),
    
        .out(cmp_b)
    );
    
    //| Mux for r1_data
    //| ============================================================================
    mux #(
        .SIZE(16), 
        .IS3WAY(1)
    )mux3(
        .sel({haz[9], haz[10]}),    // mem2r
    
        .in1(r1_data),
        .in2(aluout[15:0]),
        .in3(mem_data),
    
        .out(s1_r1_data)
    );
    
    //| Mux for ALU_a
    //| ============================================================================
    mux #(
        .SIZE(16), 
        .IS3WAY(0)
    )mux4(
        .sel(haz[0]),    
        .in1(r1_data),
        .in2(s3_data[15:0]),
    
        .out(in_alu_a)
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
    
        .out(in_alu_b)
    );
    
endmodule
