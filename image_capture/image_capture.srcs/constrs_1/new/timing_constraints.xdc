create_clock -period 20.000 -name LINESCANNER0_PIXEL_CLOCK -waveform {0.000 10.000} [get_ports LINESCANNER0_PIXEL_CLOCK]
create_clock -period 20.000 -name LINESCANNER1_PIXEL_CLOCK -waveform {0.000 10.000} [get_ports LINESCANNER1_PIXEL_CLOCK]

set_clock_groups -name async_clk_fpga_0_LINESCANNER0_PIXEL_CLOCK -asynchronous -group clk_fpga_0 -group LINESCANNER0_PIXEL_CLOCK
set_clock_groups -name async_clk_fpga_0_LINESCANNER1_PIXEL_CLOCK -asynchronous -group clk_fpga_0 -group LINESCANNER1_PIXEL_CLOCK

create_generated_clock -name clock_divider_0_clock -source [get_pins image_capture_design_i/clock_divider_0/input_clock] -divide_by 2 [get_pins image_capture_design_i/clock_divider_0/output_clock]
create_generated_clock -name clock_divider_1_clock -source [get_pins image_capture_design_i/clock_divider_1/input_clock] -divide_by 2 [get_pins image_capture_design_i/clock_divider_1/output_clock]

# input delays
set_input_delay -clock [get_clocks LINESCANNER0_PIXEL_CLOCK] -min -add_delay 2.000 [get_ports LINESCANNER0_END_ADC]
set_input_delay -clock [get_clocks LINESCANNER0_PIXEL_CLOCK] -max -add_delay 4.000 [get_ports LINESCANNER0_END_ADC]

set_input_delay -clock [get_clocks LINESCANNER0_PIXEL_CLOCK] -min -add_delay 2.000 [get_ports LINESCANNER0_LVAL]
set_input_delay -clock [get_clocks LINESCANNER0_PIXEL_CLOCK] -max -add_delay 4.000 [get_ports LINESCANNER0_LVAL]

set_input_delay -clock [get_clocks LINESCANNER1_PIXEL_CLOCK] -min -add_delay 2.000 [get_ports LINESCANNER1_END_ADC]
set_input_delay -clock [get_clocks LINESCANNER1_PIXEL_CLOCK] -max -add_delay 4.000 [get_ports LINESCANNER1_END_ADC]

set_input_delay -clock [get_clocks LINESCANNER1_PIXEL_CLOCK] -min -add_delay 2.000 [get_ports LINESCANNER1_LVAL]
set_input_delay -clock [get_clocks LINESCANNER1_PIXEL_CLOCK] -max -add_delay 4.000 [get_ports LINESCANNER1_LVAL]

# output delays
set_output_delay -clock [get_clocks clock_divider_1_clock] -min -add_delay 0.000 [get_ports LINESCANNER0_MAIN_CLK]
set_output_delay -clock [get_clocks clock_divider_1_clock] -max -add_delay 3.000 [get_ports LINESCANNER0_MAIN_CLK]

set_output_delay -clock [get_clocks clock_divider_1_clock] -min -add_delay 0.000 [get_ports LINESCANNER1_MAIN_CLOCK]
set_output_delay -clock [get_clocks clock_divider_1_clock] -max -add_delay 3.000 [get_ports LINESCANNER1_MAIN_CLOCK]

set_output_delay -clock [get_clocks LINESCANNER0_PIXEL_CLOCK] -min -add_delay 0.000 [get_ports LINESCANNER0_LOAD_PULSE]
set_output_delay -clock [get_clocks LINESCANNER0_PIXEL_CLOCK] -max -add_delay 3.000 [get_ports LINESCANNER0_LOAD_PULSE]

set_output_delay -clock [get_clocks clk_fpga_0] -min -add_delay 0.000 [get_ports {LINESCANNER0_N_RESET[0]}]
set_output_delay -clock [get_clocks clk_fpga_0] -max -add_delay 3.000 [get_ports {LINESCANNER0_N_RESET[0]}]

set_output_delay -clock [get_clocks LINESCANNER0_PIXEL_CLOCK] -min -add_delay 0.000 [get_ports LINESCANNER0_RST_CDS]
set_output_delay -clock [get_clocks LINESCANNER0_PIXEL_CLOCK] -max -add_delay 3.000 [get_ports LINESCANNER0_RST_CDS]

set_output_delay -clock [get_clocks LINESCANNER0_PIXEL_CLOCK] -min -add_delay 0.000 [get_ports LINESCANNER0_RST_CVC]
set_output_delay -clock [get_clocks LINESCANNER0_PIXEL_CLOCK] -max -add_delay 3.000 [get_ports LINESCANNER0_RST_CVC]

set_output_delay -clock [get_clocks LINESCANNER0_PIXEL_CLOCK] -min -add_delay 0.000 [get_ports LINESCANNER0_SAMPLE]
set_output_delay -clock [get_clocks LINESCANNER0_PIXEL_CLOCK] -max -add_delay 3.000 [get_ports LINESCANNER0_SAMPLE]

set_output_delay -clock [get_clocks LINESCANNER1_PIXEL_CLOCK] -min -add_delay 0.000 [get_ports LINESCANNER1_LOAD_PULSE]
set_output_delay -clock [get_clocks LINESCANNER1_PIXEL_CLOCK] -max -add_delay 3.000 [get_ports LINESCANNER1_LOAD_PULSE]

set_output_delay -clock [get_clocks clk_fpga_0] -min -add_delay 0.000 [get_ports {LINESCANNER1_N_RESET[0]}]
set_output_delay -clock [get_clocks clk_fpga_0] -max -add_delay 3.000 [get_ports {LINESCANNER1_N_RESET[0]}]

set_output_delay -clock [get_clocks LINESCANNER1_PIXEL_CLOCK] -min -add_delay 0.000 [get_ports LINESCANNER1_RST_CDS]
set_output_delay -clock [get_clocks LINESCANNER1_PIXEL_CLOCK] -max -add_delay 3.000 [get_ports LINESCANNER1_RST_CDS]

set_output_delay -clock [get_clocks LINESCANNER1_PIXEL_CLOCK] -min -add_delay 0.000 [get_ports LINESCANNER1_RST_CVC]
set_output_delay -clock [get_clocks LINESCANNER1_PIXEL_CLOCK] -max -add_delay 3.000 [get_ports LINESCANNER1_RST_CVC]

set_output_delay -clock [get_clocks LINESCANNER1_PIXEL_CLOCK] -min -add_delay 0.000 [get_ports LINESCANNER1_SAMPLE]
set_output_delay -clock [get_clocks LINESCANNER1_PIXEL_CLOCK] -max -add_delay 3.000 [get_ports LINESCANNER1_SAMPLE]
