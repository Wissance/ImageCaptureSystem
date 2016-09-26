`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.09.2016 08:48:06
// Design Name: 
// Module Name: dragsterCaptureUnit
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


module dragsterCaptureUnit(
    input enable,
    input [7:0] data,
    output rstCvc,
    output rstCds,
    input sample,
    input endAdc,
    input lval,
    input pixelClock,
    output mainClock,
    output nReset,
    output loadPulse,
    output [7:0] out,
    output lineCaptured
    );
endmodule
