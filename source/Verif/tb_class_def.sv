//===============================================================
// This package contains class definitions for out test benches.
// 
//===============================================================

package tb_class_def;

    //===========================================================
    // ALU test bench class.
    //
    //===========================================================
    class alu_checker;
        import alu_pkg::*; 

        logic signed [33:0]         result;
        logic                       ov;

        rand alu_pkg::control_e control;
        rand          integer   a;
        rand          integer   b;
        status_t                stat;
        in_t                    DUT_inputs;

        assign DUT_inputs.a = a;
        assign DUT_inputs.b = b;
        
        function new (
            alu alu_DUT(
                .stat(stat)
                .in()
                .control()
                .out()
                );
            );
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
            $display("s:%b o:%b, z:%b -- Expected: s:%b o:%b, z:%b", ports.stat.sign, ports.stat.overflow, ports.stat.zero, result[33], ov, !(|result));
            $display("%11d - %b", ports.in.a,ports.in.a);
            $display("%11d - %b", ports.in.b,ports.in.b);
            $display("================================");
            $display("%11d -   %b <-- result", ports.out, ports.out);
            $display("%11d - %b <-- expected \n", result, result);
        endtask

        function check_alu_outputs;
            integer failure_count = 0;

            case(ports.control)
                add      : result = a + b;
                subtract : result = a - b;
                bitw_or  : result = a | b;
                bitw_and : result = a & b;
            endcase

            ov = (result[32]^result[31]); //If [33:31] of 32bit+32bit additions don't match there has been an overflow

            if((ports.stat.sign != result[32]) && !ports.stat.overflow) begin              
                print_alu_state("Sign Flag FAILURE");
                failure_count++;
            end
            `ifdef VERBOSE 
            else  
                print_alu_state("Sign Flag SUCCESS");
            `endif

            if((ports.stat.overflow != ov) && !ports.control[1]) begin                     
                print_alu_state("Overflow Flag FAILURE");
                failure_count++;   
            end
            `ifdef VERBOSE 
            else  
                print_alu_state("Overflow Flag SUCCESS");
            `endif

            if((ports.stat.zero && |ports.out)&& !ports.stat.overflow) begin           
                print_alu_state("Zero Flag FAILURE");
                failure_count++;   
            end
            `ifdef VERBOSE      
            else  
                print_alu_state("Zero Flag SUCCESS");
            `endif

            if((result != ports.out)&& (!ports.stat.overflow)) begin
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
    
        wire        [15:0]      DUT_output;
        logic                   clk;
        logic                   rst;
    
        rand alu_pkg::control_e control;
        rand        logic[15:0]   test_address;
        rand        logic         test_halt;
        rand        logic         test_stall;
        
         
        
        function new (
            reg_program_counter pc_DUT(
                .clk(clk)
                .rst(rst)
    
                .halt_sys(test_halt)    // Control signal from main control to halt cpu
                .stall(test_halt)       // Control signal from hazard unit to stall for one cycle
    
                .in_address(test_address)    // Next PC address
        
                .out_address(DUT_output)
                );
            );
        endfunction

    endclass

endpackage