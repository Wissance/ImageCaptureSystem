`timescale 1ns / 1ps
`define MUTEX_FREE 0
`define MUTEX_BUSY 1
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.10.2016 16:17:23
// Design Name: 
// Module Name: FIFO
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


module FIFO #
(
    parameter FIFO_SIZE = 8,
    parameter DATA_WIDTH =32
)
(
    input wire enable,
    input wire clear,
    output wire fifo_ready,
    input wire push_clock,
    input wire pop_clock,
    inout wire [DATA_WIDTH - 1 : 0] data,
    output reg popped_last
);

    reg [FIFO_SIZE - 1 : 0] fifo_data [DATA_WIDTH - 1 : 0];
    reg mutex;
    reg [FIFO_SIZE - 1 : 0] position;
    reg [DATA_WIDTH - 1 : 0] buffer;
    
    initial mutex = `MUTEX_FREE;
    initial position = 0;
    initial buffer = 0;
    
    assign fifo_ready = mutex;
    assign data = buffer;
    
    always@ (posedge clear)
    begin
        mutex = `MUTEX_BUSY;
        position <= 0;
        for(position = 0; position < FIFO_SIZE; position = position + 1)
            fifo_data[position] <= 0;
        position <= 0;
        mutex = `MUTEX_FREE;
        popped_last = 0;
    end
    
    always@ (posedge push_clock)
    begin
        if(mutex == `MUTEX_FREE)
        begin
            popped_last = 0;
            fifo_data[position] <= data;
            position <= position + 1;
            if(position == FIFO_SIZE - 1)
                position <= 0;          
        end
    end
    
    always@ (posedge pop_clock)
    begin
       if(mutex == `MUTEX_FREE)
       begin
           buffer <= fifo_data[position];
           if(position <= 0)
              popped_last <= 1;
           else
              position <= position - 1;
              popped_last = 0;
       end
    end
    
endmodule
