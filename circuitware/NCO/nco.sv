module nco
{
    input logic rst
    input logic master_clk,
    input logic tone_clk,
    input logic [31:0] accumulator_increment_value 
};
    // Waveform ROM
    logic [15:0] waveform_rom [0:31];

    // Waveform Slope ROM
    logic [15:0] waveform_slope_rom [0:31];

    // 32 bit accumulator
    logic [31:0] accumulator_value;

    always_ff @(posedge clk or negedge rst) begin
        if (!rst_n) begin
            // Reset the register to 0
            accumulator_value <= 32'h0;
        end else begin
            accumulator_value <= accumulator_value + accumulator_increment_value;
        end
    end


endmodule