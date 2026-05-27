// This module interfaces with the shift registers that take in user input in parallel and output it serial to the FPGA

module shift_register_input
(
    // system
    input  logic clk,
    output logic user_input_data,

    // talking to shift register 
    input  logic serial_data,
    output logic chip_clk, // need a better name than this nonsense
    output logic data_shift,
    output logic chip_clk_inhibit
);

    // body
    
endmodule