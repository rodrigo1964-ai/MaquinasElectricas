"""
Python conversion of M4.M
Series resonant circuit simulation - input parameters and initial conditions
"""
import numpy as np
import matplotlib.pyplot as plt

# Input parameters and initial conditions
R = 12  # R in ohms
L = 0.231e-3  # L in H
C = 0.1082251e-6  # C in Farad
wo = np.sqrt(1 / (L * C))  # series resonant frequency in rad/sec
Vdc = 100  # magnitude of voltage = Vdc Volts
iLo = 0  # initial value of inductor current
vCo = 0  # initial voltage of capacitor voltage
tf = 10 * (2 * np.pi / wo)  # filter time constant
tstop = 25e-4  # stop time for simulation

# Set up time and output arrays of repeating sequence for Pref
Pref_time = np.array([0, 6e-4, 11e-4, 11e-4, 18e-4, 18e-4, tstop])
Pref_value = np.array([0, 600, 600, 300, 300, 600, 600])

# Determine steadystate characteristics of RLC circuit
we = np.arange(0.5 * wo, 1.5 * wo, 0.01 * wo)  # set up freq range
Y = np.zeros(len(we), dtype=complex)
PR = np.zeros(len(we))

for wind, w in enumerate(we):
    Y[wind] = 1 / (R + 1j * w * L + 1 / (1j * w * C))
    Irms = (4 * Vdc / (np.pi * np.sqrt(2))) * abs(Y[wind])  # rms value of i
    PR[wind] = Irms ** 2 * R

# Plot circuit characteristics
fig, axes = plt.subplots(2, 1, figsize=(10, 8))

axes[0].plot(we, np.abs(Y))
axes[0].set_xlabel('frequency in rad/sec')
axes[0].set_ylabel('admittance in mhos')

axes[1].plot(we, PR)
axes[1].set_xlabel('frequency in rad/sec')
axes[1].set_ylabel('power in watts')

plt.tight_layout()
plt.show()

print(f'Resonant frequency: {wo:.2f} rad/sec')
print('Run simulation, then call plot_simulation_results(y) to plot')

def plot_simulation_results(y):
    """
    Plot simulation results
    y: array with columns [time, Vs, PR, i, VC]
    """
    fig, axes = plt.subplots(4, 1, figsize=(10, 10))

    axes[0].plot(y[:, 0], y[:, 1])
    axes[0].set_title('excitation voltage')
    axes[0].set_ylabel('Vs in V')

    axes[1].plot(y[:, 0], y[:, 2])
    axes[1].set_title('load power')
    axes[1].set_ylabel('PR in W')

    axes[2].plot(y[:, 0], y[:, 3])
    axes[2].set_title('RLC current')
    axes[2].set_ylabel('i in A')

    axes[3].plot(y[:, 0], y[:, 4])
    axes[3].set_xlabel('time in sec')
    axes[3].set_title('capacitor voltage')
    axes[3].set_ylabel('VC in V')

    plt.tight_layout()
    plt.show()
