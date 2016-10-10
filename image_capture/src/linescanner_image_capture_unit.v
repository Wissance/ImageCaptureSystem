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
    input wire enable,
    input wire[7:0] data,
    output reg rst_cvc,
    output reg rst_cds,
    output reg sample,
    input wire end_adc,
    input wire lval,
    input wire pixel_clock,
    input main_clock_source,
    output main_clock,
    input wire n_reset,
    output reg load_pulse,
    output wire[7:0] pixel_data,
    output wire pixel_captured);
    
    assign main_clock = main_clock_source;
    assign pixel_captured = lval;
    assign pixel_data = data;
    
    reg[7:0] clock_counter, clock_count_end_adc_re, sm_state;
    reg send_load_pulse;
    
    always @ (posedge pixel_clock) begin
        if(!n_reset) begin
            clock_counter = 0;
            sm_state = 0;
            rst_cvc = 1'b1;
            rst_cds = 1'b1;
            sample = 1'b0;
        end
        
        else if(enable) begin
          case (sm_state)
            0: begin
              rst_cvc = 1'b0;
              sm_state = 1;
            end
            
            1: if(clock_counter < 49) // 50 - 1
                clock_counter = clock_counter + 1;
              else begin
                rst_cds = 1'b0;
                clock_counter = 0;
                sm_state = 2;
              end
                
            2: if(clock_counter < 8) // skip 8clk
                clock_counter = clock_counter + 1;
              else if(end_adc) begin
                sample = 1'b1;
                clock_counter = 0;
                sm_state = 3;
               end
            
            3: if(clock_counter < 49) // 50 - 1
                clock_counter = clock_counter + 1;
              else begin
                sample = 1'b0;
                clock_counter = 0;
                sm_state = 4;
              end
              
            4: if(clock_counter < 7) // skip 7clk
                clock_counter = clock_counter + 1;
              else begin
                rst_cvc = 1'b1;
                rst_cds = 1'b1;
                clock_counter = 0;
                sm_state = 5;
              end
              
            5: if(clock_counter < 49) // 50 - 1
                clock_counter = clock_counter + 1;
              else begin
                clock_counter = 0;
                sm_state = 0;
              end
          endcase
      end
    end

    always @ (posedge pixel_clock) begin
      if(!n_reset) begin
        send_load_pulse = 1'b1;
        clock_count_end_adc_re = 0;
        load_pulse = 1'b0;
      end
      else if(load_pulse)
        load_pulse = 1'b0;
      else if(send_load_pulse && end_adc)
        if(clock_count_end_adc_re < 4)
          clock_count_end_adc_re = clock_count_end_adc_re + 1;
        else begin
          load_pulse = 1'b1;
          send_load_pulse = 1'b0;
          clock_count_end_adc_re = 0;
        end
    end
    
    always @ (negedge end_adc)
        send_load_pulse = 1'b1;
endmodule
