module shift_register_input
(
    input  logic master_clk,
    input  logic rst,

    input  logic serial_data,
    output logic data_latch,
    output logic data_clk,

    output reg [11:0] user_input_data
);

    always_comb begin
        
    end

endmodule