`timescale 1ns / 1ps

module linescanner_image_capture_unit_mimic_testbench;
    reg enable, main_clock_source, n_reset;
    wire pixel_captured, pixel_clock;
    wire[7:0] pixel_data;

    linescanner_image_capture_unit_mimic l(
        .enable,
        .main_clock_source,
        .n_reset,
        .pixel_data,
        .pixel_captured);

    initial begin
        main_clock_source <= 1'b0;
        n_reset <= 1'b0;
        #25 enable <= 1'b1;
    end
    
    always #10 main_clock_source <= ~main_clock_source;
    
endmodule
