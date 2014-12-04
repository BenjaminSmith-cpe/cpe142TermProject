// Register file module
//
// This module will store values of the registers for the cpu.
// It can write new data to the registers as well as read them.
// The R0 register is treated slightly different for instructions
// like MUL/DIV or branching instructions based on our ISA.
//

module mem_register(
    input wire          rst,
    input wire          clk,
    input wire          halt_sys,

    input wire          R0_read,
    input wire  [3:0]   ra1,        // address of register 1
    input wire  [3:0]   ra2,        // address of register 2

    input wire          write_en,
    input wire          R0_en,
    input wire  [3:0]   write_address,
    input wire  [31:0]  write_data,

    output logic[15:0]  rd1,
    output logic[15:0]  rd2
);

    reg     [15:0]      write_data_high;
    reg     [15:0]      write_data_low;
    reg                 clockg;
    
    logic   [15:0]      registers[31:0];    // Memory block. 4 bit address with 16 bit data
    logic   [15:0]      zregisters[31:0] ='{default:0};
    
    assign  {write_data_high, write_data_low} = write_data;     // Split the input data into two words
    
    //generates clock that will only allow writes when they are supposed to.
    always_comb begin: clock_gating
     clockg = (halt_sys == 1'b1|| write_en == 1'b0)?1'b0:clk; //flop clock gated
    end
    
    //Combinatorial read logic  
    always_comb begin: memory_read_logic
        rd1 = registers[ra1];   // Always read the data from the address
        rd2 = (R0_read) ? registers[0] : registers[ra2];        // if R0_read is high then R0 contents are output at r2
    end                                     
    
    //sequential write logic.   
    always_ff@(posedge clockg, posedge rst) begin: mem_reg_flop
        if (rst == 1'b1) begin      
            registers <= zregisters;// If rst is asserted, we want to clear the flops
        end 
        else begin// Write data to reg, and write top 16 bits to R0 if R0_en is high  
            if (R0_en) registers[0] <= write_data_high;
            registers[write_address] <= write_data_low;     // Flop the input
        end
    end
endmodule
