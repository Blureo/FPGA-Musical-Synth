`timescale 1ns/1ps

module tb_wave_period_selector;

    real CLK_PERIOD = 1000.0 / 3.028;

    logic clk;
    logic rst;
    logic key1;
    logic key2;
    logic key3;
    logic key4;
    logic key5;
    logic key6;
    logic key7;
    logic key8;
    logic key9;
    logic key10;
    logic key11;
    logic key12;
    logic [7:0] halfPeriod;

    wave_period_selector uut
    (
        .clk(clk),
        .rst(rst),
        .key1(key1),
        .key2(key2),
        .key3(key3),
        .key4(key4),
        .key5(key5),
        .key6(key6),
        .key7(key7),
        .key8(key8),
        .key9(key9),
        .key10(key10),
        .key11(key11),
        .key12(key12),
        .halfPeriod(halfPeriod)
    );

    initial begin
        key1 = 0;
        key2 = 0;
        key3 = 0;
        key4 = 0;
        key5 = 0;
        key6 = 0;
        key7 = 0;
        key8 = 0;
        key9 = 0;
        key10 = 0;
        key11 = 0;
        key12 = 0;
        clk = 0;
        forever #CLK_PERIOD clk = ~clk;
    end

    initial begin
        rst = 0;
        @(posedge clk);
        @(negedge clk);
        rst = 1;
        #CLK_PERIOD;
        rst = 0;
        #CLK_PERIOD;

        // key1 has halfPeriod = 92
        key1 = 1;
        #CLK_PERIOD;
        $display("key1 half period = %d", halfPeriod);
        key1 = 0;

        // key1 has halfPeriod = 92
        key2 = 1;
        #CLK_PERIOD;
        $display("key2 half period = %d", halfPeriod);
        key2 = 0;

        // key1 has halfPeriod = 92
        key3 = 1;
        #CLK_PERIOD;
        $display("key3 half period = %d", halfPeriod);
        key3 = 0;

        // key1 has halfPeriod = 92
        key4 = 1;
        #CLK_PERIOD;
        $display("key4 half period = %d", halfPeriod);
        key4 = 0;

        // key1 has halfPeriod = 92
        key5 = 1;
        #CLK_PERIOD;
        $display("key5 half period = %d", halfPeriod);
        key5 = 0;

        // key1 has halfPeriod = 92
        key6 = 1;
        #CLK_PERIOD;
        $display("key6 half period = %d", halfPeriod);
        key6 = 0;

        // key1 has halfPeriod = 92
        key7 = 1;
        #CLK_PERIOD;
        $display("key7 half period = %d", halfPeriod);
        key7 = 0;

        // key1 has halfPeriod = 92
        key8 = 1;
        #CLK_PERIOD;
        $display("key8 half period = %d", halfPeriod);
        key8 = 0;

        // key1 has halfPeriod = 92
        key9 = 1;
        #CLK_PERIOD;
        $display("key9 half period = %d", halfPeriod);
        key9 = 0;

        // key1 has halfPeriod = 92
        key10 = 1;
        #CLK_PERIOD;
        $display("key10 half period = %d", halfPeriod);
        key10 = 0;

        // key1 has halfPeriod = 92
        key11 = 1;
        #CLK_PERIOD;
        $display("key11 half period = %d", halfPeriod);
        key11 = 0;

        // key1 has halfPeriod = 92
        key12 = 1;
        #CLK_PERIOD;
        $display("key12 half period = %d", halfPeriod);
        key12 = 0;

        key9 = 1;
        key4 = 1; // multiple keys on, so we should get the first key in the if list to go on
        #CLK_PERIOD;
        $display("key4 and key9 gives key4 half period = %d", halfPeriod);

        $finish;
    end

endmodule