"""
Python conversion of M2.M
RLC circuit simulation - input parameters and initial conditions
and plot results of simulation
"""
import numpy as np
import matplotlib.pyplot as plt

# Input parameters and initial conditions
Rs = 50  # Rs = 50 ohms
L = 0.1  # L = 0.1 Henry
C = 1000e-6  # C = 1000 uF
VS_mag = 100  # magnitude of step voltage Vs in Volts
tdelay = 0.05  # initial delay of step voltage in sec
vCo = 0  # initial value of capacitor voltage
iLo = 0  # initial value of inductor current
tstop = 0.5  # stop time for simulation

print('Run simulation, then call plot_results(y) to plot')

def plot_results(y):
    """
    Plot simulation results
    y: array with columns [time, iS, vC, iL]
    """
    fig, axes = plt.subplots(3, 1, figsize=(10, 8))

    axes[0].plot(y[:, 0], y[:, 1])
    axes[0].set_title('source current')
    axes[0].set_ylabel('iS in A')

    axes[1].plot(y[:, 0], y[:, 2])
    axes[1].set_title('capacitor voltage')
    axes[1].set_ylabel('vC in V')

    axes[2].plot(y[:, 0], y[:, 3])
    axes[2].set_title('inductor current')
    axes[2].set_xlabel('time in sec.')
    axes[2].set_ylabel('iL in A')

    plt.tight_layout()
    plt.show()

# Example usage:
# from scipy.integrate import odeint
# # Define your ODE system here
# # y = simulate_rlc(Rs, L, C, VS_mag, tdelay, vCo, iLo, tstop)
# # plot_results(y)
