# FPGA-Synth
A musical synthesizer based on the ICE40 FPGA

Video demonstration: https://youtu.be/o0nXdgJRZlI

### Status:
The project is functional! The method of synthesis used is described by this process:
> wave_period_selector sends the half-period of the frequency (musical note) associated with the key pressed to i2s_transmitter. i2s_transmitter sends a square wave via I2S that oscillates every half-period (the one sent to it by wave_period_selector) to an I2S DAC. This generates a square wave at the desired frequency.

Currently, the synthesizer only supports one key press at a time. If multiple keys are pressed, the key that gets checked first in wave_period_selector is the note that gets played. Further, due to the nature of this synthesis, this only supports square waves. Future iterations are likely to use alternative forms of synthesis, likely implementing a Numerically-Controlled Oscillator (NCO).

At this time, I will work on developing a PCB for the project, as the pico2-ice development board is completely overkill for this purpose. It remains to be seen whether or not I will design a PCB to accept the pico2-ice (or more simple development board, like pico-ice or upduino) or develop a standalone PCB that is not dependent on a development board.

### Hardware being used:
1. pico2-ice development board
2. Adafruit I2S 3W Class D Amplifier
3. Speaker; I am using a 3W 16Ω speaker. I was initially using a 3W 4Ω speaker, but it did not produce quality sound at low frequencies. I hypothesize that this is because of the shape of the speaker itself.

### Software Tools:
I am using OSS-CAD-SUITE for ICE40 synthesis, and I am using Icarus Verilog (iverilog) for test bench simulation and other debugging. The FPGA was programmed in SystemVerilog.
