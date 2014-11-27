// `define VERBOSE //Prints information about test success, otherwise only
                   //failing checks will print information

// `define BOUNDED_INPUTS   //limits magnitutde of ALU inputs

// Top level stimulus module
import alu_pkg::*;
import tb_utils_pkg::*;
import tb_class_def::*;

module AAstimulus();
    integer             testiteration = 0;
    integer             failure_count = 0;

    logic clock = 0;
    logic reset = 0;

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

        #1 reset = 1;
        #1 reset = 0;
        
        $readmemh("Verif/program_memory.hex", dut.program_memory.memory);
        $readmemh("Verif/register_memory.hex", dut.register_file.registers); //load test memory on reset
    end

    always @ (negedge clock) begin
        if (dut.PC_next == 50) $stop;
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