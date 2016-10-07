@echo off
set xv_path=C:\\XilinxTools\\Vivado\\2016.2\\bin
call %xv_path%/xsim test_linescanner2stream_convertor_behav -key {Behavioral:test_linescanner2stream_convertor:Functional:test_linescanner2stream_convertor} -tclbatch test_linescanner2stream_convertor.tcl -view E:/oms/VideoControlIP/image_capture/test/test_clock_divider_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
