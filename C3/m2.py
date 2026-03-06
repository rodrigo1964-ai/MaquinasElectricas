"""
Python conversion of M2.M
Project 2 on switching transients of a distributed parameter line in Chapter 3

Sets up parameters and initial conditions for simulation and plots results.
"""
import numpy as np
import matplotlib.pyplot as plt

# Source voltage magnitude, frequency, and inductance
Vrated = 500e3  # rated line to line 3-phase rms voltage
Epk = Vrated * np.sqrt(2/3)  # Peak value of phase voltage
we = 2 * np.pi * 60  # 60 Hz supply
Te = 1 / 60  # period of source voltage in secs
Ls = 0.1  # source inductance, Henry
tstop = 15 * Te  # simulation run time

# Distributed line parameters
d = 100  # 100 miles long
R = 0.15  # resistance of line, Ohm per mile
L = 2.96e-3  # inductance of line, Henry per mile
C = 0.017e-6  # capacitance of line, Farad per mile
Zc = np.sqrt(L / C)  # characteristic impedance in ohms
tdelay = d * np.sqrt(L * C)  # one-way propagation time delay in seconds
atten = np.exp(-(R / 2) * np.sqrt(C / L) * d)  # one-way attenuation
buffer_size = 20000  # buffer size of delay module

print(f'Characteristic impedance Zc = {Zc:.2f} Ω')
print(f'Propagation delay = {tdelay:.6f} sec')
print(f'Attenuation = {atten:.6f}')

# Load parameters
SL = 30e6 * (0.8 + 1j * 0.6)  # 30 MVA, 0.8 pf lagging
ZL = Vrated ** 2 / np.conj(SL)  # per phase load impedance in Ohms
RL = np.real(ZL)  # series RL load model resistance
LL = np.imag(ZL) / we  # series RL load model inductance

print(f'\nLoad impedance ZL = {ZL:.2f} Ω')
print(f'Load resistance RL = {RL:.2f} Ω')
print(f'Load inductance LL = {LL:.6f} H')

# Breaker's parameters
tc = 1 / 60  # one cycle closing time
Rc = 1000  # closing resistance in Ohms
to = 1 / 60  # one cycle opening time
Ro = 1000  # opening resistance in Ohms

print('\nRun simulation and call plot_results(y) to plot')

def plot_results(y):
    """
    Plot simulation results
    y: array with columns [time, e, Vb, IS, VS, VR, IR]
    """
    fig1, axes1 = plt.subplots(3, 1, figsize=(10, 10))

    axes1[0].plot(y[:, 0], y[:, 1], '-')
    axes1[0].set_ylabel('e in V')
    axes1[0].set_title('Source voltage')

    axes1[1].plot(y[:, 0], y[:, 2], '-')
    axes1[1].set_ylabel('Vb in V')
    axes1[1].set_title('Breaker voltage')

    axes1[2].plot(y[:, 0], y[:, 3], '-')
    axes1[2].set_ylabel('IS in A')
    axes1[2].set_title('Sending end current')

    plt.tight_layout()

    fig2, axes2 = plt.subplots(3, 1, figsize=(10, 10))

    axes2[0].plot(y[:, 0], y[:, 4], '-')
    axes2[0].set_ylabel('VS in V')
    axes2[0].set_title('Sending end voltage')

    axes2[1].plot(y[:, 0], y[:, 6], '-')
    axes2[1].set_ylabel('IR in A')
    axes2[1].set_title('Receiving end current')

    axes2[2].plot(y[:, 0], y[:, 5], '-')
    axes2[2].set_ylabel('VR in V')
    axes2[2].set_xlabel('Time in sec')
    axes2[2].set_title('Load terminal voltage')

    plt.tight_layout()
    plt.show()
