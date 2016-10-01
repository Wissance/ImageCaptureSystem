`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.09.2016 09:44:53
// Design Name: 
// Module Name: linescanner2stream_convertor
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


module linescanner2stream_convertor(
    input enable,
    input [7:0] input_data,
    input data_ready,
    output [31:0] stream_data,
    output stream_data_valid,
    input pixel_captured,
    output last_data,
    output [3:0] keep_data
    );
endmodule
