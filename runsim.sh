#! /bin/bash
# $runsim [top level design file][top module name]
# 
# Three step VCS flow as described in Synopsys user guide. Uses implicit configuration
# which allows unknown modules to be automatically resolved. See individual command
# comments for details. An important caveat of implicit configuration is packages and
# interfaces are not resolved by this algorithm.
#
# coverage analysis is enabled. Results can be viewed by running: dve -cov -dir simv.vdb/
# Command to run DVE: dve -vpd vcdplus.vpd
# 
#

export VCS_LIC_EXPIRE_WARNING=1 #removes license warning
mkdir logs lib #VCS will not create it's output directories if they don't exist

echo
echo 
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo             RUNNING Vlogan
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo
# Explanation of Command Line Flags:
# 
# -sverilog 		: Because everyone knows it's the bext verilog
# -nc      			: suppress Synopsys copyright message at beginning of log
# +lint=all 		: display all lint checks for code quality (noVCDE suppress messages about compiler directives)
# +warn=all 		: always pay attention to warnings, they're there for a reason.
# -l <path> 		: vlogan will direct it's output messages to this file
# +libext+.sv+.v 	: part of VCS implicit configuration. The top level file is the only
#					  module reqired to be imported (packages and interfaces wont be resolved)
#					  VCS will then search the -y directory for missing modules in file names
#					  that have the module name with one of the libext extentions
# -y <>				: library directories VCS will search when looking for unresolved modules
# $PWD/source/$1    : top level file for compilation
vlogan -f vlogan_args.list

if [ $? -ne 0 ]; then 
    echo "Vlogan analysis failed"
    exit 1;
fi

echo
echo
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo             RUNNING VCS
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo
#
# Explanation of Command Line Flags:
#
# -cm fsm+line+tgl+branch : Enables coverage metrics which tells what parts of the code have been exercised
#                         : FSM - Which states of finite state machines have been used
#                         : line - which lines of code have been used by test run
#                         : tgl - records which signals have been toggled in test rub
#                         : branch - which parts of if branches have been taken (superfluous with line?)
# -PP                     : enables post process debug utilities
# -notice                 : REALLY verbose messages
vcs -file VCS_args.list

if [ $? -ne 0 ]; then 
    echo "VCS elaboration failed"
    exit 1;
fi

echo
echo
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo             RUNNING Simulation
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo
#
# Explanation of Command Line Flags:
#
# cg_coverage_control=1 coverage data collection for all the coverage groups (not yet in code)
simv -l $PWD/logs/simv.log -cm fsm+line+tgl+branch -cg_coverage_control=1


