`timescale 1ns/1ps

module tb_synth;

real CLK_PERIOD = 1000.0 / 12.288;
real BCLK_PERIOD = 1000.0 / 3.028;

logic master_clk;
logic reset;
logic synth_key1;
logic synth_key2;
logic synth_key3;
logic synth_key4;
logic synth_key5;
logic synth_key6;
logic synth_key7;
logic synth_key8;
logic synth_key9;
logic synth_key10;
logic synth_key11;
logic synth_key12;
logic i2s_sd;
logic i2s_ws;
logic i2s_bclk;

logic [4:0] bit_counter;

logic [7:0] half_period;

synth dut
(
    .master_clk(master_clk),
    .reset(reset),
    .synth_key1(synth_key1),
    .synth_key2(synth_key2),
    .synth_key3(synth_key3),
    .synth_key4(synth_key4),
    .synth_key5(synth_key5),
    .synth_key6(synth_key6),
    .synth_key7(synth_key7),
    .synth_key8(synth_key8),
    .synth_key9(synth_key9),
    .synth_key10(synth_key10),
    .synth_key11(synth_key11),
    .synth_key12(synth_key12),
    .i2s_sd(i2s_sd),
    .i2s_ws(i2s_ws),
    .i2s_bclk(i2s_bclk),
    .bit_counter(bit_counter),
    .tone_half_period(half_period)
);

initial begin
    reset = 0;
    synth_key1 = 0;
    synth_key2 = 0;
    synth_key3 = 0;
    synth_key4 = 0;
    synth_key5 = 0;
    synth_key6 = 0;
    synth_key7 = 0;
    synth_key8 = 0;
    synth_key9 = 0;
    synth_key10 = 0;
    synth_key11 = 0;
    synth_key12 = 0;
    master_clk = 0;
    forever #(CLK_PERIOD / 2) master_clk = ~master_clk;
end

initial begin
    $display("test1");
    repeat (4) @(posedge master_clk);
    $display("test2");

    reset = 1;
    @(posedge i2s_bclk);
    reset = 0;
    #BCLK_PERIOD;
    #BCLK_PERIOD;
    reset = 1;
    @(posedge i2s_bclk);

    synth_key1 = 1;
    @(posedge i2s_bclk);
    
    repeat (4000) #BCLK_PERIOD @(posedge i2s_bclk);
    
    repeat (64) begin
        $display("tone_period=%d, bit-counter=%d, i2s_sd=%b, i2s_ws=%b", half_period, bit_counter, i2s_sd, i2s_ws);
        @(posedge i2s_bclk);
        #1;
    end

    synth_key1 = 0;
    synth_key6 = 1;

    repeat (4000) #BCLK_PERIOD @(posedge i2s_bclk);

    repeat (64) begin
        $display("tone_period=%d, bit-counter=%d, i2s_sd=%b, i2s_ws=%b", half_period, bit_counter, i2s_sd, i2s_ws);
        @(posedge i2s_bclk);
        #1;
    end

    $finish;
end

endmodule