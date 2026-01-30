module synth
(
    input  logic master_clk, // 12.288 MHz
    input  logic reset,

    input  logic synth_key1,
    input  logic synth_key2,
    input  logic synth_key3,
    input  logic synth_key4,
    input  logic synth_key5,
    input  logic synth_key6,
    input  logic synth_key7,
    input  logic synth_key8,
    input  logic synth_key9,
    input  logic synth_key10,
    input  logic synth_key11,
    input  logic synth_key12,

    output logic i2s_sd,
    output logic i2s_ws,
    output logic i2s_bclk, // 3.028 MHz –> 48 kHz sample rate
    output logic [4:0] bit_counter,

    output logic [7:0] tone_half_period
);

    logic debounced_key1;
    logic debounced_key2;
    logic debounced_key3;
    logic debounced_key4;
    logic debounced_key5;
    logic debounced_key6;
    logic debounced_key7;
    logic debounced_key8;
    logic debounced_key9;
    logic debounced_key10;
    logic debounced_key11;
    logic debounced_key12;

    // logic [7:0] half_period;

    wave_period_selector tone_period_selector
    (
        .clk(master_clk),
        .rst(reset),
        .key1(debounced_key1),
        .key2(debounced_key2),
        .key3(debounced_key3),
        .key4(debounced_key4),
        .key5(debounced_key5),
        .key6(debounced_key6),
        .key7(debounced_key7),
        .key8(debounced_key8),
        .key9(debounced_key9),
        .key10(debounced_key10),
        .key11(debounced_key11),
        .key12(debounced_key12),
        .current_half_period(tone_half_period)
    );

    i2s_transmitter transmitter
    (
        .clk(master_clk),
        .rst(reset),
        .wave_half_period(tone_half_period),
        .bit_clock(i2s_bclk),
        .word_select(i2s_ws),
        .sound_data(i2s_sd),
        .bit_counter(bit_counter)
    );

// key debouncing modules
    debouncer key1_debounce
    (
        .clk(master_clk),
        .raw_signal(synth_key1),
        .clean_signal(debounced_key1)
    );
    debouncer key2_debounce
    (
        .clk(master_clk),
        .raw_signal(synth_key2),
        .clean_signal(debounced_key2)
    );
    debouncer key3_debounce
    (
        .clk(master_clk),
        .raw_signal(synth_key3),
        .clean_signal(debounced_key3)
    );
    debouncer key4_debounce
    (
        .clk(master_clk),
        .raw_signal(synth_key4),
        .clean_signal(debounced_key4)
    );
    debouncer key5_debounce
    (
        .clk(master_clk),
        .raw_signal(synth_key5),
        .clean_signal(debounced_key5)
    );
    debouncer key6_debounce
    (
        .clk(master_clk),
        .raw_signal(synth_key6),
        .clean_signal(debounced_key6)
    );
    debouncer key7_debounce
    (
        .clk(master_clk),
        .raw_signal(synth_key7),
        .clean_signal(debounced_key7)
    );
    debouncer key8_debounce
    (
        .clk(master_clk),
        .raw_signal(synth_key8),
        .clean_signal(debounced_key8)
    );
    debouncer key9_debounce
    (
        .clk(master_clk),
        .raw_signal(synth_key9),
        .clean_signal(debounced_key9)
    );
    debouncer key10_debounce
    (
        .clk(master_clk),
        .raw_signal(synth_key10),
        .clean_signal(debounced_key10)
    );
    debouncer key11_debounce
    (
        .clk(master_clk),
        .raw_signal(synth_key11),
        .clean_signal(debounced_key11)
    );
    debouncer key12_debounce
    (
        .clk(master_clk),
        .raw_signal(synth_key12),
        .clean_signal(debounced_key12)
    );


endmodule