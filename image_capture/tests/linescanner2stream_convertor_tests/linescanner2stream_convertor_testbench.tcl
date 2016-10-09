#AXI Signals
add_force {/linescanner2stream_convertor_testbench/axi_aclk} -radix hex {1 0ns} {0 5000ps} -repeat_every 10000ps
add_force {/linescanner2stream_convertor_testbench/axi_aresetn} -radix hex {0} {1 100us} {0 970us} 
add_force {/linescanner2stream_convertor_testbench/axi_tready} -radix hex {0} {1 420us} {0 510us} {1 720us} 

#module enable
add_force {/linescanner2stream_convertor_testbench/enable} -radix hex {0} {1 200us} {0 900us} 
#data from scanner
add_force {/linescanner2stream_convertor_testbench/pixel_data} -radix hex {0} {0x0F 220us} {0xF0 270us} {0x0F 320us} {0xF0 370us} {0 420us} {0x0F 520us} {0xF0 570us} {0x0F 620us} {0xF0 670us} {0 720us}
add_force {/linescanner2stream_convertor_testbench/pixel_captured} -radix hex {0} {1 220us} {0 270us} {1 320us} {0 370us} {1 520us} {0 570us} {1 620us} {0 670us} 