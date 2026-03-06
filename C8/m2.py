"""
M-file for Project 2 on starting of dc motor in Chapter 8
Loads the following machine parameters of dc machine
and plots results of simulation
"""

import numpy as np
import matplotlib.pyplot as plt

# Machine parameters
Prated = 10 * 746
Vrated = 220
Iarated = Prated / Vrated
wmrated = 1490 * (2 * np.pi) / 60
Trated = Prated / wmrated
Ra = 0.3
Laq = 0.012
J = 2.5  # rotor inertia in kgm2
D = 0.0  # damping factor

print('Run simulation then type in return when ready for plot')
input('Press Enter to continue...')

# Note: 'y' should come from simulation (e.g., from s2.py)
# Assuming 'y' is available with columns: time, Ea, Ia, wm
# y = ... # from simulation

# Example plotting code (uncomment when y is available):
"""
plt.figure()

plt.subplot(3, 1, 1)
plt.plot(y[:, 0], y[:, 1])
plt.title('Internal voltage Ea')
plt.ylabel('Ea in V')

plt.subplot(3, 1, 2)
plt.plot(y[:, 0], y[:, 2])
plt.title('Armature current Ia')
plt.ylabel('Ia in A')

plt.subplot(3, 1, 3)
plt.plot(y[:, 0], y[:, 3])
plt.title('Rotor speed')
plt.xlabel('time in sec')
plt.ylabel('wm in rad/sec')

plt.tight_layout()
plt.show()
"""
