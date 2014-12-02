import alu_pkg::*; 
import types_pkg::*;
//`define VERBOSE
	
function static check_mem_outputs(

);
    
endfunction

class reg_stim;
    
    rand logic   [7:0]  memory_test_data;
    
    constraint limits{ 
        a <= 2; 
        a >= -2; 

        b <= 2; 
        b >= -2; 
        b != 0;
    }
    
    function r();
    	randomize();
        return memory_test_data;
    endfunction
endclass

module register_tb();
    import alu_pkg::*;

	integer			errors;
    integer			testiterations = 10000;
    integer 		successes;
    
    wire   [15:0]   test_reg[31:0];

    wire            rst;
    wire            clk;
    wire            halt_sys;

    wire            R0_read;
    wire    [3:0]   ra1;
    wire    [3:0]   ra2;
    
    wire            write_en;
    wire            R0_en;
    wire    [3:0]   write_address;
    wire    [31:0]  write_data;
    
    logic   [15:0]  rd1;
    logic   [15:0]  rd2;

    logic   [15:0]  test_data[31:0];

    mem_register dut(.*);

    initial forever clk = #1 ~clk;

	sinitial begin
        reg_stim as = new;
        
        test_reg = 0;
        rst = 0;
        clk = 0;
        halt_sys = 0;
        R0_read = 0;
        ra1 = 0;
        ra2 = 0;
        write_en = 0;
        R0_en = 0;
        write_address = 0;
        write_data = 0;
        rd1 = 0;
        rd2 = 0;
        test_data = 0;
        $readmemh("source/Verif/register_memory_blank.hex", dut.st1.zregisters);
        
        #2 rst = 0;
        #2 rst = 1;
        #2 rst = 0;
        
        write_en = 1;
        // load memory with test data
	    for(int i = 0; i < 32; i++) begin
        	#2 test_data[i] = as.r();
               write_data = test_data[i];
        end
        write_en = 0;

        // read back test data
        for(int i = 0; i < 32; i++) begin
            #2 
            if(test_data[i] != rd1) begin
               rd1 = test_data[i];
            end


        end

    
    successes = testiterations-errors;
    $display("\n");
    $display("================Test Statistics=================");
    $display("Pass - %5d Passes", successes);
    $display("Pass - %5d Failures", errors);
    $display("  Percentage Pass: %3d", (successes/testiterations)*100);
    $display("================================================");
	end
endmodule
