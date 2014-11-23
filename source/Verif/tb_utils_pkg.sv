package tb_utils_pkg;

    task automatic print_sim_stats(integer failures, integer testiterations);
        integer successes = 0;
        successes = testiterations-failures;
        $display("\n");
        $display("================Test Statistics=================");
        $display("Pass - %5d Passes", successes);
        $display("Pass - %5d Failures", failures);
        $display("  Percentage Pass: %3d", (successes/testiterations)*100);
        $display("================================================");
    endtask
endpackage