@echo off
set xv_path=C:\\XilinxTools\\Vivado\\2016.2\\bin
call %xv_path%/xsim test_clock_divider_behav -key {Behavioral:test_clock_divider:Functional:test_clock_divider} -tclbatch test_clock_divider.tcl -view E:/oms/VideoControlIP/image_capture/test/test_clock_divider_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
