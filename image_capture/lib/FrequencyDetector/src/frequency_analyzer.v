`timescale 1ns / 1ps

module frequency_analyzer #
(
    // FREQUENCY_2 MUST ALWAYS BE GREATER THAN FREQUENCY_1
    parameter FREQUENCY_1 = 9000,    // i.e. 9  kHz
    parameter FREQUENCY_2 = 11000,   // i.e. 11 kHz
    parameter CLOCK = 50000000       // i.e. 50 MHz
)
(
    input wire sample_data,
    input wire clock,
    input wire enable,
    input wire clear,
    output wire[31:0] f1_value,
    output wire[31:0] f2_value
);

integer frequency1_ticks = CLOCK / FREQUENCY_1;
integer frequency2_ticks = CLOCK / FREQUENCY_2;
integer frequency_counter = 0;
integer frequency1_counter = 0;
integer frequency2_counter = 0;
reg start_sample_value;

assign f1_value = frequency1_counter;
assign f2_value = frequency2_counter;

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
            if(frequency_counter == 0)
            begin
                start_sample_value = sample_data;
            end
            else
            begin
                if(sample_data != start_sample_value)
                begin
                    start_sample_value = sample_data;
                    if(check_frequency(frequency_counter))
                        frequency2_counter <= frequency2_counter +  frequency_counter;
                    else frequency1_counter <= frequency1_counter +  frequency_counter;
                frequency_counter <= 0;
                end
            end
            frequency_counter <= frequency_counter + 1;
        end
    end
end

function check_frequency;
input integer frequency;
reg result;
begin
    //todo: umv: first approach frequency could have deviation
    result = ~(frequency < frequency2_ticks);  
    check_frequency = result;
end
endfunction
endmodule
