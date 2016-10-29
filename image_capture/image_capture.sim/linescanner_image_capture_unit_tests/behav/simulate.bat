@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.2\\bin
call %xv_path%/xsim linescanner_image_capture_unit_testbench_behav -key {Behavioral:linescanner_image_capture_unit_tests:Functional:linescanner_image_capture_unit_testbench} -tclbatch linescanner_image_capture_unit_testbench.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
