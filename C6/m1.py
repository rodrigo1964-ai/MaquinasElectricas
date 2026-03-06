"""
M-file for projects 1 and 3 on induction machine in Chapter 6
It sets up the motor parameters, initial conditions, and
mechanical loading in the workspace for simulation,
and plots the results of the simulation.
"""
import numpy as np
import matplotlib.pyplot as plt
from p1hp import *  # Load 1 hp motor parameters

# Initialize to start from standstill with machine unexcited
Psiqso = 0  # stator q-axis total flux linkage
Psipqro = 0  # rotor q-axis total flux linkage
Psidso = 0  # stator d-axis total flux linkage
Psipdro = 0  # rotor d-axis total flux linkage
wrbywbo = 0  # pu rotor speed
tstop = 2  # use 2 sec simulation time for Fig. in text

# Program time and output arrays of repeating sequence signal for Tmech
tmech_time = np.array([0, 0.8, 0.8, 1.2, 1.2, 1.6, 1.6, tstop])
tmech_value = np.array([0, 0, -0.5, -0.5, -1., -1., -0.5, -0.5]) * Tb

print('Set up for running s1 or s3 simulation')
print('Parameters loaded from p1hp.py')
print('After simulation, call plot_results(y) to plot')

def plot_results(y):
    """
    Plot simulation results
    y should be array with columns: [time, vag, ias, wr/wb, Tem]
    """
    plt.figure(figsize=(10, 8))

    plt.subplot(4, 1, 1)
    plt.plot(y[:, 0], y[:, 1], '-')
    plt.ylabel('vag in V')
    plt.title('stator phase to neutral voltage')
    plt.grid(True)

    plt.subplot(4, 1, 2)
    plt.plot(y[:, 0], y[:, 2], '-')
    plt.ylabel('ias in A')
    plt.ylim([-25, 25])
    plt.title('stator current')
    plt.grid(True)

    plt.subplot(4, 1, 3)
    plt.plot(y[:, 0], y[:, 4], '-')
    plt.ylabel('Tem in Nm')
    plt.title('developed torque')
    plt.grid(True)

    plt.subplot(4, 1, 4)
    plt.plot(y[:, 0], y[:, 3], '-')
    plt.ylim([0, 1.2])
    plt.ylabel('wr/wb')
    plt.xlabel('time in sec')
    plt.title('pu rotor speed')
    plt.grid(True)

    plt.tight_layout()
    plt.show()
