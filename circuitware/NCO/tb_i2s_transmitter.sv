`timescale 1ps/1ps

module tb_i2s_transmitter;

    parameter CLK_PERIOD = 40690; // 1 / 24.576 MHz ~= 40690 ps
    
    logic master_clock;
    logic i2s_bclk_enable;
    logic reset;
    logic [15:0] sound_sample_input;
    logic i2s_bclk;
    logic i2s_ws;
    logic i2s_sd;
    logic test_LED;
    logic [4:0] i2s_bit_counter;

    i2s_transmitter uut
    (
        .clk(master_clock),
        .bit_clk_enable(i2s_bclk_enable),
        .rst(reset),
        .new_sound_sample(sound_sample_input),
        .bit_clock(i2s_bclk),
        .word_select(i2s_ws),
        .sound_data(i2s_sd),
        .test_LED_B(test_LED),
        .testing_bit_counter(i2s_bit_counter)
    );

    initial begin
        master_clock = 0;
        #CLK_PERIOD master_clock = ~master_clock;
    end

    initial begin
        reset = 0;
        sound_sample_input = 16'b1110111011101110;

        #CLK_PERIOD;
        #CLK_PERIOD;
        reset = 1;
        #CLK_PERIOD;
        #CLK_PERIOD;

        $display("I2S Signals:\n");

        repeat (32) begin 
            @(posedge master_clock)
            while (!i2s_bclk_enable) begin
                // do nothing; wait for it to go high
            end
            $display("bc=%b   ws=%b   sd=%b", i2s_bit_counter, i2s_ws, i2s_sd);
        end

        $finish;
    end

endmodule