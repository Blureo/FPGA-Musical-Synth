/*
This module divides the input 24.576 MHz clock signal down to the required clock signals
by using enable signals. These enable signals will be pulsed on for one of the master clock
signals, but will only be pulsed at either 1.536MHz or 48kHz.
*/

module clk_div
(
    input logic master_clk,
    input logic rst,
    output logic sample_clk_en,
    output logic bit_clk_en
);

    logic [8:0] sample_clk_counter; // 48kHz Sample Clock
    logic [3:0] bit_clk_counter; // 1.536MHz Bit Clock

    always_ff @(posedge master_clk or negedge rst) begin
        if (!rst) begin
            sample_clk_counter <= 9'b0;
            bit_clk_counter <= 4'b0;

            sample_clk_en <= 1'b0;
            bit_clk_en <= 1'b0;
        end else begin
            // Divide by 512
            if (sample_clk_counter == 9'd511) begin
                sample_clk_counter <= 9'b0;
                sample_clk_en <= 1'b1; // Set enable to high
            end else begin
                // increment counter
                sample_clk_counter <= sample_clk_counter + 1'b1;
                sample_clk_en <= 1'b0; // Set enable to low
            end

            // Divide by 16
            if (bit_clk_counter == 4'd15) begin
                bit_clk_counter <= 4'b0;
                bit_clk_en <= 1'b1;
            end else begin
                // increment counter
                bit_clk_counter <= bit_clk_counter + 1'b1;
                bit_clk_en <= 1'b0; // Set enable to low
            end
        end
    end

endmodule