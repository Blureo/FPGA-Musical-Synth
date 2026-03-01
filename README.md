# FPGA-Musical-Synth
A musical synthesizer based on the ICE40 FPGA

Video demonstration: https://youtu.be/o0nXdgJRZlI

### Status: under active reconstruction
#### Recounstruction information:
The project is currently being revised to employ a numerically controlled oscillator (NCO) to replace the current method of synthesis. After this method of synthesis has been tested and employed, the following will items will be worked on:
##### 1. Multiple Key Press Support:
> This could be done a variety of ways, either by averaging frequencies together or by using multiple NCOs at once. How this ends up getting accomplished will be decided on later.
##### 2. Supporting more keys:
> The current idea is to use a shift register and read each key sequentially. This could also be done by using multiple MUX's, which would grant a some amount of parallelism in reading which keys are being pressed.

#### The functional build:
The wave_period_selector method of synthesis used is described by this process:
> wave_period_selector sends the half-period of the frequency (musical note) associated with the key pressed to i2s_transmitter. i2s_transmitter sends a square wave via I2S that oscillates every half-period (the one sent to it by wave_period_selector) to an I2S DAC. This generates a square wave at the desired frequency.

Currently, the synthesizer only supports one key press at a time. If multiple keys are pressed, the key that gets checked first in wave_period_selector is the note that gets played. Further, due to the nature of this synthesis, this only supports square waves.

### Hardware being used:
1. pico2-ice development board
2. Adafruit I2S 3W Class D Amplifier
3. Speaker; I am using a 3W 16Ω speaker. I was initially using a 3W 4Ω speaker, but it did not produce quality sound at low frequencies, likely due to 16Ω speaker having more back-and-forth travel than the 4Ω speaker.

### Software Tools:
##### 1. Synthesis:
> OSS-CAD-SUITE is being used for ICE40 synthesis.
##### 2. Simulation:
> Icarus Verilog (iverilog) is being used for test bench simulation and other debugging. Verilator may replace icarus if it is decided that it is superior for testbenching this project's verilog modules.
##### 3. HDL:
> The FPGA was programmed in SystemVerilog. 
