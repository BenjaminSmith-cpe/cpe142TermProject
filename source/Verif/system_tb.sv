// `define VERBOSE //Prints information about test success, otherwise only
                   //failing checks will print information

// `define BOUNDED_INPUTS   //limits magnitutde of ALU inputs

typedef enum{RESET, IDLE, HAZARD, FULLTEST, HAZ0, HAZ1, HAZ2, HAZ3, HAZ4, HAZ5, HAZ6, HAZ7, HAZ8, HAZ9, HAZ10, STALL} SimPhase_e;

module system_tb();
    import alu_pkg::*;
    import types_pkg::*;
    import tb_utils_pkg::*;
    import tb_class_def::*;
    
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
endmodule

    always @ (negedge clk) begin
        if(SimPhase == FULLTEST) begin
            //PC, ADDERS, MEMORY, REGISTER FILE, ALU, and pipeline buffers (inputs and output)
            $display("\n\n\n")
            $display("\nCurrent CPU State =================================================");
            $display("\nPipe Stage One ----------------------------------------------------");
            $display("\nPC: %4d --   :%b"     , dut.st1.PC);
            $display("\nstall        :%b"     , dut.st1.stall);
            $display("\nhalt_sys     :%b"     , dut.st1.halt_sys);

            $display("\nout_memc     :%b"     , dut.st1.out_memc);
            $display("\nout_reg_wr   :%b"     , dut.st1.out_reg_wr);
            $display("\nout_alu      :%b"     , dut.st1.out_alu);
            $display("\nout_haz1     :%b"     , dut.st1.out_haz1);
            $display("\nout_haz2     :%b"     , dut.st1.out_haz2);
            $display("\nout_haz8     :%b"     , dut.st1.out_haz8);
            $display("\nout_R0_en    :%b"     , dut.st1.out_R0_en);
            $display("\nout_alu_ctrl :%b"     , dut.st1.out_alu_ctrl);
            $display("\nout_instr    :%b"     , dut.st1.out_instr);
            $display("\nout_R1_data  :%b"     , dut.st1.out_R1_data);
            $display("\nmemc         :%b"     , dut.st1.memc);

            $display("\ninstruction - %b"     , instruction );
            $display("\nPC_address - %b"      , PC_address );
            
            $display("\nopcode - %b"          , opcode );
            $display("\nfunc_code - %b"       , func_code );
            
            $display("\noffset_sel - %b"      , offset_sel );
            $display("\noffset_se - %b"       , offset_se );
            $display("\noffset_shifted - %b"  , offset_shifted );
            
            $display("\ncmp_a - %b"           , cmp_a );
            $display("\ncmp_b - %b"           , cmp_b );
            $display("\ncmp_result - %b"      , cmp_result );
            
            $display("\nPC_no_jump - %b"      , PC_no_jump );
            $display("\nPC_jump - %b"         , PC_jump );
            $display("\nPC_next - %b"         , PC_next );
            
            $display("\nR1_data - %b"         , R1_data );
            $display("\nR1_data_muxed - %b"   , R1_data_muxed );
            $display("\nr2_data - %b"         , r2_data );
            
            $display("\nhaz - %b"             , haz );
            $display("\nR0_en - %b"           , R0_en );

            $display("\nPipe Stage Two ----------------------------------------------------");
            $display("\nin_memc - %b "        , dut.st3.in_memc);
            $display("\nin_alu - %b "         , dut.st3.in_alu);
            $display("\nalu_control - %b "    , dut.st3.alu_control);
            $display("\nin_R1_data - %b "     , dut.st3.in_R1_data);
            $display("\nin_R0_en - %b "       , dut.st3.in_R0_en);
            $display("\nin_instr - %b "       , dut.st3.in_instr);
            $display("\nhaz1 - %b "           , dut.st3.haz1);
            $display("\nhaz2 - %b "           , dut.st3.haz2);
            $display("\nhaz8 - %b "           , dut.st3.haz8);
            $display("\ns3_data - %b "        , dut.st3.s3_data);
            $display("\nin_reg_wr - %b "      , dut.st3.in_reg_wr);
            
            $display("\n");
            $display("\nout_reg_wr - %b "     , dut.st3.out_reg_wr);
            $display("\nout_memc - %b "       , dut.st3.out_memc);
            $display("\nout_alu - %b "        , dut.st3.out_alu);
            $display("\nout_alu_result - %b " , dut.st3.out_alu_result);
            $display("\nout_R1_data - %b "    , dut.st3.out_R1_data);
            $display("\nout_R0_en - %b "      , dut.st3.out_R0_en);
            $display("\nout_instr - %b "      , dut.st3.out_instr);

            $display("\nPipe Stage Three ----------------------------------------------------");
            $display("\ninstruction - %b"     , instruction);
            $display("\nalu - %b"             , alu);
            $display("\nmemc - %b"            , memc);
            $display("\nr1_data - %b"         , r1_data);
            $display("\nr0_en - %b"           , r0_en);
            $display("\nhalt_sys - %b"        , halt_sys);
            
            $display("\n");
            $display("\ndata - %b"            , data);
            $display("\nr1_data_out - %b"     , r1_data_out);
            $display("\nout_memc - %b"        , out_memc);
            $display("\nout_r0_en - %b"       , out_r0_en);
            $display("\ninstruction_out - %b" , instruction_out);
            $display("\n===================================================================");
        end
    end
endmodule