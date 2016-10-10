`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.10.2016 22:00:26
// Design Name: 
// Module Name: dragsterCaptureUnit_tb
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


module dragsterCaptureUnit_tb;
    reg main_clock_source, n_reset, lval, end_adc, enable;
    reg[7:0] data;
    
    wire[7:0] pixel_data;
    wire main_clock, rst_cvc, rst_cds, sample, load_pulse, pixel_captured, pixel_clock;

    dragsterCaptureUnit d(
    .enable,
    .data,
    .rst_cvc,
    .rst_cds,
    .sample,
    .end_adc,
    .lval,
    .pixel_clock,
    .main_clock_source,
    .main_clock,
    .n_reset,
    .load_pulse,
    .pixel_data,
    .pixel_captured);

    initial begin
        enable = 1'b1;
        main_clock_source = 1'b0;
        
        lval = 1'b0;
        data = 8'b00000000;
        end_adc = 1'b0;

        n_reset = 1'b1;
        #10 n_reset = 1'b0;
        #10 n_reset = 1'b1;
    end
    
    assign pixel_clock = main_clock;
    always #10 main_clock_source = ~main_clock_source;
    
    always @ (negedge rst_cds)
        #160 end_adc = 1'b1;
    always @ (negedge sample)
        #140 end_adc = 1'b0;
    always @ (posedge load_pulse) begin
        #1000 lval = 1'b1;
        data = 8'b11111111;
    end
        
    always @ (posedge lval) begin
        #5010 lval = 1'b0;
        data = 8'b00000000;
    end
endmodule
