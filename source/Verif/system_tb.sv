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
	
	reg		[15:0]register_temp[4:0];
    
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
