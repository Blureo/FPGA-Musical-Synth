module i2s_transmitter
(
    input  logic clk, // 12.288 MHz
    input  logic rst,
    input  logic [7:0] wave_half_period,

    output logic bit_clock,
    output logic word_select,
    output logic sound_data,

    output logic test_LED_B

    // ONLY FOR SIMULATION
    // output logic [4:0] bit_counter
);

    logic [1:0] bit_clock_timer; // divides 12.288 MHz MHz clock by 4 = 3.028 MHz
    logic [4:0] bit_counter; // keeps track of where we are in the I2S transmission loop
    logic [15:0] sound_bits; // holds
    logic [7:0] tone_timer; // the longest tone half-period should be 92 bit-clk cycles, so ~6.5 bits of space needed

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            bit_clock_timer <= 0;
            bit_clock <= 0;
        end 
        else begin
            // Increment timer
            bit_clock_timer <= bit_clock_timer + 1;
            
            // Toggle clocks when timer rolls over
            if (bit_clock_timer == 0) bit_clock <= ~bit_clock; 
        end
    end

    always_ff @(posedge bit_clock or negedge rst) begin
        if (!rst) begin
            bit_counter <= 31; // goes to 31, for 32 bits total, 16 bits each for left and right channels (right is silent in our case)
            sound_data  <= 0;
            word_select <= 0;
            tone_timer  <= 0;
            sound_bits  <= 0;
            test_LED_B  <= 1;
        end
        else begin
            // incrementation –> because register is 0-31 (2^5), which is what we want, we let roll-over reset it to zero
            bit_counter <= bit_counter + 1;

            // sound output
            /* 
            2 scenarios for left channel audio:
                bit_counter =  0, WS = 0 –> set to send out MSB       send out bit on bit_counter = 1
                bit_counter = 15, WS = 1 –> set to send send out LSB  send out bit on bit_counter = 16
            */
            if  (bit_counter < 16) sound_data <= sound_bits[15 - bit_counter]; // left-channel
            else                   sound_data <= sound_bits[15 - bit_counter + 16]; // right-channel

            // left-right channel transitions
            // word_select changes 1 bit before the next 16 bit audio sample, thus the LSB of each sample is sent out on the "wrong" word_select value (but this is part of the I2S protocol)
            if  (bit_counter == 31) word_select <= 0; // transition to left channel right before LSB of left-channel audio
            if  (bit_counter == 15) word_select <= 1; // transition to right channel right before LSB of right-channel audio

            // (maybe) increment tone timer and periodically switch to send out low instead of high
            // otherwise, put out no noise
            if  (bit_counter == 31) begin
                if (wave_half_period == 0) begin // no noise for not period
                    sound_bits <= 0; // zero, no sound
                    tone_timer <= 0;
                end
                else begin
                    if (tone_timer >= wave_half_period) begin
                        tone_timer <= 0;
                        if (sound_bits == 16'b0111111111111111) sound_bits <= 16'b1000000000000000; // 16'b1000000000000000; // 16'b1100000000000001
                        else                                    sound_bits <= 16'b0111111111111111; // 16'b0111111111111111; // 16'b0011111111111111
                    end
                    else tone_timer <= tone_timer + 1;
                end
            end

            //if (bit_counter == 14) test_LED_B <= ~test_LED_B;
        end
    end

endmodule
