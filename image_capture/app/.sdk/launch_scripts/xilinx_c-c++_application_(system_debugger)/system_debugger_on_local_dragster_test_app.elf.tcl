connect -url tcp:127.0.0.1:3121
source E:/oms/VideoControlIP/image_capture/app/image_capture_design_wrapper_hw_platform_0/ps7_init.tcl
targets -set -filter {name =~"APU" && jtag_cable_name =~ "Platform Cable USB II 00001876ccce01"} -index 0
loadhw E:/oms/VideoControlIP/image_capture/app/image_capture_design_wrapper_hw_platform_0/system.hdf
targets -set -filter {name =~"APU" && jtag_cable_name =~ "Platform Cable USB II 00001876ccce01"} -index 0
stop
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Platform Cable USB II 00001876ccce01"} -index 0
rst -processor
targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Platform Cable USB II 00001876ccce01"} -index 0
dow E:/oms/VideoControlIP/image_capture/app/dragster_test_app/Debug/dragster_test_app.elf
bpadd -addr &main
