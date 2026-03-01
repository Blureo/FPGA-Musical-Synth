/*
This module takes in an accumulator increment value from the tone_frequency_calculator.sv module.
This increment value corresponds to a desired output frequency. Then, every sample of our 48000Hz
sample rate, the accumulator_value increments by the increment value. This gives us the location
to look in the waveform ROM look up tables for the sample at the phase we're at.

The accumulator_value will wrap around after every full cycle (period) giving us the periodic
wave output we want.

When the tone_frequency_calculator.sv module detects no keys are being pressed, it will give this
module a high value on the nco_mute logic line. This will set the accumulator value back to 0.

To ensure that the i2s_transmitter module doesn't get halfway through serially outputting before
the sample gets changed by this module, the i2s_transmitter will locally save the sample to its
own register, in the process delaying the output by one sample, but preventing this issue.
*/

module nco
{
    input logic rst
    input logic master_clk,
    input logic tone_clk,
    input logic nco_mute,
    input logic [31:0] accumulator_increment_value 
};
    // Waveform ROM
    logic [15:0] waveform_rom [0:31];

    // Waveform Slope ROM
    logic [15:0] waveform_slope_rom [0:31];

    // 32 bit accumulator
    logic [31:0] accumulator_value;

    logic [15:0] sample;
    logic [15:0] slope;

    always_comb @(posedge clk or negedge rst) begin
        if (!rst_n or nco_mute) begin
            // Reset the register to 0
            accumulator_value <= 32'h0;
            sample <= 16'h0;
        end else begin
            accumulator_value <= accumulator_value + accumulator_increment_value;
            sample <= waveform_rom[accumulator_value[31:26]]; // Take 5 MSbs of the accumulator and get the value in the waveform rom at that address.
            slope <= waveform_slope_rom[accumulator_value[31:26]]; // Take 5 MSbs of the accumulator and get the value in the waveform slope rom at that address.

            // Here, we need to mulitply the slope by the least significant 27 bits of the accumulator value, then bitshift right by 27 bits. Then that value gets added to the sample.
        end
    end


endmodule