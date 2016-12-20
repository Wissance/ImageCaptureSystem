@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.2\\bin
call %xv_path%/xsim image_capture_manager_testbench_behav -key {Behavioral:image_capture_manager_tests:Functional:image_capture_manager_testbench} -tclbatch image_capture_manager_testbench.tcl -view C:/Users/Ваня/VideoControlIP/image_capture/tests/image_capture_manager_tests/image_capture_manager_testbench_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
