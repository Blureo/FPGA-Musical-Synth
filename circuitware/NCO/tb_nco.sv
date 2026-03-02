`timescale 1ps/1ps

module tb_nco;

    parameter CLK_PERIOD = 40690; // 1 / 24.576 MHz ~= 40690 ps

    logic rst;
    logic master_clk;
    logic sample_clk_en;
    logic bit_clk_en;
    logic nco_mute;
    logic [31:0] accumulator_increment_value;
    logic [15:0] sample_output;

    // Only needed for debugging
    logic [31:0] accumulator_value;
    logic [15:0] sample_li_offset;

    int print_count = 0;


    nco uut_1
    (
        .rst(rst),
        .master_clk(master_clk),
        .sample_clk_en(sample_clk_en),
        .nco_mute(nco_mute),
        .accumulator_increment_value(accumulator_increment_value),
        .sample_output(sample_output),
        .accumulator_value(accumulator_value),
        .sample_li_offset(sample_li_offset)
    );

    clk_div uut_2
    (
        .master_clk(master_clk),
        .rst(rst),
        .sample_clk_en(sample_clk_en),
        .bit_clk_en(bit_clk_en)
    );

    initial begin
        master_clk = 0;
        forever #(CLK_PERIOD/2) master_clk = ~master_clk;
    end


    initial begin
        rst = 0;
        accumulator_increment_value = 32'h800000;

        #CLK_PERIOD;
        #CLK_PERIOD;
        rst = 1;
        #CLK_PERIOD;
        #CLK_PERIOD;

        $display("NCO Testbench Starting");

        $display("sample_clock_enable=%d", sample_clk_en);

    end

    always @(posedge master_clk) begin
        // $display("sample_clock_enable=%b", sample_clk_en);
        if (sample_clk_en) begin
            /*
            $display("accumulator_value=%d", accumulator_value);
            $display("Sample LI Offset=%d", sample_li_offset);
            $display("sample_output=%d\n", sample_output);
            */
            $display("%d", sample_output);
            print_count++;
        end

        if (print_count >= 200) begin
            $display("Ending simulation");
            $finish;
        end
    end
    
endmodule