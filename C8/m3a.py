"""
This M-file, m3a.py, is for Project 3 on methods of braking
of separately-excited dc motor in Chapter 8
It is to be used in conjunction with the Simulink file s3a.py
for the first two parts of the projects, that is
plugging and dynamic braking. The m-file m3b.py is for
the other part of the project on regenerative braking.

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
Rload = 1e6
D = 0  # damping
J = 0.5  # rotor inertia in kgm2

# Set Rext for each method, one at a time

# Plugging method
Rext = 6.054  # Set Rext for plugging method
Vbrake = -Vrated

# Transfer to keyboard for simulation
print('Run plugging case, return to program by typing "return"')
input('Press Enter to continue...')

plot_option = input('Do you want plots? (y/n): ').lower() == 'y'

if plot_option:
    # Note: 'y' should come from simulation
    # Assuming 'y' is available with columns: time, Ia, ?, wm, ...
    # y = ... # from simulation

    # Example plotting code (uncomment when y is available):
    """
    plt.figure()
    plt.subplot(4, 1, 1)
    plt.plot(y[:, 0], y[:, 1])
    plt.title('Armature current in plugging method')
    plt.ylabel('Ia in A')

    plt.subplot(4, 1, 2)
    plt.plot(y[:, 0], y[:, 3])
    plt.ylim(-200, 200)
    plt.title('Rotor speed in plugging method')
    plt.ylabel('wm in rad/sec')
    """
    pass

# Dynamic braking method
Rext = 2.929  # Set Rext for dynamic method
Vbrake = 0

# Transfer to keyboard for simulation
print('Run dynamic braking case, return to program by typing "return"')
input('Press Enter to continue...')

if plot_option:
    # Example plotting code (uncomment when y is available):
    """
    plt.subplot(4, 1, 3)
    plt.plot(y[:, 0], y[:, 1])
    plt.title('Armature current in dynamic braking method')
    plt.ylabel('Ia in A')

    plt.subplot(4, 1, 4)
    plt.plot(y[:, 0], y[:, 3])
    plt.title('Rotor speed in dynamic braking method')
    plt.ylabel('wm in rad/sec')
    plt.xlabel('time in sec')

    plt.tight_layout()
    plt.show()
    """
    pass
