@echo off
set xv_path=C:\\XilinxTools\\Vivado\\2016.2\\bin
call %xv_path%/xsim fifo_testbench_behav -key {Behavioral:fifo_testbench:Functional:fifo_testbench} -tclbatch fifo_testbench.tcl -view E:/oms/VideoControlIP/image_capture/tests/fifo_tests/fifo_testbench_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
