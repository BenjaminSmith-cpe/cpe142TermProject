// `define VERBOSE //Prints information about test success, otherwise only
                   //failing checks will print information

// `define BOUNDED_INPUTS   //limits magnitutde of ALU inputs

// Top level stimulus module
module stimulus();
    import alu_pkg::*;
    import tb_utils_pkg::*;
    import tb_class_def::*;

    integer             testiteration = 0;
    integer             failure_count = 0;

    status_t                stat;
    in_t                    operands;
    alu_pkg::control_e      control;
    logic    signed [15:0]  result;

    alu alu_dut(.*);
    alu_checker alu_stim;

    initial begin
        //| Perform regression testing of individual components
        //| =============================================================

        $vcdpluson; //make that dve database

        while (testiteration < 1000) begin
            alu_stim.randomize_alu_inputs();
            #1  failure_count += alu_stim.check_alu_outputs();
            testiteration++;
        end

        print_sim_stats(failure_count, testiteration);
    end
