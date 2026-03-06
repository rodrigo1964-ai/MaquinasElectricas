"""
M-file for Project 5 on some non-zero v_sg conditions in Chapter 6

m5.py sets up the motor parameters and initial values for simulation.
It also plots the results of the simulation.
"""
import numpy as np
import matplotlib.pyplot as plt
from p1hp import *  # Load 1 hp three-phase motor parameters

# Set initial condition and simulation parameter
Psiqso = 0  # stator q-axis total flux linkage
Psipqro = 0  # rotor q-axis total flux linkage
Psidso = 0  # stator d-axis total flux linkage
Psipdro = 0  # rotor d-axis total flux linkage
wrbywbo = 0  # pu rotor speed

tstop = 2  # use 2 sec simulation time for Fig. in text

print('Set up for running s5a or s5b simulation')
print('After simulation, call plot_results(y) for plots')

def plot_results(y):
    """
    Plot simulation results for Project 5

    Parameters:
    -----------
    y : array
        Simulation output with columns:
        [time, vag, ias, wr/wb, Tem, vsg, ...]
    """
    # First figure
    fig1 = plt.figure(figsize=(10, 10))

    plt.subplot(3, 1, 1)
    plt.plot(y[:, 0], y[:, 1], '-')
    plt.ylabel('vag in V')
    plt.title('stator phase to neutral voltage')
    plt.grid(True)

    plt.subplot(3, 1, 2)
    plt.plot(y[:, 0], y[:, 5], '-')
    plt.ylabel('vsg in V')
    plt.title('stator neutral voltage')
    plt.grid(True)

    plt.subplot(3, 1, 3)
    plt.plot(y[:, 0], y[:, 2], '-')
    plt.ylabel('ias in A')
    plt.title('stator current')
    plt.grid(True)

    plt.tight_layout()

    # Second figure
    fig2 = plt.figure(figsize=(10, 10))

    plt.subplot(3, 1, 1)
    plt.plot(y[:, 0], y[:, 4], '-')
    plt.ylabel('Tem in Nm')
    plt.title('developed torque')
    plt.grid(True)

    plt.subplot(3, 1, 2)
    plt.plot(y[:, 0], y[:, 3], '-')
    plt.ylabel('wr/wb')
    plt.title('pu rotor speed')
    plt.grid(True)

    plt.subplot(3, 1, 3)
    plt.xlabel('time in sec')
    plt.grid(True)

    plt.tight_layout()

    print('Save plots before closing')
    plt.show()

    return fig1, fig2
