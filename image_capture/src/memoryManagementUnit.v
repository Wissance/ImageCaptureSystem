`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.09.2016 09:44:53
// Design Name: 
// Module Name: memoryController
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


module memoryManagementUnit(
    input [7:0] data,
    input loadPulse,
    input enable,
    output [31:0] dataOut,
    output dataPulse,
    input receiverDataReady,
    output lastData,
    output [3:0] keepData,
    output [71:0] commandData,
    output commandPulse,
    input receiverCommandReady
    );
endmodule
