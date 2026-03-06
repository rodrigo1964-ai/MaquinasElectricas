"""
MATLAB to Python conversion of M2.M
Project 2 on multimachine systems in Chapter 10
To be used with s2eig.m and for setting up parameters in s2.m

This script performs:
- Set up parameters and approximate operating conditions of generators
- Use trim function to determine steady state of s2eig.m
- Use linmod to determine linear model about operating point
- Determine system eigenvalues of linear system
- Set up for step changes in torque and fault simulations

Note: Simulink-specific functions require manual implementation.
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy import linalg
import sys

# Setting up machine parameters
tstop = 30  # stop time for simulation
wb = 2 * np.pi * 60
Sys_Sbase = 1000  # System's S base in MVA

n_unit = 2  # number of generators

# Initialize parameter dictionaries
Sbratio = {}
rs = {}
xd = {}
xq = {}
xls = {}
xpd = {}
xpq = {}
Tpdo = {}
Tpqo = {}
H = {}
Domega = {}
KA = {}
TA = {}
VRmax = {}
VRmin = {}
TE = {}
KE = {}
TF = {}
KF = {}
AEx = {}
BEx = {}

# Parameters of set 1 synchronous generator (bus 1)
list_A = [1]
for bus in list_A:
    Sbratio[bus] = 1000 / 920.35
    rs[bus] = 0.0048
    xd[bus] = 1.790
    xq[bus] = 1.660
    xls[bus] = 0.215
    xpd[bus] = 0.355
    xpq[bus] = 0.570
    Tpdo[bus] = 7.9
    Tpqo[bus] = 0.410
    H[bus] = 3.77
    Domega[bus] = 2
    KA[bus] = 50
    TA[bus] = 0.06
    VRmax[bus] = 1
    VRmin[bus] = -1
    TE[bus] = 0.052
    KE[bus] = -0.0465
    TF[bus] = 1.0
    KF[bus] = 0.0832
    AEx[bus] = 0.0012
    BEx[bus] = 1.264

# Parameters of set 2 synchronous generator (bus 2)
list_B = [2]
for bus in list_B:
    Sbratio[bus] = 1000 / 911
    rs[bus] = 0.001
    xd[bus] = 2.040
    xq[bus] = 1.960
    xls[bus] = 0.154
    xpd[bus] = 0.266
    xpq[bus] = 0.262
    Tpdo[bus] = 6.000
    Tpqo[bus] = 0.900
    H[bus] = 2.5
    Domega[bus] = 2
    KA[bus] = 50
    TA[bus] = 0.060
    VRmax[bus] = 1.0
    VRmin[bus] = -1.0
    TE[bus] = 0.440
    KE[bus] = -0.0393
    TF[bus] = 1.0
    KF[bus] = 0.07
    AEx[bus] = 0.0013
    BEx[bus] = 1.156

# Set up approximate operating condition
Vt = {1: 1.0 + 0j, 2: 1.0 + 0j}
St = {1: 0.8 + 0.6j, 2: 0.8 + 0.6j}  # positive for generating

# Voltage regulation type (1 for ac, 0 for dc)
Exc_sw = {1: 1, 2: 1}

# Calculate initial values for each unit
It = {}
Eq = {}
delt = {}
I = {}
Iqo = {}
Ido = {}
Efo = {}
Vto = {}
Vqo = {}
Vdo = {}
Sto = {}
Eqpo = {}
Edpo = {}
Pemo = {}
Qemo = {}
Tmech = {}
delio = {}

for nu in range(1, n_unit + 1):
    It[nu] = np.conj(St[nu] / Vt[nu])
    Eq[nu] = Vt[nu] + (rs[nu] + 1j * xq[nu]) * It[nu]
    delt[nu] = np.angle(Eq[nu])

    I[nu] = It[nu] * (np.cos(delt[nu]) - np.sin(delt[nu]) * 1j)
    Iqo[nu] = np.real(I[nu])
    Ido[nu] = -np.imag(I[nu])
    Efo[nu] = np.abs(Eq[nu]) + (xd[nu] - xq[nu]) * Ido[nu]
    Vto[nu] = Vt[nu] * (np.cos(delt[nu]) - np.sin(delt[nu]) * 1j)
    Vqo[nu] = np.real(Vto[nu])
    Vdo[nu] = -np.imag(Vto[nu])
    Sto[nu] = Vto[nu] * np.conj(I[nu])
    Eqpo[nu] = Vqo[nu] + xpd[nu] * Ido[nu] + rs[nu] * Iqo[nu]
    Edpo[nu] = Vdo[nu] - xpd[nu] * Iqo[nu] + rs[nu] * Ido[nu]
    Pemo[nu] = np.real(Sto[nu])
    Qemo[nu] = np.imag(Sto[nu])
    Tmech[nu] = Pemo[nu]
    delio[nu] = delt[nu]

    if Exc_sw[nu] == 0:  # if dc voltage regulated
        KA[nu] = 0.1
        KE[nu] = 1

# Set up network representation (Y bus)
Y = np.zeros((4, 4), dtype=complex)
Hmod = np.zeros((4, 4), dtype=complex)

y14 = 1 / (0.004 + 1j * 0.1 + (rs[1] + 1j * xpd[1]) * Sbratio[1])
y24 = 1 / (0.004 + 1j * 0.1 + (rs[2] + 1j * xpd[2]) * Sbratio[2])
y34 = 1 / (0.008 + 1j * 0.3)
y40 = 1.2 - 1j * 0.6

Y[0, 0] = y14
Y[0, 3] = -y14
Y[1, 1] = y24
Y[1, 3] = -y24
Y[2, 2] = y34
Y[2, 3] = -y34
Y[3, 0] = -y14
Y[3, 1] = -y24
Y[3, 2] = -y34
Y[3, 3] = y40 + y14 + y24 + y34

# Gyrate Y bus (row 4 and column 4)
gbus = 3  # 0-indexed
ix = [0, 1, 2]
Hmod[gbus, gbus] = 1 / Y[gbus, gbus]
Hmod[ix, gbus] = Y[ix, gbus] / Y[gbus, gbus]
Hmod[gbus, ix] = -Y[gbus, ix] / Y[gbus, gbus]
for i in ix:
    for j in ix:
        Hmod[i, j] = Y[i, j] - (Y[i, gbus] * Y[gbus, j]) / Y[gbus, gbus]

RZ = np.real(Hmod)
IZ = np.imag(Hmod)

print("M2 - Multi-Machine System Analysis")
print("=" * 60)
print(f"Number of generators: {n_unit}")
print(f"System base: {Sys_Sbase} MVA")
print("\nGenerator Operating Points:")
for nu in range(1, n_unit + 1):
    print(f"\nUnit {nu}:")
    print(f"  P = {Pemo[nu]:.4f} pu")
    print(f"  Q = {Qemo[nu]:.4f} pu")
    print(f"  |Vt| = {np.abs(Vt[nu]):.4f} pu")
    print(f"  delta = {np.degrees(delt[nu]):.2f} degrees")

print("\nNote: Simulink-specific functions (trim, linmod) require")
print("      manual implementation for eigenvalue analysis.")

# Set up for simulation (tmech1 cycling)
time_tmech1 = [0, 7.5, 7.5, 15, 15, 22.5, 22.5, 30]
tmech_tmech1 = [Tmech[1], Tmech[1], Tmech[1] + 0.1, Tmech[1] + 0.1,
                Tmech[1] - 0.1, Tmech[1] - 0.1, Tmech[1], Tmech[1]]

print("\nTmech1 cycling sequence prepared for simulation.")

if __name__ == '__main__':
    print("\nNetwork Y-bus (modified):")
    print("RZ (real part):")
    print(RZ)
    print("\nIZ (imaginary part):")
    print(IZ)
