module synth
(
    input logic master_clock,
    input logic reset,

    input logic shift_register_serial_data,
    output logic shift_register_latch,
    output logic shift_register_clock,

    output logic i2s_bclk,
    output logic i2s_ws,
    output logic i2s_sd,

    output logic LED_BLUE,
    output logic LED_RED
);

    logic sample_clock_enable;
    logic bit_clock_enable;
    
    logic [11:0] shift_register_raw_data;
    logic [11:0] shift_register_clean_data;

    logic [31:0] nco_increment_value;
    logic nco_mute;

    logic signed [15:0] nco_output_sample;

    shift_register_input user_input_data
    (
        .master_clk(master_clock),
        .rst(reset),
        .serial_data(shift_register_serial_data),
        .data_latch(shift_register_latch),
        .data_clk(shift_register_clock),
        .user_input_data(shift_register_raw_data)
    );

    clk_div clock_divider
    (
        .master_clk(master_clock),
        .rst(reset),
        .sample_clk_en(sample_clock_enable),
        .bit_clk_en(bit_clock_enable)
    );

    debouncer key_debouncer
    (
        .master_clk(master_clock),
        .rst(reset),
        .raw_signal(shift_register_raw_data),
        .clean_signal(shift_register_clean_data)
    );

    tone_frequency_calculator key_input
    (
        .clk(master_clock),
        .rst(reset),
        .key_input(shift_register_clean_data),
        .nco_increment_value(nco_increment_value),
        .nco_mute(nco_mute),
        .test_LED_R(LED_RED)
    );

    // Only needed for debugging
    logic signed [31:0] accumulator_value;
    logic signed [15:0] sample_li_offset;

    nco numerically_controlled_oscillator
    (
        .rst(reset),
        .master_clk(master_clock),
        .sample_clk_en(sample_clock_enable),
        .nco_mute(nco_mute),
        .accumulator_increment_value(nco_increment_value),
        .sample_output(nco_output_sample),
        .accumulator_value(accumulator_value),
        .sample_li_offset(sample_li_offset)
    );

    i2s_transmitter transmitter
    (
        .clk(master_clock),
        .bit_clk_en(bit_clock_enable),
        .rst(reset),
        .new_sound_sample(nco_output_sample),
        .bit_clock(i2s_bclk),
        .word_select(i2s_ws),
        .sound_data(i2s_sd),
        .test_LED_B(LED_BLUE)
    );

endmodule