"""
This is simply a test of the NCO concept in python


"""

import math
import matplotlib.pyplot as plt
import numpy

ROM_LENGTH = 32

SINE_ROM = [math.sin(2*math.pi*i/ROM_LENGTH) for i in range(ROM_LENGTH)]
COSINE_ROM = [2*math.pi/ROM_LENGTH*math.cos(2*math.pi*i/ROM_LENGTH) for i in range(ROM_LENGTH)]

SAMPLES_NUMBER = 128

samples = []

# We need to increment SAMPLES_NUMBER times through this process
for sample in range(SAMPLES_NUMBER):
    counter_output = sample*ROM_LENGTH/SAMPLES_NUMBER

    waveform_rom_output = SINE_ROM[math.floor(counter_output)]
    waveform_derivative_rom_output = COSINE_ROM[math.floor(counter_output)]

    output_sample = waveform_rom_output + (counter_output % 1) * waveform_derivative_rom_output

    samples.append(output_sample)

#print(SINE_ROM)

plt.figure(figsize=(8, 5))

x_rom = numpy.linspace(0, SAMPLES_NUMBER, ROM_LENGTH)

plt.plot(x_rom, SINE_ROM, label="ROM Data", color="steelblue")
plt.plot(x_rom, COSINE_ROM, label="DERIV Data", color="green")
plt.plot(samples, label="NCO Output", color="red")
plt.legend()
plt.grid(True, alpha=0.3)
plt.show()