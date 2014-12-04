// `define VERBOSE //Prints information about test success, otherwise only
                   //failing checks will print information

// `define BOUNDED_INPUTS   //limits magnitutde of ALU inputs

typedef enum{RESET, IDLE, HAZARD, FULLTEST, HAZ0, HAZ1, HAZ2, HAZ3, HAZ4, HAZ5, HAZ6, HAZ7, HAZ8, HAZ9, HAZ10, STALL} SimPhase_e;

module system_tb();
    import alu_pkg::*;
    import types_pkg::*;
    
    integer             testiteration = 0;
    integer             failure_count = 0;
    
    reg     [15:0]register_temp[4:0];
    
    logic clock = 0;
    logic reset = 0;
    
    uword memcheck;
    uword memcheck2;
    
    top dut(
        .clk(clock),
        .rst(reset)
    );
    
    SimPhase_e SimPhase;
    initial #4 forever #1 clock = ~clock;
    
    initial begin
        //| system wide reset
        //| =============================================================
        $xzcheckoff;
        $vcdpluson; //make that dve database
        $vcdplusmemon;
        #1 SimPhase = RESET;
           reset = 1;
        #1 $xzcheckon;
        #8 reset = 0;
        

        $readmemh("source/Verif/program_memory_blank.hex", dut.st1.program_memory.memory);
        $readmemh("source/Verif/register_memory_blank.hex", dut.st1.register_file.zregisters);      
        #1 SimPhase = IDLE;
           reset = 1;
        #1 reset = 0;
        
        #19
        
        $readmemh("source/Verif/haz0.hex", dut.st1.program_memory.memory);
        $readmemh("source/Verif/register_memory_blank.hex", dut.st1.register_file.zregisters);      
        SimPhase = HAZ0;
           reset = 1;
        #1 reset = 0;
        
        #19
        
        $readmemh("source/Verif/haz1.hex", dut.st1.program_memory.memory);
        $readmemh("source/Verif/register_memory_blank.hex", dut.st1.register_file.zregisters);      
        SimPhase = HAZ1;
           reset = 1;
        #1 reset = 0;
        
        #19
        
        $readmemh("source/Verif/haz2.hex", dut.st1.program_memory.memory);
        $readmemh("source/Verif/register_memory_blank.hex", dut.st1.register_file.zregisters);      
        SimPhase = HAZ2;
           reset = 1;
        #1 reset = 0;
        
        #19
        
        $readmemh("source/Verif/haz3.hex", dut.st1.program_memory.memory);
        $readmemh("source/Verif/register_memory_blank.hex", dut.st1.register_file.zregisters);      
        SimPhase = HAZ3;
           reset = 1;
        #1 reset = 0;
        
        #19
        
        $readmemh("source/Verif/haz4.hex", dut.st1.program_memory.memory);
        $readmemh("source/Verif/register_memory_blank.hex", dut.st1.register_file.zregisters);      
        SimPhase = HAZ4;
           reset = 1;
        #1 reset = 0;
        
        #19     
        
        $readmemh("source/Verif/haz5.hex", dut.st1.program_memory.memory);
        $readmemh("source/Verif/register_memory_blank.hex", dut.st1.register_file.zregisters);      
        SimPhase = HAZ5;
           reset = 1;
        #1 reset = 0;
        
        #19     
        
        $readmemh("source/Verif/haz6.hex", dut.st1.program_memory.memory);
        $readmemh("source/Verif/register_memory_blank.hex", dut.st1.register_file.zregisters);      
        SimPhase = HAZ6;
           reset = 1;
        #1 reset = 0;
        
        #19     
        
        $readmemh("source/Verif/haz7.hex", dut.st1.program_memory.memory);
        $readmemh("source/Verif/register_memory_blank.hex", dut.st1.register_file.zregisters);      
        SimPhase = HAZ7;
           reset = 1;
        #1 reset = 0;
        
        #19     
        
        $readmemh("source/Verif/haz8.hex", dut.st1.program_memory.memory);
        $readmemh("source/Verif/register_memory_blank.hex", dut.st1.register_file.zregisters);      
        SimPhase = HAZ8;
           reset = 1;
        #1 reset = 0;
        
        #19     
        
        $readmemh("source/Verif/haz9.hex", dut.st1.program_memory.memory);
        $readmemh("source/Verif/register_memory_blank.hex", dut.st1.register_file.zregisters);      
        SimPhase = HAZ9;
           reset = 1;
        #1 reset = 0;
        
        #19     
        
        $readmemh("source/Verif/haz10.hex", dut.st1.program_memory.memory);
        $readmemh("source/Verif/register_memory_blank.hex", dut.st1.register_file.zregisters);      
        SimPhase = HAZ10;
           reset = 1;
        #1 reset = 0;
        
        #19     

        $readmemh("source/Verif/stall.hex", dut.st1.program_memory.memory);
        $readmemh("source/Verif/register_memory_blank.hex", dut.st1.register_file.zregisters);      
        SimPhase = STALL;
           reset = 1;
        #1 reset = 0;
        
        #19     
                        
        //| official test program
        SimPhase = FULLTEST;
        $readmemh("source/Verif/program_memory.hex", dut.st1.program_memory.memory);
        $readmemh("source/Verif/register_memory.hex", dut.st1.register_file.zregisters);
        $readmemh("source/Verif/main_memory.hex", dut.st3.main_memory.shadow_memory);
        #1 reset = 0;
        #1 reset = 1;
        #1 reset = 0;       
        
        #60
        memcheck = {dut.st3.main_memory.memory[0], dut.st3.main_memory.memory[1]};
        memcheck2 = {dut.st3.main_memory.memory[2], dut.st3.main_memory.memory[3]};
        
        if (memcheck != 32'h2bcd) $display("check FAILED! memory[0] value = %h expected 2BCD", memcheck);
        else  $display("Memory check Passed! memory[0] value = %h expected 2bcd", memcheck);
            
        if (memcheck2 != 32'h579A) $display("check FAILED! memory[2] value = %h expected 579A", memcheck2);
        else $display("Memory check Passed! memory[2] value = %h expected 579a", memcheck2);
        $finish;
    end
	
	integer cycle = 0;
    always @ (negedge clock) begin
        if(SimPhase == FULLTEST) begin
        	cycle++;
            //PC, ADDERS, MEMORY, REGISTER FILE, ALU, and pipeline buffers (inputs and output)
            $display("\n\n");
            $display("Current CPU State ====Cycle: %2d====================================", cycle);
            $display("Pipe Stage One ----------------------------------------------------");
            $display("stall        :%h"     , dut.st1.stall);
            $display("halt_sys     :%h"     , dut.st1.halt_sys);

            $display("out_memc     :%h"     , dut.st1.out_memc.mem2r);
            $display("out_reg_wr   :%h"     , dut.st1.out_reg_wr);
            $display("out_alu      :%h"     , integer'(dut.st1.out_alu));
            $display("out_haz1     :%h"     , dut.st1.out_haz1);
            $display("out_haz2     :%h"     , dut.st1.out_haz2);
            $display("out_haz8     :%h"     , dut.st1.out_haz8);
            $display("out_R0_en    :%h"     , dut.st1.out_R0_en);
            $display("out_alu_ctrl :%h"     , dut.st1.out_alu_ctrl);
            $display("out_instr    :%h"     , dut.st1.out_instr);
            $display("out_R1_data  :%h"     , dut.st1.out_R1_data);
            $display("memc         :%h"     , dut.st1.memc.mem2r);

            $display("instruction - %h"     , dut.st1.instruction );
            $display("PC_address - %h"      , dut.st1.PC_address );
            
            $display("opcode - %h"          , dut.st1.opcode );
            $display("func_code - %h"       , dut.st1.func_code );
            
            $display("offset_sel - %h"      , dut.st1.offset_sel );
            $display("offset_se - %h"       , dut.st1.offset_se );
            $display("offset_shifted - %h"  , dut.st1.offset_shifted );
            
            $display("cmp_a - %h"           , dut.st1.cmp_a );
            $display("cmp_b - %h"           , dut.st1.cmp_b );
            $display("cmp_result - %h"      , dut.st1.cmp_result );
            
            $display("PC_no_jump - %h"      , dut.st1.PC_no_jump );
            $display("PC_jump - %h"         , dut.st1.PC_jump );
            $display("PC_next - %h"         , dut.st1.PC_next );
            
            $display("R1_data - %h"         , dut.st1.R1_data );
            $display("R1_data_muxed - %h"   , dut.st1.R1_data_muxed );
            $display("r2_data - %h"         , dut.st1.r2_data );
            
            $display("haz - %h"             , dut.st1.haz );
            $display("R0_en - %h"           , dut.st1.R0_en );
            $display("");
            $display("Pipe Stage Two ----------------------------------------------------");
            $display("in_memc - %h "        , dut.st2.out_memc.mem2r);
            $display("in_alu a - %h "       , dut.st2.in_alu.a);
            $display("in_alu b- %h "        , dut.st2.in_alu.b);
            $display("alu_control - %h "    , dut.st2.alu_control);
            $display("in_R1_data - %h "     , dut.st2.in_R1_data);
            $display("in_R0_en - %h "       , dut.st2.in_R0_en);
            $display("in_instr - %h "       , dut.st2.in_instr);
            $display("haz1 - %h "           , dut.st2.haz1);
            $display("haz2 - %h "           , dut.st2.haz2);
            $display("haz8 - %h "           , dut.st2.haz8);
            $display("s3_data - %h "        , dut.st2.s3_data);
            $display("in_reg_wr - %h "      , dut.st2.in_reg_wr);
            
            $display("alucontrol - %s"      , dut.st2.alucontrol);
            $display("alu overflow - %h"    , dut.st2.out_alu_stat.sign);
            $display("alu sign - %h"        , dut.st2.out_alu_stat.overflow);
			$display("alu zero- %h"         , dut.st2.out_alu_stat.zero);
			
            $display("out_reg_wr - %h "     , dut.st2.out_reg_wr);
            $display("out_memc - %h "       , dut.st2.out_memc.mem2r);
            $display("out_alu - %h "        , dut.st2.out_alu);
            $display("out_alu_result - %h " , dut.st2.out_alu_result);
            $display("out_R1_data - %h "    , dut.st2.out_R1_data);
            $display("out_R0_en - %h "      , dut.st2.out_R0_en);
            $display("out_instr - %h "      , dut.st2.out_instr);
            $display("alu overflow - %b"    , dut.st2.out_alu_stat.sign);
            $display("alu sign - %b"        , dut.st2.out_alu_stat.overflow);
			$display("alu zero- %b"         , dut.st2.out_alu_stat.zero);

            $display("");
            $display("Pipe Stage Three --------------------------------------------------");
            $display("instruction - %h"     , dut.st3.instruction);
            $display("alu - %h"             , dut.st3.alu);
            $display("memc - %h"            , dut.st3.memc.mem2r);
            $display("r1_data - %h"         , dut.st3.r1_data);
            $display("r0_en - %h"           , dut.st3.r0_en);
            $display("halt_sys - %h"        , dut.st3.halt_sys);
            
            $display("");
            $display("data - %h"            , dut.st3.data);
            $display("r1_data_out - %h"     , dut.st3.r1_data_out);
            $display("out_memc - %h"        , dut.st3.out_memc.mem2r);
            $display("out_r0_en - %h"       , dut.st3.out_r0_en);
            $display("instruction_out - %h" , dut.st3.instruction_out);
            $display("===================================================================");
        end
    end
endmodule
