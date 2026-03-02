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
(
    input logic rst,
    input logic master_clk,
    input logic sample_clk_en,
    input logic nco_mute,
    input logic [31:0] accumulator_increment_value,
    output logic signed [15:0] sample_output,
    output logic [31:0] accumulator_value,
    output logic signed [15:0] sample_li_offset
    //output logic [16:0] sample
);
    // Waveform ROM
    logic signed [15:0] waveform_rom [0:31];

    // Waveform Slope ROM
    logic signed [15:0] waveform_slope_rom [0:31];

    // Populate rom data
    initial begin
        $readmemh("waveform_rom.mem", waveform_rom);
        $readmemh("waveform_slope_rom.mem", waveform_slope_rom);
    end

    // 32 bit accumulator
    //logic [31:0] accumulator_value;

    // Linear interpolation stuff
    logic signed [15:0] sample;
    logic signed [15:0] slope;
    //logic [15:0] sample_li_offset;

    // Sequential state machine logic
    logic read_roms;
    logic multiply;
    logic add;
    
    logic sample_flag;

    // A state machine to sequentially process things and output a sample at 48kHz
    always_ff @(posedge master_clk or negedge rst) begin
        if (!rst || nco_mute) begin
            // Reset the register to 0
            accumulator_value <= 32'h0;
            sample <= 16'h0;
            sample_output <= 16'h0;
            slope <= 16'h0;
            sample_flag <= 0;
            read_roms <= 0;
            multiply <= 0;
            add <= 0;
        end
        else begin
            if (sample_flag) begin // The sample flag is brought high whenever the 48kHz clock hits a rising edge.
                sample_flag <= 0;
                accumulator_value <= accumulator_value + accumulator_increment_value;
                read_roms <= 1;
            end 
            else if (read_roms) begin
                read_roms <= 0;
                sample <= waveform_rom[accumulator_value[31:27]]; // Take 5 MSbs of the accumulator and get the value in the waveform rom at that address.
                slope <= waveform_slope_rom[accumulator_value[31:27]]; // Take 5 MSbs of the accumulator and get the value in the waveform slope rom at that address.
                multiply <= 1; // At this point we're ready to do the multiplication before we add it back to the sample
            end 
            else if (multiply) begin
                sample_li_offset <= (($signed({16'h0, accumulator_value[26:0]}) * (slope >>> 2)) >>> 27); // This will be replaced with booth's algorithm in the future
                multiply <= 0; // Run this after we've finished multiplying
                add <= 1;
            end 
            else if (add) begin
                sample_output <= sample + sample_li_offset;
                add <= 0;
            end
            if (sample_clk_en) begin // This runs at 48kHz
                sample_flag <= 1;
            end
        end
    end


endmodule