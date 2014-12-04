//`define VERBOSE

class reg_stim;
    rand logic   [15:0] memory_test_data;
    rand logic          halt;
    rand logic   [3:0]  address;
    
    function r();
        randomize();
    endfunction
    
    function [15:0] get_data();
        return memory_test_data;
    endfunction
    
    function get_halt();
        return halt;
    endfunction
    
    function [3:0] get_address();
        return address;
    endfunction
endclass

module register_tb();
    import alu_pkg::*;
	import types_pkg::*;
	
    integer          errors;
    integer          testiterations = 10000;
    integer          successes;
    
    logic   [15:0]   test_reg[31:0];

    logic            rst;
    logic            clk;
    logic            halt_sys;

    logic            R0_read;
    logic    [3:0]   ra1;
    logic    [3:0]   ra2;
    
    logic            write_en;
    logic            R0_en;
    logic    [3:0]   write_address;
    logic    [31:0]  write_data;
    
    logic   [15:0]  rd1;
    logic   [15:0]  rd2;

    logic   [15:0]  test_data[31:0];

    mem_register dut(.*);
    reg_stim as = new;
        
    initial forever clk = #1 !clk;
        
    initial begin
        test_reg = '{default:0};
        rst = '0;
        clk = '0;
        halt_sys = '0;
        R0_read = '0;
        ra1 = '0;
        ra2 = '0;
        write_en = '0;
        R0_en = '0;
        write_address = '{default:0};
        write_data = '0;
        test_data = '{default:0};
        $readmemh("source/Verif/register_memory_blank.hex", dut.zregisters);
        
        #2 rst = 0;
        #2 rst = 1;
        #2 rst = 0;
        
        write_en = 1;
        
        // load memory with test data
        for(int i = 0; i < 16; i++) begin
               as.r();
               test_data[i] = as.get_data();
               write_data = as.get_data();
               write_address = i;
               #4 ;
        end
        write_en = 0;
        #2 ;
        for(int i = 0; i < 16; i++) begin
               if(test_data[i] != dut.registers[i]) 
                $display("Fail Write! Address: %d -- data ex: %h rec: %h", i, test_data[i], dut.registers[i]);
        end
        
        //|check stalling mechanism
        halt_sys = 1;
        // try to overwrite data with 1s
        for(int i = 0; i < 16; i++) begin
               write_data = 16'b1;
               write_address = i;
               #4 ;
        end
        halt_sys = 0;
        
        // read back test data
        for(int i = 0; i < 16; i++) begin
            #2 
            if(test_data[i] != rd1)
               $display("Fail RD1! Address: %d -- data ex: %h rec: %h", i, test_data[i], rd1);
            else 
                $display("Read Success! RD1! Address: %d -- data ex: %h rec: %h", i, test_data[i], rd1);            

            if(test_data[i] != rd2)
               $display("Fail RD2! Address: %d -- data ex: %h rec: %h", i, test_data[i], rd1);
            else
                $display("Read Success! RD1! Address: %d -- data ex: %h rec: %h", i, test_data[i], rd1);
            
            ra1 = i + 1;
            ra2 = i + 1;
        end
        
        //check r0 write
        write_address = 10;
        write_data = 32'h555555;
        write_en = 1;
        R0_en = 1; 
        #4
        if(dut.registers[0] != 16'h55) 
            $display("Fail R0! Address: %d -- data ex: %h rec: %h", 0, 16'h55, dut.registers[0]);
        
        //check r0 read
        R0_read = 1;
        #1 ;
        if(rd1 != 16'h55) 
            $display("Fail read R0! Address: %d -- data ex: %h rec: %h", 0, 16'h55, rd1);   
        #1 R0_read = 0;
        #2 ;        
    $finish;    
    end 
endmodule
