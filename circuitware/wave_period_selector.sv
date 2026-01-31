module wave_period_selector
(
    input  logic clk, 
    input  logic rst,

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
    
    output logic [7:0] current_half_period,

    output logic test_LED_R
);

    /* NEED TO FIND WAVE TIME FOR EACH FREQUENCY
        sample rate = 48 kHz –> 3.072 MHz / 32 bits / 2 cycles = 48 kHz

        Divide 48 kHz by note frequency; that is time for 1 cycle.
        Divide that time by 2 to get time for one high (or low) signal duration.
        Units of clk cycles

        Why are we using 3.072 MHz if the clk here is 12.288 MHz?
        Because, the bit_clock for the i2s_transmitter 
            is 3.072, which is achieved by dividing the 
            12.288 MHz signal
    */

    localparam half_period_1  = 92; // 0x5C | C4  = 261.6 Hz
    localparam half_period_2  = 87; // 0x57 | C#4 = 277.2 Hz
    localparam half_period_3  = 82; // 0x52 | D4  = 293.7 Hz
    localparam half_period_4  = 77; // 0x4D | Eb4 = 311.1 Hz
    localparam half_period_5  = 73; // 0x49 | E4  = 329.6 Hz
    localparam half_period_6  = 69; // 0x45 | F4  = 349.2 Hz
    localparam half_period_7  = 65; // 0x41 | F#4 = 370.0 Hz
    localparam half_period_8  = 61; // 0x3D | G4  = 392.0 Hz
    localparam half_period_9  = 58; // 0x3A | G#4 = 415.3 Hz
    localparam half_period_10 = 55; // 0x37 | A4  = 440.0 Hz
    localparam half_period_11 = 51; // 0x33 | Bb4 = 466.2 Hz
    localparam half_period_12 = 49; // 0x31 | B4  = 493.9 Hz
    
    logic [7:0] next_half_period;

    // calculate wave half-period
    always_comb begin
        next_half_period = 0;
        test_LED_R = 1;

        if (key1) next_half_period = half_period_1;
        else if (key2)  next_half_period = half_period_2;
        else if (key3)  next_half_period = half_period_3;
        else if (key4)  next_half_period = half_period_4;
        else if (key5)  next_half_period = half_period_5;
        else if (key6)  next_half_period = half_period_6;
        else if (key7)  next_half_period = half_period_7;
        else if (key8)  next_half_period = half_period_8;
        else if (key9)  next_half_period = half_period_9;
        else if (key10) next_half_period = half_period_10;
        else if (key11) next_half_period = half_period_11;
        else if (key12) next_half_period = half_period_12;
        else next_half_period = 0;

        current_half_period = next_half_period;
        if (current_half_period > 0) test_LED_R = 0;
    end


endmodule