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
      
    reg[7:0] sm1_state, sm2_state,
    sm1_clock_count, sm2_clock_count,
    sm1_num_clocks_to_wait, sm2_num_clocks_to_wait,
    sm1_state_to_go_to_after_waiting, sm2_state_to_go_to_after_waiting;
    
    always @ (posedge pixel_clock) begin
        if(!n_reset) begin
            sm1_clock_count <= 0;
            sm1_state <= 0;
            rst_cvc <= 1'b1;
            rst_cds <= 1'b1;
            sample <= 1'b0;
        end
        
        else
            case (sm1_state)
                0:
                if(enable) begin
                    rst_cvc <= 1'b0;
                    sm1_state <= 5;
                        
                    sm1_num_clocks_to_wait <= 48;
                    sm1_state_to_go_to_after_waiting <= 1;
                end
                
                1:
                begin
                    rst_cds <= 1'b0;
                    sm1_clock_count <= 0;
                    sm1_state <= 5;
                    
                    sm1_num_clocks_to_wait <= 7;
                    sm1_state_to_go_to_after_waiting <= 2;
                end
                  
                2:
                begin
                    sample <= 1'b1;
                    sm1_clock_count <= 0;
                    sm1_state <= 5;
                    
                    sm1_num_clocks_to_wait <= 48;
                    sm1_state_to_go_to_after_waiting <= 3;
                end
                   
                3:
                begin
                    sample <= 1'b0;
                    sm1_clock_count <= 0;
                    sm1_state <= 5;
                    
                    sm1_num_clocks_to_wait <= 6;
                    sm1_state_to_go_to_after_waiting <= 4;
                end
                
                4:
                begin
                    rst_cvc <= 1'b1;
                    rst_cds <= 1'b1;
                    sm1_state <= 0;
                end
                
                5:
                if(sm1_clock_count < sm1_num_clocks_to_wait)
                    sm1_clock_count <= sm1_clock_count + 1;
                else begin
                    sm1_clock_count <= 0;
                    sm1_state <= sm1_state_to_go_to_after_waiting;
                end
            endcase
    end

    always @ (posedge pixel_clock) begin
      if(!n_reset) begin
        sm2_clock_count <= 0;
        sm2_state <= 0;
        load_pulse <= 1'b0;
      end
      
      else
        case(sm2_state)
            0:
            if(end_adc) begin
                sm2_state <= 4;
                sm2_state_to_go_to_after_waiting <= 1;
            end
            
            1:
            begin
                load_pulse <= 1'b1;
                sm2_state <= 2;
            end
            
            2:
            begin
                load_pulse <= 1'b0;
                sm2_state <= 3;
            end
            
            3:
            if(!end_adc)
                sm2_state <= 0;
            
            4:
            if(sm2_clock_count < 3)
                sm2_clock_count <= sm2_clock_count + 1;
            else begin
                sm2_clock_count <= 0;
                sm2_state <= sm2_state_to_go_to_after_waiting;
            end
        endcase
    end
endmodule
