"""
This M-file, m3b.py, is for the regenerative braking part of Project 3
on methods of braking of separately-excited dc motor in Chapter 8
It is to be used in conjunction with the Simulink file s3b.py.
The M-file m3a.py is for the other part of the project on
plugging and dynamic braking.

Loads the following machine parameters of dc machine
and plots results from simulation
"""

import numpy as np
import matplotlib.pyplot as plt

# Machine parameters
Prated = 2 * 746
Vrated = 125
Iarated = 16
wmrated = 1750 * (2 * np.pi) / 60
Trated = Prated / wmrated
Ra = 0.14
Rf = 111
Rrh = 25  # ext field rheostat resistance
Laq = 0.018
Lf = 10
D = 0  # damping
J = 0.5  # rotor inertia in kgm2
wraise = wmrated
wlower = -wmrated / 3

print('Run simulation and return for plots')
input('Press Enter to continue...')

# Note: 'y' should come from simulation
# Assuming 'y' is available with columns: time, Va, Ia, Tem, wm
# y = ... # from simulation

# Example plotting code (uncomment when y is available):
"""
plt.figure()

plt.subplot(4, 1, 1)
plt.plot(y[:, 0], y[:, 4])
plt.title('Rotor speed')
plt.ylabel('wm in rad/sec')

plt.subplot(4, 1, 2)
plt.plot(y[:, 0], y[:, 2])
plt.title('Armature current')
plt.ylabel('Ia in A')

plt.subplot(4, 1, 3)
plt.plot(y[:, 0], y[:, 3])
plt.title('Electrical torque')
plt.ylabel('Tem in Nm')

plt.subplot(4, 1, 4)
plt.plot(y[:, 0], y[:, 1])
plt.title('Armature voltage')
plt.ylabel('Va in V')
plt.xlabel('time in sec')

plt.tight_layout()
print('Displaying results in Fig. 1')
plt.show()
"""
