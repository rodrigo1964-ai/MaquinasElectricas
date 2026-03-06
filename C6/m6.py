"""
M file for Project 6 on single-phase induction motor in Chapter 6.
It sets the machine parameters and also plots the simulated results
when used in conjunction with simulation.
"""
import numpy as np
import matplotlib.pyplot as plt

# Import machine parameters
# User will need to specify which parameter file to use
print('Enter filename of machine parameter file (without .py extension)')
print('Example: psph')

def load_parameters(param_file='psph'):
    """Load machine parameters from specified file"""
    if param_file == 'psph':
        from psph import *
        return locals()
    else:
        exec(f"from {param_file} import *")
        return locals()

# For direct use, load psph by default
from psph import *

# Calculation of torque speed curve
Vqs = Vrated + 1j * 0  # rms phasor voltage of main wdg
Vpds = Nq2Nd * (Vrated + 1j * 0)  # rms aux wdg voltage referred to main wdg
T_mat = (1 / np.sqrt(2)) * np.array([[1, -1j], [1, 1j]])  # transformation
V12 = T_mat @ np.array([Vqs, Vpds])  # transforming qsds to sequence

print('Select with or without capacitor option')
print('1: No capacitor (Split-phase machine)')
print('2: With start capacitor only (Capacitor-start machine)')
print('3: With start and run capacitor (Capacitor-run machine)')

# Default option (can be changed)
opt_cap = 2  # Capacitor-start machine

if opt_cap == 1:  # Split-phase machine, no capacitor
    print('Split-phase machine')
    zpcstart = 0 + 1j * np.finfo(float).eps
    zpcrun = 0 + 1j * np.finfo(float).eps
    zC = zpcstart
    Capstart = 0
    Caprun = 0
    wrswbywb = we
elif opt_cap == 2:  # Capacitor-start machine
    print('Capacitor-start machine')
    zpcstart = (Nq2Nd**2) * zcstart
    zpcrun = 0 + 1j * np.finfo(float).eps
    zC = zpcstart
    Capstart = 1
    Caprun = 0
    wrswbywb = 0.75
elif opt_cap == 3:  # Capacitor-run machine
    print('Capacitor-run machine')
    zpcstart = (Nq2Nd**2) * zcstart
    zpcrun = (Nq2Nd**2) * zcrun
    zC = zpcrun
    Capstart = 0
    Caprun = 1
    wrswbywb = 0.75

Rcrun = np.real(zpcrun)
Xcrun = np.imag(zpcrun)
Crun = -1 / (wb * Xcrun)
Rcstart = np.real(zpcstart)
Xcstart = np.imag(zpcstart)
Cstart = -1 / (wb * Xcstart)

# Network parameters of positive and negative sequence circuit
zqs = rqs + 1j * xlqs
zcross = 0.5 * (rpds + np.real(zC) - rqs) + 1j * 0.5 * (xplds + np.imag(zC) - xlqs)

# Set up vector of slip values
s = np.arange(1, -0.02, -0.02)
N = len(s)
wr = np.zeros(N)
angIq = np.zeros(N)
angId = np.zeros(N)
magIq = np.zeros(N)
magId = np.zeros(N)
Tavg = np.zeros(N)
Pavg = np.zeros(N)
eff = np.zeros(N)

for n in range(N):
    s1 = s[n]  # positive sequence slip
    s2 = 2 - s[n]  # negative sequence slip
    wr[n] = 2 * we * (1 - s1) / P  # rotor speed in mechanical rad/sec

    if abs(s1) < np.finfo(float).eps:
        s1 = np.finfo(float).eps
    zp1r = rpr / s1 + 1j * xplr
    z1s = 1j * xmq * zp1r / (zp1r + 1j * xmq)

    if abs(s2) < np.finfo(float).eps:
        s2 = np.finfo(float).eps
    zp2r = rpr / s2 + 1j * xplr
    z2s = 1j * xmq * zp2r / (zp2r + 1j * xmq)

    z11 = zqs + z1s + zcross
    z22 = zqs + z2s + zcross
    zmat = np.array([[z11, -zcross], [-zcross, z22]])
    I12 = np.linalg.solve(zmat, V12)
    I1s = I12[0]
    I2s = I12[1]
    Iqd = np.linalg.solve(T_mat, I12)
    Sin = np.array([Vqs, Vpds]) @ np.conj(Iqd)
    Pin = np.real(Sin)

    angIq[n] = np.angle(Iqd[0]) * 180 / np.pi
    angId[n] = np.angle(Iqd[1]) * 180 / np.pi
    magIq[n] = abs(Iqd[0])
    magId[n] = abs(Iqd[1])

    Ip1r = -1j * xmq * I1s / (zp1r + 1j * xmq)
    Ip2r = -1j * xmq * I2s / (zp2r + 1j * xmq)
    Tavg[n] = (P / (2 * we)) * (abs(Ip1r)**2 * rpr / s1 - abs(Ip2r)**2 * rpr / s2)
    Pavg[n] = Tavg[n] * wr[n]

    if abs(Pin) < np.finfo(float).eps:
        Pin = np.finfo(float).eps
    eff[n] = 100 * Pavg[n] / Pin

# Plot steady-state characteristics
fig = plt.figure(figsize=(12, 10))

plt.subplot(3, 2, 1)
plt.plot(wr, Tavg, '-')
plt.xlabel('Rotor speed in rad/sec')
plt.ylabel('Torque in Nm')
plt.grid(True)

plt.subplot(3, 2, 2)
plt.plot(wr, Pavg, '-')
plt.xlabel('Rotor speed in rad/sec')
plt.ylabel('Developed power in Watts')
plt.grid(True)

plt.subplot(3, 2, 3)
plt.plot(wr, magIq, '-')
plt.xlabel('Rotor speed in rad/sec')
plt.ylabel('|Iqs| in A')
plt.grid(True)

plt.subplot(3, 2, 4)
plt.plot(wr, magId, '-')
plt.xlabel('Rotor speed in rad/sec')
plt.ylabel('|Ipds| in A')
plt.grid(True)

plt.subplot(3, 2, 5)
plt.plot(wr, eff, '-')
plt.xlabel('Rotor speed in rad/sec')
plt.ylabel('Efficiency in percent')
plt.grid(True)

plt.subplot(3, 2, 6)
plt.plot(wr, angIq, '-', label='Iqs angle')
plt.plot(wr, angId, '-.', label='Ipds angle')
plt.xlabel('Rotor speed in rad/sec')
plt.ylabel('Iqs and Ipds angle in degree')
plt.legend()
plt.grid(True)

plt.tight_layout()

print('Displaying steady-state characteristics')
print(f'Referred capacitor impedance is {np.real(zC):.4g} + {np.imag(zC):.4g}j Ohms')

plt.show()

# Set initial conditions for simulation
Psiqso = 0
Psipdso = 0
Psipqro = 0
Psipdro = 0
wrbywbo = 0  # initial pu rotor speed

print("Ready for time-domain simulation")
print("Initial conditions set")
