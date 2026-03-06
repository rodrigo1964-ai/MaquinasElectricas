"""
M-file for Project 1 on shunt generator in Chapter 8
Loads the following machine parameters of dc machine
"""

import numpy as np
import matplotlib.pyplot as plt

# Clear workspace (not needed in Python, but noted for reference)

# Machine parameters
Prated = 2 * 746
Vrated = 125
Iarated = 16
wmrated = 1750 * (2 * np.pi) / 60
Trated = Prated / wmrated
Ra = 0.24
Rf = 111
Rrh = 25  # ext field rheostat resistance
Laq = 0.018
Lf = 10
Rload = 1e6  # load resistance across armature terminals
J = 0.8  # rotor inertia in kgm2

# Entering Magnetization curve data:
wmo = 2000 * (2 * np.pi) / 60  # speed at which mag. curve data was taken

# Enter voltage values of mag. curve
SHVP1 = np.array([7.5, 12, 20, 24, 32, 40, 48, 59, 66, 74, 86, 97, 102.5,
                  107.5, 112, 117, 121, 125, 130, 135, 140, 143, 146, 152,
                  158, 164, 168, 172, 175])

# Enter main field current values of mag. curve
SHIP1 = np.array([0, 0.05, 0.1, 0.13, 0.18, 0.22, 0.26, 0.32, 0.36, 0.4,
                  0.47, 0.54, 0.575, 0.61, 0.64, 0.68, 0.71, 0.74, 0.78,
                  0.82, 0.86, 0.9, 0.93, 1.0, 1.1, 1.2, 1.3, 1.4, 1.5])

# Plot mag curve measured at wmo
plt.figure()
plt.plot(SHIP1, SHVP1)
plt.xlabel('Field Current (A)')
plt.ylabel('Voltage (V)')
plt.title('Magnetization Curve')
plt.grid(True)

# Set up linear array of armature current
Ia = np.arange(-40, 45, 5)
Iar = 0.04 * np.abs(np.arctan(Ia)) + 0.0001 * Ia**2

print('Simulation condition set up by m1.py')
print('Perform simulation and type return for plots')
input('Press Enter to continue...')

# Note: 'y' should come from simulation (e.g., from s1.py)
# Assuming 'y' is available with columns: time, If, Ea, Ia, Tem, Va
# y = ... # from simulation

# Example plotting code (uncomment when y is available):
"""
plt.figure()
plt.subplot(3, 1, 1)
plt.plot(y[:, 0], y[:, 1], '-')
plt.ylabel('If in A')
plt.title('Field current')

plt.subplot(3, 1, 2)
plt.plot(y[:, 0], y[:, 2], '-')
plt.ylabel('Ea in V')
plt.title('Internal voltage Ea')

plt.subplot(3, 1, 3)
plt.plot(y[:, 0], y[:, 3], '-')
plt.ylabel('Ia in A')
plt.title('Armature current')
plt.xlabel('Time in sec')

plt.figure()
plt.subplot(3, 1, 1)
plt.plot(y[:, 0], y[:, 4], '-')
plt.ylabel('Torque Tem')
plt.title('Developed torque')

plt.subplot(3, 1, 2)
plt.plot(y[:, 0], y[:, 5], '-')
plt.ylabel('Va in V')
plt.xlabel('Time in sec')
plt.title('Armature terminal voltage')

print('Save plots before typing return to exit')
input('Press Enter to exit...')
"""

plt.show()
