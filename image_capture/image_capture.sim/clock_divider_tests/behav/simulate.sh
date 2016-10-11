#!/bin/bash -f
xv_path="/home/michael/bin/Vivado/2016.2/Vivado/2016.2"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xsim clock_divider_testbench_behav -key {Behavioral:clock_divider_tests:Functional:clock_divider_testbench} -tclbatch clock_divider_testbench.tcl -view /home/michael/Projects/Xilinx/VideoControlIP/image_capture/tests/clock_divider_tests/clock_divider_testbench_behav.wcfg -log simulate.log
