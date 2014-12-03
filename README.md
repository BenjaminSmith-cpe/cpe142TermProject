CPE 142 Term Project
=================
This is a simple pipelined processor that implements a subset of the MIPS instruction set. For a more detailed, perhaps longwinded, description see the manual.pdf in the paper directory. This document also lists the supported instruction set. 

##The basics:
This is a three stage pipelined CPU. It is modeled in *pretty much* System Verilog. This source repository models and validates this high level design drawing. Register forwarding elimanates performance degridation due to data hazards except certain instances of the load word instruction. Load word requires stalling the pipeline for a single cycle and represents the greatest performance impact of pipeline hazards.
![Picture!](https://s3.amazonaws.com/f.cl.ly/items/183y0E1S2B1a1u0I2u2x/142.jpg)

## MIT Open!
For some reason, if you would like to copy or redistribute the code in the repo go right ahead! All source code is released to the community under MIT open license. 
