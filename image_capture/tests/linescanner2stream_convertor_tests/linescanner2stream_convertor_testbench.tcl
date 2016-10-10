#AXI Signals
add_force {/linescanner2stream_convertor_testbench/axi_aclk} -radix hex {1 0ns} {0 5000ps} -repeat_every 10000ps
add_force {/linescanner2stream_convertor_testbench/axi_aresetn} -radix hex {0} {1 100us} {0 970us} 
#add_force {/linescanner2stream_convertor_testbench/axi_tready} -radix hex {0} {1 420us} {0 510us} {1 720us} 
add_force {/linescanner2stream_convertor_testbench/axi_tready} -radix hex {1}

#module enable
add_force {/linescanner2stream_convertor_testbench/enable} -radix hex {0} {1 200us} {0 900us} 
#data from scanner
add_force {/linescanner2stream_convertor_testbench/pixel_data} -radix hex {0} {0x0F 220us} {0xF0 270us} {0x0F 320us} {0xF0 370us} {0 420us} {0x1F 520us} {0xF1 570us} {0x1F 620us} {0xF1 670us} {0 720us}
add_force {/linescanner2stream_convertor_testbench/pixel_captured} -radix hex {0} {1 220us} {0 230us} {1 270us} {0 280us} {1 320us} {0 330us} {1 370us} {0 380us} {1 520us} {0 530us} {1 570us} {0 580us} {1 620us} {0 630us} {1 670us} {0 680us} 