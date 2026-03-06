"""
M-file for Project 2 on induction motor starting in Chapter 6
It calculates and the torque-speed and current-speed curves
and plots them (see Fig. 6.27 of Project 2) on starting methods
"""
import numpy as np
import matplotlib.pyplot as plt
from p20hp import *  # Load 20 hp three-phase induction motor parameters

# Per-phase Thevenin's equivalent
vas = Vrated / np.sqrt(3)  # Vrated line-to-line voltage
vth = abs((1j * xm / (rs + 1j * (xls + xm))) * vas)
zth = (1j * xm * (rs + 1j * xls)) / (rs + 1j * (xls + xm))
rth = np.real(zth)
xth = np.imag(zth)

# Compute rotor resistances
# rotor resistance for max torque at s=1
rpr1 = 0.8 * np.sqrt(rth**2 + (xth + xplr)**2)
rprm = 0.4 * np.sqrt(rth**2 + (xth + xplr)**2)

# Set up vector of rotor resistances
rprv = np.array([rpr, rprm, rpr1])

s = np.arange(1, 0.025 - 0.001, -0.025)
N = len(s)
wr = np.zeros(N)
pfin = np.zeros((3, N))
iin = np.zeros((3, N))
te = np.zeros((3, N))
pe = np.zeros((3, N))
eff = np.zeros((3, N))

for n in range(N):
    sn = s[n]
    wr[n] = 2 * we * (1 - sn) / P
    for nrpr in range(3):
        rprn = rprv[nrpr]
        zin = (rs + 1j * xls) + 1j * xm * (rprn / sn + 1j * xplr) / (rprn / sn + 1j * (xm + xplr))
        ias = vas / zin
        Sin = 3 * vas * np.conj(ias)
        pin = np.real(Sin)
        pfin[nrpr, n] = np.cos(-np.angle(ias))
        iin[nrpr, n] = abs(ias)
        te[nrpr, n] = (3 * P / (2 * we)) * (vth**2 * rprn / sn) / ((rth + rprn / sn)**2 + (xth + xplr)**2)
        pe[nrpr, n] = te[nrpr, n] * wr[n]
        eff[nrpr, n] = 100 * pe[nrpr, n] / pin

# Add in synchronous speed values
z = np.zeros(3)
inl = vas / (rs + 1j * (xls + xm))
inlm = abs(inl)
inla = np.cos(-np.angle(inl))
iin = np.column_stack([iin, np.full(3, inlm)])
pfin = np.column_stack([pfin, np.full(3, inla)])
eff = np.column_stack([eff, z])
te = np.column_stack([te, z])
pe = np.column_stack([pe, z])
s = np.append(s, 0)
wr = np.append(wr, 2 * we / P)

# Plot results
plt.figure(figsize=(10, 8))

plt.subplot(2, 1, 1)
plt.plot(wr, te[0, :], '-', label='Normal rotor')
plt.plot(wr, te[1, :], '--', label='Medium resistance')
plt.plot(wr, te[2, :], ':', label='High resistance')
plt.xlabel('Rotor speed in rad/sec')
plt.ylabel('Torque in Nm')
plt.legend()
plt.grid(True)

plt.subplot(2, 1, 2)
plt.plot(wr, iin[0, :], '-', label='Normal rotor')
plt.plot(wr, iin[1, :], '--', label='Medium resistance')
plt.plot(wr, iin[2, :], ':', label='High resistance')
plt.xlabel('Rotor speed in rad/sec')
plt.ylabel('Stator current in Amps')
plt.legend()
plt.grid(True)

plt.tight_layout()
plt.show()
