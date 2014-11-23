//===============================================================
// This package contains class definitions for out test benches.
// 
//===============================================================

package tb_class_def;
    import alu_pkg::*; 

    //===========================================================
    // ALU test bench class.
    //
    //===========================================================
    class alu_checker;
        logic signed [33:0]         result;
        logic                       ov;

        rand alu_pkg::control_e control;
        rand          integer   a;
        rand          integer   b;
        status_t                stat;
        in_t                    DUT_inputs;
        logic    signed [15:0]  out;

        function new(statin, operandsin, controlin, resultin);
            DUT_inputs.a = this.a;
            DUT_inputs.b = this.b;

            operandsin = this.DUT_inputs;
            statin = this.stat;
            controlin = this.control;
            resultin = this.out;
        endfunction

        `ifdef BOUNDED_INPUTS
        constraint limits{ 
            a <= 2; 
            a >= -2; 

            b <= 2; 
            b >= -2; 
        }
        `endif

        task randomize_alu_inputs();
            randomize();
        endtask

        task print_alu_state(string ident);
            $display("%s -- time %4d - op: %s", ident, $time(), control.name);
            $display("s:%b o:%b, z:%b -- Expected: s:%b o:%b, z:%b", stat.sign, stat.overflow, stat.zero, result[33], ov, !(|result));
            $display("%11d - %b", a,a);
            $display("%11d - %b", b,b);
            $display("================================");
            $display("%11d -   %b <-- result", out, out);
            $display("%11d - %b <-- expected \n", result, result);
        endtask

        function check_alu_outputs;
            integer failure_count = 0;

            case(control)
                add      : result = a + b;
                subtract : result = a - b;
                bitw_or  : result = a | b;
                bitw_and : result = a & b;
            endcase

            ov = (result[32]^result[31]); //If [33:31] of 32bit+32bit additions don't match there has been an overflow

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

            if((stat.zero && |out)&& !stat.overflow) begin           
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
    endclass

    //===========================================================
    // PC register test bench class.
    //
    //===========================================================
    class reg_program_counter_checker;
    
        logic        [15:0]     DUT_output;
        logic                   clk;
        logic                   rst;
    
        rand        logic[15:0]   test_address;
        rand        logic         test_halt;
        rand        logic         test_stall;
        
         
        
        // function new (
        //     reg_program_counter pc_DUT(
        //         .clk(clk)
        //         .rst(rst)
    
        //         .halt_sys(test_halt)    // Control signal from main control to halt cpu
        //         .stall(test_halt)       // Control signal from hazard unit to stall for one cycle
    
        //         .in_address(test_address)    // Next PC address
        
        //         .out_address(DUT_output)
        //         );
        //     );
        // endfunction
    endclass
endpackage