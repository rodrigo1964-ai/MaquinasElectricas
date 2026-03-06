"""
M-file m4.py is for Project 4 on universal motor in Chapter 8.

m4.py loads the following machine parameters of dc machine
and plots the results of the simulation
"""

import numpy as np
import matplotlib.pyplot as plt

# Machine parameters
Prated = 325
Frated = 60
wrated = 2 * np.pi * Frated
Vrated = 120  # rms voltage
Iarated = 3.5  # rms amp
wmrated = 2800 * (2 * np.pi) / 60
Trated = Prated / wmrated
Ra = 0.6
Rse = 0.1
Laq = 0.010
Lse = 0.026
J = 0.015  # rotor inertia in kgm2

# Entering magnetization curve data:
wmo = 1500 * (2 * np.pi) / 60  # speed at which mag. curve data was taken

# Load voltage values of mag. curve
SEVP4 = np.array([-160, -155, -150, -145, -140, -135, -130, -125, -120,
                  -115, -110, -105, -100, -90, -80, -70, -60, -50, -40,
                  -30, -20, -10, 0, 10, 20, 30, 40, 50, 60, 70, 80, 90,
                  100, 105, 110, 115, 120, 125, 130, 135, 140, 145, 150,
                  155, 160])

# Load main field current values of mag. curve
SEIP4 = np.array([-14.225, -12.275, -10.725, -9.725, -9.100, -8.600,
                  -8.075, -7.650, -7.200, -6.850, -6.492, -6.135, -5.775,
                  -5.112, -4.500, -3.825, -3.275, -2.783, -2.250, -1.688,
                  -1.125, -0.542, 0.0, 0.542, 1.125, 1.688, 2.250, 2.783,
                  3.275, 3.825, 4.500, 5.112, 5.775, 6.135, 6.492, 6.850,
                  7.200, 7.650, 8.075, 8.600, 9.100, 9.725, 10.725, 12.275,
                  14.225])

# Plot mag curve measured at wmo
plt.figure()
plt.plot(SEIP4, SEVP4)
plt.axis('square')
plt.xlabel('Field Current (A)')
plt.ylabel('Voltage (V)')
plt.title('Magnetization Curve')
plt.grid(True)

# Initialize run condition
Sw4AC = 1  # set switch to use ac supply
wm0 = 0  # set initial speed to zero to start from standstill

# Transfer to keyboard for startup simulation
print('Simulation set up for startup run, perform simulation')
print('    then enter "return" for plots')
input('Press Enter to continue...')

# Note: 'y' should come from simulation
# y = ... # from simulation

# Example plotting code (uncomment when y is available):
"""
plt.figure()
plt.subplot(4, 1, 1)
plt.plot(y[:, 0], y[:, 1])
plt.title('AC supply voltage')
plt.ylabel('Va in V')

plt.subplot(4, 1, 2)
plt.plot(y[:, 0], y[:, 2])
plt.title('Internal voltage')
plt.ylabel('Ea in V')

plt.subplot(4, 1, 3)
plt.plot(y[:, 0], y[:, 3])
plt.title('Armature current')
plt.ylabel('Ia in A')

plt.subplot(4, 1, 4)
plt.plot(y[:, 0], y[:, 4])
plt.title('Torque')
plt.ylabel('Tem in Nm')
plt.xlabel('time in sec')

plt.tight_layout()
"""

print('Save plots before entering return to continue with load runs')
input('Press Enter to continue...')

# Initialize run condition
Sw4AC = 1  # set switch to use ac supply
wm0 = 275  # set initial speed near ss value for load stepping

# Transfer to keyboard for step torque run
print('Set up for ac fed, step torque run, perform simulation')
print('    then enter "return" for the dc fed case')
input('Press Enter to continue...')

"""
plt.figure()
plt.subplot(4, 1, 1)
plt.plot(y[:, 0], y[:, 3])
plt.title('Armature current with ac supply')
plt.ylabel('Ia in A')

plt.subplot(4, 1, 2)
plt.plot(y[:, 0], y[:, 4])
plt.title('Torque with ac supply')
plt.ylabel('Tem in Nm')
"""

# Initialize run condition
Sw4AC = 0  # set switch to use dc supply
wm0 = 350  # set initial speed near ss value for load stepping

print('Set up for dc fed, step torque run, perform simulation')
print('  then enter "return" for plots of both step torque runs')
input('Press Enter to continue...')

"""
plt.subplot(4, 1, 3)
plt.plot(y[:, 0], y[:, 3])
plt.title('Armature current with dc supply')
plt.ylabel('Ia in A')

plt.subplot(4, 1, 4)
plt.plot(y[:, 0], y[:, 4])
plt.title('Torque with dc supply')
plt.ylabel('Tem in Nm')
plt.xlabel('time in sec')

plt.tight_layout()
plt.show()
"""
