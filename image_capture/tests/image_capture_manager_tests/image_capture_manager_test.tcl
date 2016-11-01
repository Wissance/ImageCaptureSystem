#AXI Signals
add_force {/image_capture_manager_testbench/s00_axi_aclk} -radix hex {1 0ns} {0 5000ps} -repeat_every 10000ps
add_force {/image_capture_manager_testbench/s00_axi_aresetn} -radix hex {0} {1 100us} {0 970us} 
add_force {/image_capture_manager_testbench/s00_axi_awaddr} -radix hex {0} {0xF 200us} {0 250us}
#add_force {/image_capture_manager_testbench/s00_axi_awprot} 
add_force {/image_capture_manager_testbench/s00_axi_awvalid} -radix hex {0} {1 270us} {0 280us}
add_force {/image_capture_manager_testbench/s00_axi_wdata} -radix hex {0} {0xFFFF0000 300us} {0 400us}
add_force {/image_capture_manager_testbench/s00_axi_wstrb} -radix hex {0} {1 300us} {0 310us}
add_force {/image_capture_manager_testbench/s00_axi_wvalid} -radix hex {0} {1 350us} {0 360us}
add_force {/image_capture_manager_testbench/s00_axi_bready} -radix hex {0} {1 370us} {0 380us}
#add_force {/image_capture_manager_testbench/s00_axi_araddr}
#add_force {/image_capture_manager_testbench/s00_axi_arprot}
#add_force {/image_capture_manager_testbench/s00_axi_arvalid}
#add_force {/image_capture_manager_testbench/s00_axi_rready}


