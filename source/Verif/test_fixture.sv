// `define VERBOSE //Prints information about test success, otherwise only
                   //failing checks will print information

// `define BOUNDED_INPUTS   //limits magnitutde of ALU inputs

// Top level stimulus module
import alu_pkg::*;
import tb_utils_pkg::*;
import tb_class_def::*;

class alu_checker;
        logic signed [15:0]         result;
        logic                       ov;

        rand alu_pkg::control_e control;
        rand          integer   a;
        rand          integer   b;
        status_t                stat;

        `ifdef BOUNDED_INPUTS
        constraint limits{ 
            a <= 2; 
            a >= -2; 

            b <= 2; 
            b >= -2; 
        }
        `endif

        function automatic get_random_alu_input();
            // randomize();
            in_t out;
            out.a = this.a;
            out.b = this.b;
            
            return out;
        endfunction

        // task print_alu_state(string ident);
        //     $display("%s -- time %4d - op: %s", ident, $time(), control.name);
        //     $display("s:%b o:%b, z:%b -- Expected: s:%b o:%b, z:%b", stat.sign, stat.overflow, stat.zero, result[16], ov, !(|result));
        //     $display("%11d - %b", in.a,in.a);
        //     $display("%11d - %b", in.b,in.b);
        //     $display("================================");
        //     $display("%11d -   %b <-- result", out, out);
        //     $display("%11d - %b <-- expected \n", result, result);
        // endtask

        // function check_alu_outputs;
        //     integer failure_count = 0;

        //     case(control)
        //         ADD: result = a + b;
        //         SUB: result = a - b;
        //         OR : result = a | b;
        //         AND: result = a & b;
        //     endcase

        //     ov = (result[17]^result[15]); //If [33:31] of 32bit+32bit additions don't match there has been an overflow

            // if((stat.sign != result[17]) && !stat.overflow) begin              
            //     print_alu_state("Sign Flag FAILURE");
            //     failure_count++;
            // end
            // `ifdef VERBOSE 
            // else  
            //     print_alu_state("Sign Flag SUCCESS");
            // `endif

            // if((stat.overflow != ov) && !control[1]) begin                     
            //     print_alu_state("Overflow Flag FAILURE");
            //     failure_count++;   
            // end
            // `ifdef VERBOSE 
            // else  
            //     print_alu_state("Overflow Flag SUCCESS");
            // `endif

            // if((stat.zero && |out)&& !stat.overflow) begin           
            //     print_alu_state("Zero Flag FAILURE");
            //     failure_count++;   
            // end
            // `ifdef VERBOSE      
            // else  
            //     print_alu_state("Zero Flag SUCCESS");
            // `endif

            // // if((result != out)&& (!stat.overflow)) begin
            // //     print_alu_state("ALU FAILURE");
            // //     failure_count++;   
            // // end
            // `ifdef VERBOSE       
            // else  
            //     print_alu_state("ALU SUCCESS");
            // `endif
            // return failure_count;
        // endfunction
    endclass

module stimulus();
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
        #1 reset = 1;
        #1 reset = 0;
        $readmemh("verif/register_memory.hex", dut.register_file.registers);
        $readmemh("verif/program_memory.hex", dut.program_memory.memory);

        //| Perform regression testing of individual components
        //| =============================================================
        // alu_checker s;

        // $vcdpluson; //make that dve database
        
        // while (testiteration < 1000) begin
        //     alu_stim.randomize_alu_inputs();
        //     #1  failure_count += alu_stim.check_alu_outputs();
        //     testiteration++;
        // end

        print_sim_stats(failure_count, testiteration);
    end
endmodule