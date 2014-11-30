// `define VERBOSE //Prints information about test success, otherwise only
                   //failing checks will print information

// `define BOUNDED_INPUTS   //limits magnitutde of ALU inputs

typedef enum{RESET, IDLE, HAZARD, FULLTEST, HAZ0, HAZ1, HAZ2, HAZ3, HAZ4, HAZ5, HAZ6, HAZ7, HAZ8, HAZ9, HAZ10, STALL} SimPhase_e;

module system_tb();
    import alu_pkg::*;
    import tb_utils_pkg::*;
    import tb_class_def::*;
    
    integer             testiteration = 0;
    integer             failure_count = 0;
	reg		[15:0]register_temp[4:0];
    logic clock = 0;
    logic reset = 0;

    top dut(
        .clk(clock),
        .rst(reset)
    );
	SimPhase_e SimPhase;
    initial #4 forever #1 clock = ~clock;
	
    initial begin
        //| system wide reset
        //| =============================================================
        //$xzcheckoff;
        $vcdpluson; //make that dve database
        $vcdplusmemon;
		#1 SimPhase = RESET;
		   reset = 1;
		#9 reset = 0;
		

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
 		#1 reset = 0;
        #1 reset = 1;
        #1 reset = 0;       
        
        //$xzcheckon;
    end

    always @ (negedge clock) begin
        if (dut.st1.PC_next == 52) $finish;
        // $display(".--------------------------------------------------.");
        // $display("| PIPE STATUS| PC: %d", dut.PC_next);
        // $display("|--------------------------------------------------|");
        // $display("| Stage      : ONE |TWO |THREE |");
        // $display("| Instruction: %5s |%5s |%5s |", dut.opcode, dut.s2_opcode, dut.s3_opcode);
        // $display("| %s", dut.opcode);
        // $display("| %s", dut.opcode);        
        // $display("'--------------------------------------------------'");
    end
endmodule
