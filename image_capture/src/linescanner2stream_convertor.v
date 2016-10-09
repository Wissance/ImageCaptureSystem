`timescale 1ns / 1ps
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
    input enable,
    input [7:0] input_data,
    input pixel_captured,
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

// Instantiation of Axi Bus Interface M00_AXIS
	linescanner2stream_convertor_M00_AXIS # ( 
        .C_M_AXIS_TDATA_WIDTH(C_M00_AXIS_TDATA_WIDTH),
        .C_M_START_COUNT(C_M00_AXIS_START_COUNT)
	) linescanner2stream_convertor_M00_AXIS_inst (
        .M_AXIS_ACLK(m00_axis_aclk),
        .M_AXIS_ARESETN(m00_axis_aresetn),
        .M_AXIS_TVALID(m00_axis_tvalid),
        .M_AXIS_TDATA(m00_axis_tdata),
        .M_AXIS_TSTRB(m00_axis_tstrb),
        .M_AXIS_TLAST(m00_axis_tlast),
        .M_AXIS_TREADY(m00_axis_tready)
	);

	// Add user logic here
	reg[7:0] pixel_counter;
	reg[C_M00_AXIS_TDATA_WIDTH-1 : 0] output_data;
	integer int_buffer;
	
	initial pixel_counter = 8'b00000000;
	 	
	assign m00_axis_tdata = output_data;
	
    always@(pixel_captured)
    begin
       if(enable)
	   begin
	       pixel_counter = pixel_counter + 1;
	       int_buffer = input_data;
	       output_data = m00_axis_tdata + int_buffer << `BYTE_SIZE * pixel_counter;
	       if (pixel_counter == `PIXELS_BUFFER_SIZE)
	       begin
	           pixel_counter = 0;
	       end
       end
    end
	// User logic ends
endmodule
