@echo off
set xv_path=C:\\XilinxTools\\Vivado\\2016.2\\bin
echo "xvlog -m64 --relax -prj linescanner2stream_convertor_testbench_vlog.prj"
call %xv_path%/xvlog  -m64 --relax -prj linescanner2stream_convertor_testbench_vlog.prj -log xvlog.log
call type xvlog.log > compile.log
echo "xvhdl -m64 --relax -prj linescanner2stream_convertor_testbench_vhdl.prj -v 1"
call %xv_path%/xvhdl  -m64 --relax -prj linescanner2stream_convertor_testbench_vhdl.prj -v 1 -log xvhdl.log
call type xvhdl.log >> compile.log
if "%errorlevel%"=="1" goto END
if "%errorlevel%"=="0" goto SUCCESS
:END
exit 1
:SUCCESS
exit 0
