`timescale 1ns / 1ps

module linescanner_image_capture_unit_mimic(
    input wire enable,
    input main_clock_source,
    input wire n_reset,
    output reg[7:0] pixel_data,
    output reg pixel_captured);
    
    reg[7:0] pixel;
    
    always @ (posedge main_clock_source or negedge n_reset) begin
        if(!n_reset) begin
            pixel_data <= 0;
            pixel_captured <= 1'b0;
            pixel <= 0;
        end
        
        else
            if(enable) begin
                pixel_data <= pixel;
                pixel_captured <= 1'b1;
                
                if(pixel < 255)
                    pixel <= pixel + 1;
                else
                    pixel <= 0;
            end
            
            else begin
                pixel_data <= 0;
                pixel_captured <= 1'b0;
                pixel <= 0;
            end
    end
endmodule
