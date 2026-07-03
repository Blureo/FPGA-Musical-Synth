// pico & pico-ice libraries
#include "pico/stdlib.h"
#include "pico/stdio.h"
#include "boards.h"
#include "ice_cram.h"
#include "ice_fpga.h"
#include "ice_led.h"

// Custom Libraries
#include "dI2Srx.hpp"

// TinyUSB
#include "USB-audio_functions.hpp"
#include "tusb_config.h"
#include "bsp/board_api.h"
#include "tusb.h"

#define FPGA_RESET 30

// driver globals
dI2Srx g_I2Srx;

uint8_t bitstream[] = {
#include "bitstream.h"
};

int main(void) {
    // pico-sdk initializations
    stdio_init_all();
    board_init();

    // other initializations
    g_I2Srx.Init();
    tusb_init();
    ice_led_init();
    
    // Initialize the FPGA reset pin without generating a clock
    ice_fpga_init(FPGA_DATA, 48);

    // Write the whole bitstream to the FPGA CRAM
    ice_cram_open(FPGA_DATA);
    ice_cram_write(bitstream, sizeof(bitstream));
    ice_cram_close();

    // reset FPGA
    gpio_init(FPGA_RESET);
    gpio_set_dir(FPGA_RESET, GPIO_OUT);
    gpio_put(FPGA_RESET, 0);
    sleep_ms(50);
    gpio_put(FPGA_RESET, 1);

    while (true) {
        audio_task();
        tud_task();
    }
}
