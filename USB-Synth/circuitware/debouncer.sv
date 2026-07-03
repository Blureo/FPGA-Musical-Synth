module debouncer 
(
    input  logic master_clk,                   // System clock
    input  logic rst,
    input  logic [11:0] raw_signal,     // Raw, noisy input from the button
    output logic [11:0] clean_signal    // Clean, debounced output
);

    parameter DEBOUNCE_THRESHOLD = 150000; // 150,000 cycles / 24.576 MHz = 6.1 ms

    reg [17:0] counter;              // Counter to measure stable time (20 bits for 1M)
    reg [11:0] key_prior_state;
    integer i;

    always_ff @(posedge master_clk or negedge rst) begin
        if (!rst) begin
            counter <= 0;
            key_prior_state <= 0;
            clean_signal <= 0;
        end
        else begin
            counter <= counter + 1;

            if (counter == DEBOUNCE_THRESHOLD) begin // this is purily arbitrary; can be any number
                for (i = 0; i < 12; i = i + 1) begin
                    if (raw_signal[i] == key_prior_state[i]) clean_signal[i] <= raw_signal[i];
                end
                key_prior_state <= raw_signal;
                counter <= 0;
            end
        end
    end
endmodule
