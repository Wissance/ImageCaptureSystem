`timescale 1ns / 1ps

module FrequencyComparator #
(
    parameter FREQUENCY_1 = 9000,    // i.e. 9  kHz
    parameter FREQUENCY_2 = 11000,   // i.e. 11 kHz
    parameter CLOCK = 50000000       // i.e. 50 MHz
)
(
    input wire sample_data,
    input wire clock,
    input wire enable,
    input wire clear,
    output wire out
);

integer frequency1_ticks = CLOCK / FREQUENCY_1;
integer frequency2_ticks = CLOCK / FREQUENCY_2;
integer frequency_ticks = 0;
integer frequency1_ticks = 0;
integer frequency2_ticks = 0;
reg start_sample_value;

initial
begin
    start_sample_value = 0;
end

always @(posedge clock or posedge clear)
begin
    if(enable)
    begin
        if(clear)
        begin
            // todo: clear
            start_sample_value = 0;
        end
        else
        begin
            if(frequency_ticks == 0)
            begin
                start_sample_value = sample_data;
            end
            else
            begin
            end
            frequency_ticks <= frequency_ticks + 1;
        end
    end
end

endmodule
