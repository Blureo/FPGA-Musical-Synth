# FPGA-Synth
A musical synthesizer based on the ICE40 FPGA

### Status:
Circuitware currently being developed in SystemVerilog. Currently refactoring the wave_period_calculator module in an attempt to provide a better solution to the division needed for averaging half-periods. Test bench development will continue once this is complete.

### Hardware being used:
Using the pico2-ice development board. This choice was made because I already owned one.
I am also using the Adafruit I2S 3W Class D Amplifier for audio signal transmission in combination with a 3W 4Ω speaker.

### Software Tools:
I am using OSS-CAD-SUITE for ICE40 synthesis, and I am using Icarus Verilog (iverilog) for test bench simulation and other debugging.
