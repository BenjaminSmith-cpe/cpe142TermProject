// ALU test bench
//
// This module generates random stiumlus for ALU both data and control lines
// through testing is ensured by simulation coverage metrics collected by VCS
//

import alu_pkg::*; 
import types_pkg::*;
//`define VERBOSE
//`define BOUNDED_INPUTS

//called by check_alu_outputs to print debug updates
task static print_alu_state(string ident, integer result, control_e control, in_t in, integer out, status_t stat, reg ov);
    // different print formats for different functions
    case(control)
        MULT: begin
            $display("%s -- time %4d - op: %s", ident, $time(), control.name);
            $display("s:%b o:%b, z:%b -- Expected: s:%b o:%b, z:%b", stat.sign, stat.overflow, stat.zero, result[31], ov, !(|result));
            $display("%11d - %b", in.a,in.a);
            $display("%11d - %b", in.b,in.b);
            $display("================================");
            $display("%11d - %b <-- result", out[31:0], out[31:0]);
            $display("%11d - %b <-- expected \n", result[31:0], result[31:0]);          
        end
        
        DIV: begin
            $display("%s -- time %4d - op: %s", ident, $time(), control.name);
            $display("s:%b o:%b, z:%b -- Expected: s:%b o:%b, z:%b", stat.sign, stat.overflow, stat.zero, result[15], ov, !(|result));
            $display("%11d - %b", in.a,in.a);
            $display("%11d - %b", in.b,in.b);
            $display("================================");
            $display("%11d - %b <-- result", out[15:0], out[15:0]);
            $display("%11d - %b <-- expected \n", result[15:0], result[15:0]);   
        end

        default :begin
            $display("%s -- time %4d - op: %s", ident, $time(), control.name);
            $display("s:%b o:%b, z:%b -- Expected: s:%b o:%b, z:%b", stat.sign, stat.overflow, stat.zero, result[15], ov, !(|result));
            $display("%11d - %b", in.a,in.a);
            $display("%11d - %b", in.b,in.b);
            $display("================================");
            $display("%11d - %b <-- result", signed'(out[15:0]), out[15:0]);
            $display("%11d - %b <-- expected \n", signed'(result[15:0]), result[15:0]);
        end   
    endcase
endtask
    
// returns number of errors for a given test cycle
function automatic check_alu_outputs(
    status_t stat,
    control_e control,
    in_t     in,
    integer  out
);
    
    reg                 ov; //expected overflow
    reg                 simsign; //expected simulation sign
    integer             result; //ALU result
    reg signed [15:0]   tarith; //dummy logic for overflow detector
    integer             failure_count = 0; //total number of failures across all checks
    
    //calculate expected result
    case(control)
        OR  : result = {16'b0,in.a | in.b};
        AND : result = {16'b0,in.a & in.b};
        MULT: result = in.a * in.b;
        ROL : result = {16'b0,({in.a, in.a} <<< in.b)};
        ROR : result = {16'b0,({in.a, in.a} >>> in.b)};
        SHL : result = {16'b0,in.a <<< in.b};
        SHR : result = {16'b0,in.a >>> in.b};
        SUB : result = {16'b0,in.a - in.b};
        ADD : result = {16'b0,in.a + in.b};
        DIV : begin
            if(in.b != 0) begin
                result[15:0] = in.a / in.b;
                result[31:16] = in.a % in.b;
            end
            else begin
                result = 32'b0;
            end
        end
     endcase

    //expected overflow flag calculation
    case(control)
        OR  : ov = 0;
        AND : ov = 0;
        MULT: ov = 0;
        ROL : ov = 0;
        ROR : ov = 0;
        SHL : ov = 0;
        SHR : ov = 0;
        SUB : {ov,tarith} = {in.a - in.b};
        ADD : {ov,tarith} = {in.a + in.b};
        DIV : ov = 0;
     endcase
    
    //Sign flag test
    simsign = (control == MULT) ? result[31] : result[15];
    if((stat.sign != simsign) && !stat.overflow) begin              
        print_alu_state("Sign Flag FAILURE", result, control, in, out, stat, ov);
        failure_count++;
    end
    `ifdef VERBOSE 
    else  
        print_alu_state("Sign Flag SUCCESS", result, control, in, out, stat, ov);
    `endif

    //Overflow flag test
    if((stat.overflow != ov) && !control[1]) begin                     
        print_alu_state("Overflow Flag FAILURE",result, control, in, out, stat, ov);
        failure_count++;   
    end
    `ifdef VERBOSE 
    else  
        print_alu_state("Overflow Flag SUCCESS", result, control, in, out, stat, ov);
    `endif

    //Zero flag test
    if((stat.zero && |out)&& !stat.overflow) begin           
        print_alu_state("Zero Flag FAILURE", result, control, in, out, stat, ov);
        failure_count++;   
    end
    `ifdef VERBOSE      
    else  
        print_alu_state("Zero Flag SUCCESS", result, control, in, out, stat, ov);
    `endif

    //ALU result flag test
    if((result != out)&& (!stat.overflow)) begin
        print_alu_state("ALU FAILURE", result, control, in, out, stat, ov);
        failure_count++;   
    end
    `ifdef VERBOSE       
    else  
        print_alu_state("ALU SUCCESS", result, control, in, out, stat, ov);
    `endif
    
    return failure_count;
endfunction

//Class to utilize system verilog's random generation capabilityseald b
class alu_stim;
    rand alu_pkg::control_e control;
    rand word_16            a;
    rand word_16            b;
    
    //simple numbers for human inspection
    `ifdef BOUNDED_INPUTS
    constraint limits{ 
        a <= 2; 
        a >= -2; 

        b <= 2; 
        b >= -2; 
        b != 0;
    }
    `endif

    //randomize wrapper incase more random features needed
    function r();
        randomize();
    endfunction
endclass

//Main module instanciates classes, modules and wiring
module alu_tb();
    import alu_pkg::*;

    //ALU  I/O lines
    alu_pkg::control_e  control;
    status_t            stat;
    in_t                alu_input;
    integer             alu_output;
    integer             errors = 0;
    integer             testiterations = 10000;
    integer             successes = 0;

    //instantiate ALU module 
    alu DUT(
        .in     (alu_input),
        .control(control),
        .stat   (stat),
        .out    (alu_output)
    );
    
    initial begin
        alu_stim as = new;
        
        //apply test stimulus and check output
        for(int i = 0; i < testiterations; i++) begin
            //randomize inputs
            as.r();
            //drive DUT
            control = as.control;
            alu_input.a = as.a;
            alu_input.b = as.b;

            //wait and check
            #1 errors += check_alu_outputs(stat, control, alu_input, alu_output);
        end

        //print completion rate
        successes = testiterations - errors;
        $display("\n");
        $display("================Test Statistics=================");
        $display("Pass - %5d Passes", successes);
        $display("Pass - %5d Failures", errors);
        $display("  Percentage Pass: %3d", (successes/testiterations)*100);
        $display("================================================");
    end
endmodule
