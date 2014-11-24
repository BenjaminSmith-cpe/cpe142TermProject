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