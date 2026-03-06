"""
MATLAB to Python conversion of M1.M
Project 1 on transient model in Chapter 10.
To be used in conjunction with Simulink file s1eig.m

This script performs:
(a) loads parameters and rating of the synchronous machine
(b) set up Pgen and Qgen lists for tasks (i) through (iv)
    (i) uses Simulink trim function to determine steady-state
    (ii) uses MATLAB linmod to determine A, B, C, and D
    (iii) uses MATLAB ss2tf to determine speed-torque transfer function
    (iv) uses MATLAB tf2zp to determine poles and zeros
(c) generates root locus plots

Note: Simulink-specific functions (trim, linmod) need manual implementation
or scipy equivalents for full functionality.
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy import signal
import sys

# Import machine parameters
try:
    from set1 import *
except ImportError:
    print("Warning: Could not import set1.py, using default values")
    exec(open('set1.py').read())

# Calculate base quantities
we = 2 * np.pi * Frated
wbase = 2 * np.pi * Frated
wbasem = wbase * (2 / Poles)
Sbase = Prated / Pfrated
Vbase = Vrated * np.sqrt(2 / 3)  # Use peak values as base quantities
Ibase = np.sqrt(2) * (Sbase / (np.sqrt(3) * Vrated))
Zbase = Vbase / Ibase
Tbase = Sbase / wbasem

# Calculate dq0 equivalent circuit parameters
try:
    if xls == 0:
        xls = x0  # assume leakage reactance = zero_sequence
except NameError:
    pass  # xls already defined

xmq = xq - xls
xmd = xd - xls

xplf = xmd * (xpd - xls) / (xmd - (xpd - xls))
xplkd = xmd * xplf * (xppd - xls) / (xplf * xmd - (xppd - xls) * (xmd + xplf))
xplkq = xmq * (xppq - xls) / (xmq - (xppq - xls))

rpf = (xplf + xmd) / (wbase * Tpdo)
rpkd = (xplkd + xpd - xls) / (wbase * Tppdo)
rpkq = (xplkq + xmq) / (wbase * Tppqo)

# Convert to per unit dqo circuit parameters (if needed)
if Perunit == 0:  # parameters given in Engineering units
    print('Dq0 circuit parameters in per unit')
    H = 0.5 * J_rotor * wbasem * wbasem / Sbase
    rs = rs / Zbase
    xls = xls / Zbase
    xppd = xppd / Zbase
    xppq = xppq / Zbase
    xpd = xpd / Zbase
    x2 = x2 / Zbase
    x0 = x0 / Zbase
    xd = xd / Zbase
    xq = xq / Zbase
    xmd = xmd / Zbase
    xmq = xmq / Zbase
    rpf = rpf / Zbase
    rpkd = rpkd / Zbase
    rpkq = rpkq / Zbase
    xplf = xplf / Zbase
    xplkd = xplkd / Zbase
    xplkq = xplkq / Zbase

# Compute settings for variables in simulation
wb = wbase
xMQ = 1 / (1/xls + 1/xmq + 1/xplkq)
xMD = 1 / (1/xls + 1/xmd + 1/xplf + 1/xplkd)

# Specify desired operating condition lists
P = np.arange(0, 0.8 + 0.8, 0.8)  # real power from generator
Q = np.array([0, 0.6])  # reactive power (P is negative for motoring)
Vi = 1.0 + 0j  # infinite bus voltage, also the reference phasor

# Approximate complex power delivered to infinite bus
Si = P[0] + Q[0] * 1j
re = 0.0  # external RL line's resistance
xe = 0.0  # external RL line's reactance

# Use steady-state phasor equations
It = np.conj(Si / Vi)
Eq = Vi + ((rs + re) + 1j * (xq + xe)) * It
delt = np.angle(Eq)  # angle Eq leads Vi

# Compute q-d steady-state variables
Eqo = np.abs(Eq)
I = It * (np.cos(delt) - np.sin(delt) * 1j)
Iqo = np.real(I)
Ido = -np.imag(I)
Efo = Eqo + (xd - xq) * Ido
Ifo = Efo / xmd

Psiado = xmd * (-Ido + Ifo)
Psiaqo = xmq * (-Iqo)

Psiqo = xls * (-Iqo) + Psiaqo
Psido = xls * (-Ido) + Psiado
Psifo = xplf * Ifo + Psiado
Psikqo = Psiaqo
Psikdo = Psiado

Vt = Vi + It * (re + 1j * xe)
Vto = (np.conj(Eq) / Eqo) * Vt
Vqo = np.real(Vto)
Vdo = -np.imag(Vto)
Sto = Vt * np.conj(I)
Eqpo = Vqo + xpd * Ido + rs * Iqo
Edpo = Vdo - xpq * Iqo + rs * Ido

delio = delt
Dz = (rs + re) * (rs + re) + (xq + xe) * (xpd + xe)
Pemo = np.real(Sto)
Qemo = np.imag(Sto)
Tmech = Pemo

print("M1 - Synchronous Machine Transient Model Analysis")
print("=" * 60)
print(f"Operating Point:")
print(f"  P = {Pemo:.4f} pu")
print(f"  Q = {Qemo:.4f} pu")
print(f"  |Vt| = {np.abs(Vt):.4f} pu")
print(f"  delta = {np.degrees(delt):.2f} degrees")
print(f"  Efo = {Efo:.4f} pu")
print("\nNote: Simulink-specific functions (trim, linmod) require")
print("      manual implementation or equivalent scipy routines.")
print("      This conversion provides the steady-state calculations.")

# Store initial values for simulation
initial_conditions = {
    'Eqpo': Eqpo,
    'Edpo': Edpo,
    'delio': delio,
    'Efo': Efo,
    'Tmech': Tmech,
    'Vqo': Vqo,
    'Vdo': Vdo,
    'Iqo': Iqo,
    'Ido': Ido
}

if __name__ == '__main__':
    print("\nInitial Conditions for Simulation:")
    print("=" * 60)
    for key, value in initial_conditions.items():
        print(f"  {key} = {value:.6f}")
