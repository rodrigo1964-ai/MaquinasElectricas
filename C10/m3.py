"""
MATLAB to Python conversion of M3.M
Project 3 on subsynchronous resonance in Chapter 10
Generator with series capacitor compensated case

This script:
(a) loads parameters of generator, network and torsional system
(b) estimates operating condition and uses trim/linmod for analysis
(c) determines system eigenvalues
(d) prepares for simulation
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy import linalg

# Load machine parameters from IEEE First Benchmark Model
Frated = 60
wb = 2 * np.pi * Frated
rs = 0.000
rpf = 0.53 / wb
xplf = 0.062
rpkd = 1.54 / wb
xplkd = 0.0055
xmd = 1.66
xls = 0.13
rpkq2 = 5.3 / wb
xplkq2 = 0.326
rpkq = 3.1 / wb
xplkq = 0.095
xmq = 1.58
xd = xls + xmd
xq = xls + xmq
Domega = 0.0  # damping of mode 0

# Network parameters
xc = {
    1: -0.371,  # pu series capacitance between buses 2 and 3
    2: -50      # pu bus to ground capacitance at bus 1
}
r = {
    1: 0.02,          # total series resistance between buses 1 and 4
}
xl = {
    1: 0.14 + 0.5 + 0.06  # total series reactance between buses 1 and 4
}

# Torsional system parameters
h = np.array([0.092897, 0.155589, 0.85867, 0.884215, 0.868495, 0.0342165])
H = np.diag(h)
k = np.array([19.303, 34.929, 52.038, 70.858, 2.822])
tmechv = np.array([0.3, 0.26, 0.22, 0.22, 0.0, 0.0])
n_gen = 5  # Generator rotor is mass number 5
temmask = np.array([0, 0, 0, 0, 1, 0])
Tmech = 0.9
sigma = np.array([0.0, 0.05, 0.11, 0.028, 0.028, 0.0])

n_mass = len(h)
n_mode = n_mass
nm1 = n_mass - 1

print(f'Torsional Modes of a {n_mass} mass inertia system')
print(f'Generator rotor is mass number {n_gen}')
print(f'Base frequency is {wb:.1f} rad/sec\n')

# Compute net torque to generator
tdisk = Tmech * tmechv
tsum = np.sum(tdisk)
tdisk[n_gen - 1] = -tsum  # Python 0-indexed

# Set up stiffness matrix K (tridiagonal)
K = np.zeros((n_mass, n_mass))
K[0, 0] = k[0]
if n_mass > 2:
    for irow in range(1, nm1):
        K[irow, irow] = k[irow - 1] + k[irow]
K[n_mass - 1, n_mass - 1] = k[nm1 - 1]

# Off-diagonal elements
for irow in range(1, n_mass):
    K[irow, irow - 1] = -k[irow - 1]
    K[irow - 1, irow] = K[irow, irow - 1]

print('Stiffness matrix K:')
print(K)

# Compute H_inv * K
H_invK = np.zeros((n_mass, n_mass))
for irow in range(n_mass):
    H_invK[irow, :] = K[irow, :] / h[irow]

# Compute eigenvalues and eigenvectors
Sys_matrix = (wb / 2) * H_invK
Lambda, Q = linalg.eig(Sys_matrix)

# Sort by eigenvalue magnitude
idx = np.argsort(Lambda.real)
Lambda = Lambda[idx]
Q = Q[:, idx]

omega_m = np.sqrt(Lambda.real)
freq_m = omega_m / (2 * np.pi)

print('\nNatural/modal frequencies:')
print(f'  rad/sec: {omega_m}')
print(f'  Hz: {freq_m}')

# Normalize eigenvectors (option 2: divide by maximum)
option = 2
if option == 1:
    R = np.diag(1.0 / Q[n_gen - 1, :])
elif option == 2:
    R = np.diag(1.0 / np.max(np.abs(Q), axis=0))
elif option == 3:
    R = np.diag(1.0 / np.sqrt(np.sum(Q**2, axis=0)))

Qbar = Q @ R
print('\nScaled mode shape matrix Qbar:')
print(Qbar)

# Compute angle of twist
theta = np.zeros(n_mass)
theta[0] = 0.0
tsum = 0.0
for imass in range(1, n_mass):
    tsum += tdisk[imass - 1]
    theta[imass] = theta[imass - 1] - tsum / k[imass - 1]

# Shift so generator angle is zero
theta = theta - theta[n_gen - 1]

# Compute modal angles
theta_m = linalg.solve(Qbar, theta)
print(f'\nMode angles for applied torque:')
print(theta_m)

# Modal inertias
H_m = Qbar.T @ H @ Qbar
print(f'\nModal inertia matrix diagonal:')
print(np.diag(H_m))

# Modal damping coefficients
D_m = np.zeros(n_mass)
for jmode in range(n_mass):
    D_m[jmode] = (4 / wb) * H_m[jmode, jmode] * sigma[jmode]
print(f'\nModal damping coefficients:')
print(D_m)

# Set up for simulation
xMQ = 1 / (1/xls + 1/xmq + 1/xplkq + 1/xplkq2)
xMD = 1 / (1/xls + 1/xmd + 1/xplf + 1/xplkd)

# Operating condition
Pgen = 0.9
Qgen = Pgen * np.tan(np.arccos(0.9))
Vt = 1.0 + 0j
Vm = np.abs(Vt)
St = Pgen + Qgen * 1j

# Steady-state calculations
It = np.conj(St / Vt)
Eq = Vt + (rs + 1j * xq) * It
delt = np.angle(Eq)

Eqo = np.abs(Eq)
I = It * (np.cos(delt) - np.sin(delt) * 1j)
Iqo = np.real(I)
Ido = -np.imag(I)
Efo = Eqo + (xd - xq) * Ido

print('\nOperating Point:')
print(f'  Pgen = {Pgen:.4f} pu')
print(f'  Qgen = {Qgen:.4f} pu')
print(f'  |Vt| = {Vm:.4f} pu')
print(f'  Efo = {Efo:.4f} pu')
print(f'  delta = {np.degrees(delt):.2f} degrees')

print('\nNote: Simulink simulation (s3.m) requires manual implementation.')

if __name__ == '__main__':
    # Plot mode shapes
    plt.figure(figsize=(10, 12))
    for jmode in range(n_mass):
        plt.subplot(6, 1, jmode + 1)
        plt.plot(Qbar[:, jmode])
        plt.ylabel(f'mode{jmode}')
        plt.grid(True)
    plt.xlabel('Mass number')
    plt.tight_layout()
    plt.savefig('/home/rodo/Maquinas/C10/m3_mode_shapes.png', dpi=150)
    print('\nMode shapes saved to m3_mode_shapes.png')
