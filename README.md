# rigol-dgx_flake
A flake to wrap the rigol-dg1022 python lib from PyPi, and because I couldn't find source on github its also here

oh and btw its only like kinda tested, I was running into some issues getting a RigolDG-812 recognized by anything, but I can import the lib and have it error out for not finding anything so looks good

[Below is the projects README](./rigol-dgx/README.md)
# Rigol DGx Python Driver

This package provides a Python driver for controlling Rigol DGx arbitrary waveform generators via USB or Ethernet.

Confirmed to work with **DG1022**, **DG1062**, **DG4102**.

## Usage

```python
from rigol_dg1022 import RigolDG

# Connect to the device
dg = RigolDG()

# Set a sine wave on Channel 1
dg.apply_waveform(channel=1, waveform="SIN", frequency=1000, amplitude=1, offset=0)

# Turn on the output for Channel 1
dg.set_output(channel=1, state=True)

# Get the current frequency of Channel 1
freq = dg.get_frequency(channel=1)
print(f"Current frequency: {freq} Hz")

# Turn off the output
dg.set_output(channel=1, state=False)
```

