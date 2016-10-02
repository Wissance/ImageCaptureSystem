create_clock -period 10.000 -name axi_clock -waveform {5.000 10.000} [get_ports s00_axi_aclk]
create_clock -period 20.000 -name axi_data_ready_clock -waveform {50.000 60.000} [get_ports {s00_axi_wstrb[0]}]
create_clock -period 100.000 -name axi_write_valid_clock -waveform {200.000 250.000} [get_ports s00_axi_wvalid]
