/*
This module takes in an accumulator increment value from the tone_frequency_calculator.sv module.
This increment value corresponds to a desired output frequency. Then, every sample of our 48000Hz
sample rate, the accumulator_value increments by the increment value. This gives us the location
to look in the waveform ROM look up tables for the sample at the phase we're at.

The accumulator_value will wrap around after every full cycle (period) giving us the periodic
wave output we want.

When the tone_frequency_calculator.sv module detects no keys are being pressed, it will give this
module a high value on the nco_mute logic line. This will set the accumulator value back to 0.
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

    always_ff @(posedge clk or negedge rst) begin
        if (!rst_n or nco_mute) begin
            // Reset the register to 0
            accumulator_value <= 32'h0;
        end else begin
            accumulator_value <= accumulator_value + accumulator_increment_value;
        end
    end


endmodule