`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2016 01:59:05 PM
// Design Name: 
// Module Name: test_linescanner2stream_convertor
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


module test_linescanner2stream_convertor #
(
    AXI_BUS_WIDTH = 32
)
(
    input wire enable,
    input wire [7:0] pixel_data,
    input wire pixel_captured,
    input wire axi_aclk,
    input wire axi_aresetn,
    input wire axi_tready,
    output wire axi_tvalid,
    output wire axi_tlast,
    output wire [AXI_BUS_WIDTH - 1 : 0] axi_tdata,
    output wire [(AXI_BUS_WIDTH / 8)-1 : 0] axi_tstrb
);
    
    linescanner2stream_convertor (.enable(enable), .input_data(pixel_data), pixel_captured(pixel_captured),
                                  .m00_axis_aclk(axi_aclk), .m00_axis_aresetn(axi_aresetn), .m00_axis_tvalid(axi_tvalid),
                                  .m00_axis_tdata(axi_tdata), .m00_axis_tstrb(axi_tstrb), . m00_axis_tlast(axi_tlast), .m00_axis_tready(axi_tready));
endmodule
