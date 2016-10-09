@echo off
set xv_path=C:\\XilinxTools\\Vivado\\2016.2\\bin
call %xv_path%/xsim linescanner2stream_convertor_testbench_behav -key {Behavioral:linescanner2stream_convertor_tests:Functional:linescanner2stream_convertor_testbench} -tclbatch linescanner2stream_convertor_testbench.tcl -view E:/oms/VideoControlIP/image_capture/tests/linescanner2stream_convertor_tests/linescanner2stream_convertor_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
