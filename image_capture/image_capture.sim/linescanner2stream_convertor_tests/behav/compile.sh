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
echo "xvlog -m64 --relax -prj linescanner2stream_convertor_testbench_vlog.prj"
ExecStep $xv_path/bin/xvlog -m64 --relax -prj linescanner2stream_convertor_testbench_vlog.prj 2>&1 | tee compile.log
echo "xvhdl -m64 --relax -prj linescanner2stream_convertor_testbench_vhdl.prj -v 1"
ExecStep $xv_path/bin/xvhdl -m64 --relax -prj linescanner2stream_convertor_testbench_vhdl.prj -v 1 2>&1 | tee -a compile.log
