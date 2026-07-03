`define INPUT_DATA_WIDTH    12

module shift_register_input
(
    input  logic master_clk,
    input  logic rst,

    input  logic serial_data,           //  Q7
    output logic data_latch,            // ~PL
    output logic data_clk,              //  CP

    output reg [11:0] user_input_data
);

    // first, latch
    // then, run the data_clk for a set number of inputs (dependent on how many buttons we're using)

    // parallel load:
    // 

    reg [2:0] state;
    reg [3:0] input_number;
    reg [11:0] user_input_shift_reg;


    always_ff @(posedge master_clk or negedge rst) begin
        if (!rst) begin // initial state is "hold; do nothing" from 74HC165 datasheet
            user_input_data <= 0;
            user_input_shift_reg <= 0;
            data_latch <= 1;        // ~PL
            data_clk <= 0;          //  CP
            input_number <= 0;
            state <= 0;
        end
        else begin
            case (state)
                0: begin // load
                    data_latch <= 0;
                    state <= 1;
                end
                1: begin // latch
                    data_latch <= 1;
                    state <= 2;
                end
                2: begin // take input
                    data_clk <= 1;
                    user_input_shift_reg <= {user_input_shift_reg[INPUT_DATA_WIDTH-2:0], serial_data};
                    state <= 3;
                end
                3: begin // operate input clock
                    data_clk <= 0;
                    if (input_number < 11) begin
                        state <= 2;
                        input_number <= input_number + 1;
                    end
                    else state <= 4;
                end
                4: begin // put out data to the rest of the system
                    user_input_data <= user_input_shift_reg;
                    state <= 0;
                    input_number <= 0;
                end
                default: begin
                    state <= 0;
                end
            endcase
        end
    end

endmodule