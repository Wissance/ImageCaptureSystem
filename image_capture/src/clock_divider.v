`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.10.2016 05:53:55
// Design Name: 
// Module Name: clock_divider
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


module clock_divider #
(
    parameter clock_division = 2
)
(
    input wire reset,
    input wire input_clock,
    output wire output_clock
); 
    reg[7:0] counter;
    reg output_clock_value;
    
    assign output_clock =  clock_division == 1 ? input_clock & reset : output_clock_value; 
    
    //initial counter = 8'b00000000;
    
/*    integer counter = 0;

    
    if (clock_division == 1)
    begin            
        always@ (input_clock)
        begin
            output_clock <= input_clock;
        end
    end
    
    else
    begin
        always@ (posedge input_clock)
        begin
            counter = counter + 1;
            if(counter == clock_division)
            begin
                output_clock = ~output_clock;
                counter = 0;
            end
        end
    end*/
    
    always @(posedge input_clock)
    begin
         if(~reset)
         begin
             counter <= 0;
             output_clock_value <= 0;
         end
         else
         begin
             if(counter == clock_division - 1)
             begin
                 output_clock_value <= ~output_clock_value;
                 counter <= 1;
             end
             else
                 counter <= counter + 1;
         //if(counter == clock_division - 1)
             //counter <= 0;
         end
    end
    
endmodule
