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
ExecStep $xv_path/bin/xsim linescanner2stream_convertor_testbench_behav -key {Behavioral:linescanner2stream_convertor_tests:Functional:linescanner2stream_convertor_testbench} -tclbatch linescanner2stream_convertor_testbench.tcl -view /home/michael/Projects/Xilinx/VideoControlIP/image_capture/tests/linescanner2stream_convertor_tests/linescanner2stream_convertor_behav.wcfg -log simulate.log
