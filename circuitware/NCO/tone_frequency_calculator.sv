`define SAMPLE_RATE   48000
`define ACCUMULATOR_BIT_DEPTH   32
`define TONE_FREQUENCY(frequency, SAMPLE_RATE, ACCUMULATOR_BIT_DEPTH) ((ACCUMULATOR_BIT_DEPTH) * (frequency) / (SAMPLE_RATE))

module tone_frequency_calculator
(
    // io
    input  logic clk,
    input  logic rst,
    
    input  logic key1,
    input  logic key1,
    input  logic key2,
    input  logic key3,
    input  logic key4,
    input  logic key5,
    input  logic key6,
    input  logic key7,
    input  logic key8,
    input  logic key9,
    input  logic key10,
    input  logic key11,
    input  logic key12,

    output reg [15:0] nco_increment_value,
    output reg nco_mute, // boolean

    output logic test_LED_R
);

    reg [15:0] next_nco_increment_value;

    always_comb begin
        if (!rst) mute = 1; 

        next_nco_accumulator_value = 0;
        test_LED_R = 1;

        if      (key1)  next_nco_increment_value = TONE_FREQUENCY(261.6);
        else if (key2)  next_nco_increment_value = TONE_FREQUENCY();
        else if (key3)  next_nco_increment_value = TONE_FREQUENCY();
        else if (key4)  next_nco_increment_value = TONE_FREQUENCY();
        else if (key5)  next_nco_increment_value = TONE_FREQUENCY();
        else if (key6)  next_nco_increment_value = TONE_FREQUENCY();
        else if (key7)  next_nco_increment_value = TONE_FREQUENCY();
        else if (key8)  next_nco_increment_value = TONE_FREQUENCY();
        else if (key9)  next_nco_increment_value = TONE_FREQUENCY();
        else if (key10) next_nco_increment_value = TONE_FREQUENCY();
        else if (key11) next_nco_increment_value = TONE_FREQUENCY();
        else if (key12) next_nco_increment_value = TONE_FREQUENCY();
        else next_nco_accumulator_value = 0;

        nco_accumulator_value = next_nco_accumulator_value;
        if (nco_accumulator_value > 0) begin
            test_LED_R = 0;
            mute = 0;
        end
        else mute = 1;
    end

endmodule