#! /bin/bash
# $runsim [test bench ]
# 
# Three step VCS flow as described in Synopsys user guide. Uses implicit configuration
# which allows unknown modules to be automatically resolved. See individual command
# comments for details. An important caveat of implicit configuration is packages and
# interfaces are not resolved by the search algorithm and file names must match .
#
# coverage analysis is enabled. Results can be viewed by running: dve -cov -dir simv.vdb/
# Command to run DVE: dve -vpd vcdplus.vpd
# 
#

export VCS_LIC_EXPIRE_WARNING=1 #removes license expiry warning 
mkdir logs lib #VCS will not create it's output directories if they don't exist

echo
echo 
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo             RUNNING Vlogan
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo

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

vcs -file VCS_args.list $1

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
# -cm fsm+line+tgl+branch record coverage metrics 
# -cg_coverage_control=1 coverage data collection for all the coverage groups (not yet in code)
# -l log file directory
simv -l $PWD/logs/simv.log -cm fsm+line+tgl+branch -cg_coverage_control=1


