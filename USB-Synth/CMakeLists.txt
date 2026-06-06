cmake_minimum_required(VERSION 3.13)

# 1. Pull SDK paths from the environment if they aren't explicitly passed to CMake
if(NOT DEFINED PICO_ICE_SDK_PATH)
    set(PICO_ICE_SDK_PATH $ENV{PICO_ICE_SDK_PATH})
endif()

if(NOT DEFINED PICO_SDK_PATH)
    set(PICO_SDK_PATH $ENV{PICO_SDK_PATH})
endif()

# Check that the paths actually resolved
if(NOT PICO_ICE_SDK_PATH OR NOT PICO_SDK_PATH)
    message(FATAL_ERROR "PICO_SDK_PATH and PICO_ICE_SDK_PATH must be set in your environment or passed to CMake.")
endif()

# specify compilation for the pico2-ice 
set(PICO_BOARD pico2_ice)

include(${PICO_ICE_SDK_PATH}/cmake/preinit_pico_ice_sdk.cmake)

# import the pico-sdk 
include(pico_sdk_import.cmake)

# configure the pico-sdk project
project(USB-Synth C CXX ASM)
pico_sdk_init()

# add the pico-ice-sdk
# 2. When adding a directory outside the source tree, you MUST specify a binary directory name (e.g., "pico_ice_sdk_build")
add_subdirectory(${PICO_ICE_SDK_PATH} pico_ice_sdk_build)

set(I2S_PIO ${CMAKE_CURRENT_LIST_DIR}/i2s_receiver.pio)

# add the local files
add_executable(${CMAKE_PROJECT_NAME}
    main.cpp
    dI2Srx.cpp
    interrupts.cpp
    USB-audio_functions.cpp
    usb_descriptors.c
)

pico_generate_pio_header(${CMAKE_PROJECT_NAME}
    ${I2S_PIO}
)

target_link_libraries(${CMAKE_PROJECT_NAME}
    pico_ice_sdk
    pico_stdlib
    pico_stdio
    pico_multicore
    hardware_dma
    hardware_pio
    hardware_irq
    tinyusb_device
    tinyusb_board
)

target_include_directories(${CMAKE_PROJECT_NAME} PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}
    ${CMAKE_CURRENT_BINARY_DIR}
)

pico_add_extra_outputs(${CMAKE_PROJECT_NAME})
pico_enable_stdio_usb(${CMAKE_PROJECT_NAME} 0)
pico_enable_stdio_uart(${CMAKE_PROJECT_NAME} 0)

# Define your Verilog sources with paths relative to this CMakeLists.txt
set(VERILOG_SOURCES 
    ${CMAKE_CURRENT_LIST_DIR}/circuitware/synth.sv 
    ${CMAKE_CURRENT_LIST_DIR}/circuitware/debouncer.sv 
    ${CMAKE_CURRENT_LIST_DIR}/circuitware/clock_divider.sv 
    ${CMAKE_CURRENT_LIST_DIR}/circuitware/i2s_transmitter.sv 
    ${CMAKE_CURRENT_LIST_DIR}/circuitware/tone_frequency_calculator.sv 
    ${CMAKE_CURRENT_LIST_DIR}/circuitware/multiplication.sv
    ${CMAKE_CURRENT_LIST_DIR}/circuitware/nco.sv
)

# Define your PCF constraints file
set(PCF_FILE ${CMAKE_CURRENT_LIST_DIR}/circuitware/synth.pcf)

add_custom_target(bitstream.h
    DEPENDS ${VERILOG_SOURCES} ${PCF_FILE}
    # 1. Yosys: Compile all files and use 'synth' as the top module
    COMMAND yosys -p 'synth_ice40 -abc9 -top synth -json bitstream.json' ${VERILOG_SOURCES}
    
    # 2. Nextpnr: Route using the UP5k sg48 package, 48MHz clock, and your custom .pcf
    COMMAND nextpnr-ice40 --package sg48 --up5k --freq 48 --top synth --pcf ${PCF_FILE} --json bitstream.json --asc bitstream.asc
    
    # 3. Icepack: Generate the binary bitstream
    COMMAND icepack bitstream.asc bitstream.bin
    
    # 4. Bin2Header: Convert binary bitstream into a C header for the Pico firmware
    COMMAND python ${CMAKE_CURRENT_LIST_DIR}/bin2header.py bitstream.bin >bitstream.h
)
add_dependencies(${CMAKE_PROJECT_NAME} bitstream.h)

# Generate .uf2, .bin, .hex, .dis alongside the .elf
pico_add_extra_outputs(${CMAKE_PROJECT_NAME})