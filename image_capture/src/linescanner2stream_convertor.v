//`timescale 1ns / 1ps
//`include ".\src\linescanner2stream_convertor_M00_AXIS.v"
`define PIXELS_BUFFER_SIZE 4
`define BYTE_SIZE 8
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


module linescanner2stream_convertor #
(
    // Users to add parameters here

    // User parameters ends
    // Do not modify the parameters beyond this line   
    parameter integer C_M00_AXIS_TDATA_WIDTH = 32,
    parameter integer C_M00_AXIS_START_COUNT = 32 
    // Parameters of Axi Master Bus Interface M00_AXIS
)
(
    // Users to add ports here
    input wire enable,
    input wire [7:0] input_data,
    input wire pixel_captured,
    // User ports ends
    // Do not modify the ports beyond this line

     // Ports of Axi Master Bus Interface M00_AXIS
     input wire  m00_axis_aclk,
     input wire  m00_axis_aresetn,
     output wire  m00_axis_tvalid,
     output wire [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_axis_tdata,
     output wire [(C_M00_AXIS_TDATA_WIDTH/8)-1 : 0] m00_axis_tstrb,
     output wire  m00_axis_tlast,
     input wire  m00_axis_tready
);
    wire data_ready;
    wire reset;
    reg [1:0] byte_number;
    reg[C_M00_AXIS_TDATA_WIDTH - 1 : 0] output_data;
    supply1 vcc;
    supply0 gnd;

    FDCE data_ready_trigger(.C(~byte_number[1]), .CE(enable), .CLR(reset), .D(vcc), .Q(data_ready));
    FDCE data_ready_hold_trigger(.C(m00_axis_aclk), .CE(enable), .CLR(gnd), .D(data_ready), .Q(reset));
    
    // Instantiation of Axi Bus Interface M00_AXIS
    linescanner2stream_convertor_M00_AXIS # (.C_M_AXIS_TDATA_WIDTH(C_M00_AXIS_TDATA_WIDTH), .C_M_START_COUNT(C_M00_AXIS_START_COUNT)) 
        linescanner2stream_convertor_M00_AXIS_inst (
            .DATA_SOURCE(output_data),
            .DATA_READY(data_ready),
            .M_AXIS_ACLK(m00_axis_aclk),
            .M_AXIS_ARESETN(m00_axis_aresetn),
            .M_AXIS_TVALID(m00_axis_tvalid),
            .M_AXIS_TDATA(m00_axis_tdata),
            .M_AXIS_TSTRB(m00_axis_tstrb),
            .M_AXIS_TLAST(m00_axis_tlast),
            .M_AXIS_TREADY(m00_axis_tready)
        );   
    
    always@ (negedge pixel_captured)
    begin
        if(!m00_axis_aresetn)
        begin
            output_data = 0;
            byte_number = 0;
        end
        else
        begin
            if(enable)
            begin
                output_data = pack_pixel_data(byte_number, input_data);
                byte_number = byte_number + 1;
            end
        end
    end
	
	function [31:0] pack_pixel_data;
	
	input wire [7:0] pixel_counter_arg;
	input wire [7:0] input_data_arg;

	reg [31:0] result;
    begin
    
        //$display("pixel_counter, %h", pixel_counter_arg);
        //$display("input_data, %h", input_data_arg [7:0]);
        if(pixel_counter_arg == 0)
            result [7:0]  =  input_data_arg [7:0];
        else if(pixel_counter_arg == 1)
            result [15:8]  =  input_data_arg [7:0];
        else if(pixel_counter_arg == 2)
            result [23:16]  =  input_data_arg [7:0];
        else if(pixel_counter_arg == 3)
            result [31:24]  =  input_data_arg [7:0];
        //$display("result inside, %h", result);
        pack_pixel_data = result;
    end
	endfunction
	
	// User logic ends
endmodule
