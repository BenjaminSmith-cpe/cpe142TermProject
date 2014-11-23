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

    alu_interface io();
    alu alu_dut(io);

    initial begin
        //| Perform regression testing of individual components
        //| =============================================================
        alu_checker alu_stim = new(io.tb);
        $vcdpluson; //make that dve database
        
        while (testiteration < 1000) begin
            alu_stim.randomize_alu_inputs();
            #1  failure_count += alu_stim.check_alu_outputs();
            testiteration++;
        end

        print_sim_stats(failure_count, testiteration);
    end
endmodule