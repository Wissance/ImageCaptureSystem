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
ExecStep $xv_path/bin/xelab -wto 3f5aa38eb5794db5b10b89e0e066941c -m64 --debug typical --relax --mt 8 -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip --snapshot linescanner2stream_convertor_testbench_behav xil_defaultlib.linescanner2stream_convertor_testbench xil_defaultlib.glbl -log elaborate.log
