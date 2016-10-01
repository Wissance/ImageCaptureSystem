`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.09.2016 08:48:06
// Design Name: 
// Module Name: linescanner_image_capture_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module linescanner_image_capture_unit(
    input enable,
    input [7:0] data,
    output rst_cvc,
    output rst_cds,
    input sample,
    input end_adc,
    input lval,
    input pixel_clock,
    output main_clock,
    output n_reset,
    output load_pulse,
    output [7:0] out,
    output pixel_captured
    );
endmodule
