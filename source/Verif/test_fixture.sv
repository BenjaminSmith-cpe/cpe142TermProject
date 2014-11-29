// `define VERBOSE //Prints information about test success, otherwise only
                   //failing checks will print information

// `define BOUNDED_INPUTS   //limits magnitutde of ALU inputs
module AAstimulus();
    import alu_pkg::*;
    import tb_utils_pkg::*;
    import tb_class_def::*;
    
    integer         testiteration = 0;
    integer         failure_count = 0;
	reg		[15:0]  register_temp[4:0];
    logic           clock = 0;
    logic           reset = 0;

    top dut(
        .clk(clock),
        .rst(reset)
    );

    initial #4 forever #1 clock = ~clock;

    initial begin
        //| system wide reset
        //| =============================================================
        $vcdpluson; //make that dve database
        $vcdplusmemon;
		$readmemh("source/Verif/program_memory.hex", dut.st1.program_memory.memory);
//		$readmemh("source/Verif/program_memory.hex", register_temp);
//		
//		for(int i = 0; i<5; i++)
//			for(int j = 0; j<16;j++)
//				$force(dut.st1.register_file.registers[i][j], register_temp[i][j]);
        
        #1 reset = 1;
        #2 reset = 0;
    end

    always @ (negedge clock) begin
        if (dut.st1.PC_next == 50) $finish;
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
