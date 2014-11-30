import alu_pkg::*; 

`define VERBOSE

task print_sim_stats(integer failures, integer testiterations);
    integer successes = 0;
    successes = testiterations-failures;
    $display("\n");
    $display("================Test Statistics=================");
    $display("Pass - %5d Passes", successes);
    $display("Pass - %5d Failures", failures);
    $display("  Percentage Pass: %3d", (successes/testiterations)*100);
    $display("================================================");
endtask

function check_alu_outputs(
    status_t stat,
    control_e control,
    in_t     in,
    integer  out,
    );
    integer failure_count = 0;
    
    case(ports.control)
        add      : result = a + b;
        subtract : result = a - b;
        bitw_or  : result = a | b;
        bitw_and : result = a & b;
    endcase

    ov = (result[16]^result[17]); //If [33:31] of 32bit+32bit additions don't match there has been an overflow

    if((stat.sign != result[32]) && !stat.overflow) begin              
        print_alu_state("Sign Flag FAILURE");
        failure_count++;
    end
    `ifdef VERBOSE 
    else  
        print_alu_state("Sign Flag SUCCESS");
    `endif

    if((stat.overflow != ov) && !control[1]) begin                     
        print_alu_state("Overflow Flag FAILURE");
        failure_count++;   
    end
    `ifdef VERBOSE 
    else  
        print_alu_state("Overflow Flag SUCCESS");
    `endif

    if((.tat.zero && |out)&& !stat.overflow) begin           
        print_alu_state("Zero Flag FAILURE");
        failure_count++;   
    end
    `ifdef VERBOSE      
    else  
        print_alu_state("Zero Flag SUCCESS");
    `endif

    if((result != out)&& (!stat.overflow)) begin
        print_alu_state("ALU FAILURE");
        failure_count++;   
    end
    `ifdef VERBOSE       
    else  
        print_alu_state("ALU SUCCESS");
    `endif
    return failure_count;
endfunction

task print_alu_state(string ident);
    $display("%s -- time %4d - op: %s", ident, $time(), control.name);
    $display("s:%b o:%b, z:%b -- Expected: s:%b o:%b, z:%b", stat.sign, stat.overflow, stat.zero, result[33], ov, !(|result));
    $display("%11d - %b", in.a,in.a);
    $display("%11d - %b", in.b,in.b);
    $display("================================");
    $display("%11d -   %b <-- result", out, out);
    $display("%11d - %b <-- expected \n", result, result);
endtask

module alu_tb();
    import alu_pkg::*;

    logic signed [31:0]         result;
    logic                       ov;

    rand alu_pkg::control_e control;
    rand          integer   a;
    rand          integer   b;
    status_t                stat;
    in_t                    alu_input;
    integer                 alu_output;

    `ifdef BOUNDED_INPUTS
    constraint limits{ 
        a <= 2; 
        a >= -2; 

        b <= 2; 
        b >= -2; 
    }
    `endif

    alu main_alu(
        .in     (alu_input;),
        .control(alu_control),
        .stat   (stat),
        .out    (alu_output)
    );

    for(int i = 0; i < 100; i++) begin
        randomize();
        #1
        check_alu_outputs(stat, alu_control, alu_input, alu_output);
    end
endmodule