create_clock -period 20.000 -name LINESCANNER0_PIXEL_CLOCK -waveform {0.000 10.000} [get_ports LINESCANNER0_PIXEL_CLOCK]
create_clock -period 20.000 -name LINESCANNER1_PIXEL_CLOCK -waveform {0.000 10.000} [get_ports LINESCANNER1_PIXEL_CLOCK]

set_clock_groups -name async_clk_fpga_0_LINESCANNER0_PIXEL_CLOCK -asynchronous -group clk_fpga_0 -group LINESCANNER0_PIXEL_CLOCK
set_clock_groups -name async_clk_fpga_0_LINESCANNER1_PIXEL_CLOCK -asynchronous -group clk_fpga_0 -group LINESCANNER1_PIXEL_CLOCK

create_generated_clock -name clock_divider_0_clock -source [get_pins image_capture_design_i/clock_divider_0/input_clock] -divide_by 2 [get_pins image_capture_design_i/clock_divider_0/output_clock]
create_generated_clock -name clock_divider_1_clock -source [get_pins image_capture_design_i/clock_divider_1/input_clock] -divide_by 5 [get_pins image_capture_design_i/clock_divider_1/output_clock]

# input delays
set_input_delay -clock [get_clocks LINESCANNER0_PIXEL_CLOCK] -min -add_delay 2.000 [get_ports LINESCANNER0_END_ADC]
set_input_delay -clock [get_clocks LINESCANNER0_PIXEL_CLOCK] -max -add_delay 4.000 [get_ports LINESCANNER0_END_ADC]

set_input_delay -clock [get_clocks LINESCANNER0_PIXEL_CLOCK] -min -add_delay 2.000 [get_ports LINESCANNER0_LVAL]
set_input_delay -clock [get_clocks LINESCANNER0_PIXEL_CLOCK] -max -add_delay 4.000 [get_ports LINESCANNER0_LVAL]

set_input_delay -clock [get_clocks LINESCANNER1_PIXEL_CLOCK] -min -add_delay 2.000 [get_ports LINESCANNER1_END_ADC]
set_input_delay -clock [get_clocks LINESCANNER1_PIXEL_CLOCK] -max -add_delay 4.000 [get_ports LINESCANNER1_END_ADC]

set_input_delay -clock [get_clocks LINESCANNER1_PIXEL_CLOCK] -min -add_delay 2.000 [get_ports LINESCANNER1_LVAL]
set_input_delay -clock [get_clocks LINESCANNER1_PIXEL_CLOCK] -max -add_delay 4.000 [get_ports LINESCANNER1_LVAL]

#set_input_delay -clock [get_clocks clock_divider_0_clock] -min -add_delay 2.000 [get_ports LINESCANNER_MOSI]
#set_input_delay -clock [get_clocks clock_divider_0_clock] -max -add_delay 4.000 [get_ports LINESCANNER_MOSI]

set_input_delay -clock [get_clocks clock_divider_0_clock] -min -add_delay 2.000 [get_ports LINESCANNER_MISO]
set_input_delay -clock [get_clocks clock_divider_0_clock] -max -add_delay 4.000 [get_ports LINESCANNER_MISO]

# output delays
set_output_delay -clock [get_clocks clock_divider_1_clock] -min -add_delay 0.000 [get_ports LINESCANNER0_MAIN_CLOCK]
set_output_delay -clock [get_clocks clock_divider_1_clock] -max -add_delay 3.000 [get_ports LINESCANNER0_MAIN_CLOCK]

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

set_output_delay -clock [get_clocks clock_divider_0_clock] -min -add_delay 0.000 [get_ports LINESCANNER_MOSI]
set_output_delay -clock [get_clocks clock_divider_0_clock] -max -add_delay 3.000 [get_ports LINESCANNER_MOSI]

#set_output_delay -clock [get_clocks clock_divider_0_clock] -min -add_delay 0.000 [get_ports LINESCANNER_MISO]
#set_output_delay -clock [get_clocks clock_divider_0_clock] -max -add_delay 3.000 [get_ports LINESCANNER_MISO]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets {LINESCANNER1_PIXEL_CLOCK_IBUF}]
set_property PACKAGE_PIN K18 [get_ports {LINESCANNER0_TAP_A[6]}]
set_property PACKAGE_PIN K15 [get_ports {LINESCANNER0_TAP_A[3]}]
set_property PACKAGE_PIN R20 [get_ports {LINESCANNER0_TAP_A[0]}]
set_property PACKAGE_PIN F16 [get_ports {LINESCANNER1_TAP_A[5]}]
set_property PACKAGE_PIN B19 [get_ports LINESCANNER1_MAIN_CLOCK]
set_property PACKAGE_PIN L18 [get_ports LINESCANNER0_PIXEL_CLOCK]
set_property PACKAGE_PIN A16 [get_ports LINESCANNER1_RST_CDS]
set_property PACKAGE_PIN R15 [get_ports LINESCANNER0_RST_CVC]
set_property PACKAGE_PIN D20 [get_ports LINESCANNER1_END_ADC]
set_property PACKAGE_PIN H15 [get_ports {LINESCANNER0_TAP_A[5]}]
set_property PACKAGE_PIN M15 [get_ports {LINESCANNER0_N_RESET[0]}]
set_property PACKAGE_PIN P17 [get_ports LINESCANNER0_LOAD_PULSE]
set_property PACKAGE_PIN H19 [get_ports {LINESCANNER1_TAP_A[7]}]
set_property PACKAGE_PIN F18 [get_ports LINESCANNER1_RST_CVC]
set_property PACKAGE_PIN G20 [get_ports {LINESCANNER1_TAP_A[4]}]
set_property PACKAGE_PIN D22 [get_ports {LINESCANNER1_TAP_A[1]}]
set_property PACKAGE_PIN F19 [get_ports {LINESCANNER1_TAP_A[2]}]
set_property PACKAGE_PIN J18 [get_ports LINESCANNER0_LVAL]
set_property PACKAGE_PIN J20 [get_ports LINESCANNER0_RST_CDS]
set_property PACKAGE_PIN H22 [get_ports {LINESCANNER1_TAP_A[0]}]
set_property PACKAGE_PIN H17 [get_ports {LINESCANNER1_TAP_A[3]}]
set_property PACKAGE_PIN C20 [get_ports LINESCANNER1_PIXEL_CLOCK]
set_property PACKAGE_PIN E19 [get_ports {LINESCANNER1_TAP_A[6]}]
set_property PACKAGE_PIN K19 [get_ports LINESCANNER0_END_ADC]
set_property PACKAGE_PIN J16 [get_ports {LINESCANNER0_TAP_A[1]}]
set_property PACKAGE_PIN B21 [get_ports LINESCANNER1_LVAL]
set_property PACKAGE_PIN P16 [get_ports LINESCANNER0_SAMPLE]
set_property PACKAGE_PIN L16 [get_ports {LINESCANNER0_TAP_A[4]}]
set_property PACKAGE_PIN E16 [get_ports LINESCANNER1_LOAD_PULSE]
set_property PACKAGE_PIN J15 [get_ports {LINESCANNER0_TAP_A[7]}]
set_property PACKAGE_PIN E21 [get_ports {LINESCANNER1_N_RESET[0]}]
set_property PACKAGE_PIN E18 [get_ports LINESCANNER1_SAMPLE]

set_property PACKAGE_PIN M21 [get_ports {LINESCANNER0_TAP_A[2]}]
set_property PACKAGE_PIN M19 [get_ports LINESCANNER0_MAIN_CLOCK]

set_property PACKAGE_PIN N19 [get_ports LINESCANNER_SCK]
set_property PACKAGE_PIN G19 [get_ports {LINESCANNER_CS[1]}]
set_property PACKAGE_PIN N22 [get_ports {LINESCANNER_CS[0]}]
set_property PACKAGE_PIN N17 [get_ports LINESCANNER_MISO]
