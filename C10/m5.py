"""
MATLAB to Python conversion of M5.M
Project 5 on self-controlled permanent magnet motor drive
To be used with s5.m

This script:
(1) loads machine parameters of permanent magnet motor
(2) determines steady-state characteristics where torque is linear with current
(3) sets up initial conditions for simulation
(4) plots results

Reference: Bose, B. K., "A High-Performance Inverter-Fed Drive System of
an Interior Permanent Magnet Synchronous Machine," IEEE Trans. on Industry
Applications, Vol. 24, No. 6, Nov/Dec 1988, pp. 996. Copyright 1988 IEEE
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import fminbound
from m5torqi import m5torqi
from m5torqv import m5torqv

# Machine parameters
Frated = 710.48 / (2 * np.pi)  # base speed in elect rad/sec
Poles = 4
Prated = 70 * 746  # 70 hp motor
Vrated = 58.5 * np.sqrt(3)  # rms phase to neutral value
Em = 40.2 * np.sqrt(3)  # wb*lambda'm - magnet's excitation voltage
we = 2 * np.pi * Frated
wb = 2 * np.pi * Frated
wbm = wb * (2 / Poles)
Sb = Prated
Vb = Vrated * np.sqrt(2 / 3)  # Use peak values as base quantities
Ib = np.sqrt(2) * (Sb / (np.sqrt(3) * Vrated))
Zb = Vb / Ib
Tb = Sb / wbm

# QD0 equivalent circuit parameters in engineering units
xls = 0.0189
x0 = xls
xmq = 0.1747
xmd = 0.0785
xq = xls + xmq
xd = xls + xmd
rs = 0.00443
J_rotor = 0.292  # in Nmsec^2
Domega = 1.0  # rotor damping coefficient

# Convert to per unit
print('QD0 circuit parameters in per unit')
H = 0.5 * J_rotor * wbm * wbm / Sb
rs = rs / Zb
xls = xls / Zb
x0 = x0 / Zb
xd = xd / Zb
xq = xq / Zb
xmd = xmd / Zb
xmq = xmq / Zb
Em = Em * np.sqrt(2 / 3) / Vb  # convert line-to-line to per unit
Ipm = Em / xmd  # equivalent magnet field excitation current

print(f'H = {H:.6f}')
print(f'rs = {rs:.6f}')
print(f'xd = {xd:.6f}')
print(f'xq = {xq:.6f}')
print(f'Em = {Em:.6f}')
print(f'Ipm = {Ipm:.6f}')

# Compute settings for simulation
xMQ = 1 / (1/xls + 1/xmq)
xMD = 1 / (1/xls + 1/xmd)

print(f'xMQ = {xMQ:.6f}')
print(f'xMD = {xMD:.6f}')

# Compute steady-state characteristics
Temo = 1.0
Tem = np.arange(Temo, -Temo - 0.05, -0.05)
N = len(Tem)

gamma = np.zeros(N)
Iq = np.zeros(N)
Id = np.zeros(N)
Vd = np.zeros(N)
Vq = np.zeros(N)
Vs = np.zeros(N)
delta = np.zeros(N)
phi = np.zeros(N)
Iqe = np.zeros(N)
Ide = np.zeros(N)
Q = np.zeros(N)
P = np.zeros(N)

print('\nComputing steady-state torque-speed characteristics...')

for n in range(N):
    Is = Tem[n] / Temo  # Is proportional to output torque

    if abs(Is) < 1e-10:
        sing = 0
    else:
        # Find optimal angle for given torque and current
        sing = fminbound(lambda x: abs(m5torqi(x, Tem[n], Em, Is, xd, xq)),
                        -0.8, 0.8)

    cosg = np.sqrt(1 - sing**2)
    gamma[n] = np.arctan2(sing, cosg)
    Iq[n] = Is * cosg
    Id[n] = Is * sing
    Vd[n] = -Iq[n] * xq
    Vq[n] = Em + Id[n] * xd
    Vs[n] = np.sqrt(Vd[n]**2 + Vq[n]**2)
    delta[n] = Vd[n] / Vs[n]  # negative for motoring
    phi[n] = delta[n] - gamma[n]
    Iqe[n] = Is * np.cos(phi[n])
    Ide[n] = Is * np.sin(phi[n])
    Q[n] = Vq[n] * Id[n] - Vd[n] * Iq[n]
    P[n] = Vq[n] * Iq[n] + Vd[n] * Id[n]

    # Plot torque-angle curve for this operating point
    if Tem[n] <= 0:
        mdel = np.arange(0, np.pi + 0.1, 0.1)
    else:
        mdel = np.arange(0, -np.pi - 0.1, -0.1)

    Ndel = len(mdel)
    texcm = Vs[n] * Em / xd
    trelm = Vs[n]**2 * (1/xq - 1/xd) / 2
    tres = -texcm * np.sin(mdel) - trelm * np.sin(2 * mdel)

    if n == 0:  # First plot
        plt.figure(1, figsize=(12, 10))
        plt.subplot(2, 2, 1)

    if n % 5 == 0:  # Plot every 5th curve
        plt.plot(mdel, tres, '-', linewidth=0.5)

# Finish first subplot
plt.subplot(2, 2, 1)
plt.ylabel('Torque (pu)')
plt.xlabel('Delta (radians)')
plt.title('Steady-state torque vs. angle curves')
plt.grid(True)

# Curve fitting for non-monotonic relationships
IdeIqe = np.polyfit(Iqe, Ide, 2)
VsTem = np.polyfit(Tem, Vs, 2)

# Plot other steady-state characteristics
plt.subplot(2, 2, 2)
plt.plot(Tem, Vs, '-')
plt.xlabel('Tem (pu)')
plt.ylabel('Vs (pu)')
plt.title('Stator voltage vs. torque')
plt.grid(True)

plt.subplot(2, 2, 3)
plt.plot(Iqe, Ide, '-')
plt.xlabel('Iqe (pu)')
plt.ylabel('Ide (pu)')
plt.title('Ide vs. Iqe')
plt.grid(True)

plt.subplot(2, 2, 4)
plt.plot(Tem, Iqe, '-', label='Iqe')
plt.plot(Tem, Ide, '--', label='Ide')
plt.xlabel('Tem (pu)')
plt.ylabel('Iqe and Ide (pu)')
plt.title('Iqe and Ide vs. torque')
plt.legend()
plt.grid(True)

plt.tight_layout()
plt.savefig('/home/rodo/Maquinas/C10/m5_steady_state_1.png', dpi=150)

# Second figure
plt.figure(2, figsize=(12, 10))

plt.subplot(2, 2, 1)
plt.plot(Tem, Vq, '-', label='Vq')
plt.plot(Tem, Vd, '--', label='Vd')
plt.xlabel('Tem (pu)')
plt.ylabel('Vq and Vd (pu)')
plt.title('Vq and Vd vs. torque')
plt.legend()
plt.grid(True)

plt.subplot(2, 2, 2)
plt.plot(Tem, Iq, '-', label='Iq')
plt.plot(Tem, Id, '--', label='Id')
plt.xlabel('Tem (pu)')
plt.ylabel('Iq and Id (pu)')
plt.title('Iq and Id vs. torque')
plt.legend()
plt.grid(True)

plt.subplot(2, 2, 3)
plt.plot(Tem, gamma, '-', label='gamma')
plt.plot(Tem, phi, ':', label='phi')
plt.plot(Tem, delta, '--', label='delta')
plt.xlabel('Tem (pu)')
plt.ylabel('Angles (rad)')
plt.title('Gamma, phi, and delta vs torque')
plt.legend()
plt.grid(True)

plt.subplot(2, 2, 4)
plt.plot(P, Q, '-')
plt.xlabel('Pmotor (pu)')
plt.ylabel('Qmotor (pu)')
plt.title('Reactive vs. active power')
plt.grid(True)

plt.tight_layout()
plt.savefig('/home/rodo/Maquinas/C10/m5_steady_state_2.png', dpi=150)

print('\nSteady-state plots saved:')
print('  m5_steady_state_1.png')
print('  m5_steady_state_2.png')

# Set up simulation initial conditions
print('\n' + '='*60)
print('Simulation Setup')
print('='*60)

# Example: Initialize with steady-state condition
Temo_init = 1.0
Vso_init = 1.0

# Find operating point
sindo = fminbound(lambda x: abs(m5torqv(x, Temo_init, Em, Vso_init, xd, xq)),
                 -0.2, -2)
Vdo = Vso_init * sindo
cosdo = np.sqrt(1 - sindo**2)
delo = np.arctan2(sindo, cosdo)
Vqo = Vso_init * cosdo
Iqo = -Vdo / xq
Ido = (Vqo - Em) / xd
Iso = np.sqrt(Iqo**2 + Ido**2)
cosgo = Iqo / Iso
singo = Ido / Iso
gammao = np.arctan2(singo, cosgo)

Psiado = xmd * (Ido + Ipm)
Psiaqo = xmq * Iqo
Psiqo = xls * Iqo + Psiaqo
Psido = xls * Ido + Psiado
wrbywbo = 1.0  # when wr = wb
tmecho = (xd - xq) * Ido * Iqo + xmd * Ipm * Iqo

print(f'\nInitial Operating Point:')
print(f'  Temo = {Temo_init:.4f} pu')
print(f'  Vso = {Vso_init:.4f} pu')
print(f'  Iso = {Iso:.4f} pu')
print(f'  gammao = {np.degrees(gammao):.2f} degrees')
print(f'  delo = {np.degrees(delo):.2f} degrees')

# Simulation parameters
tstop = 3
tref_time = [0, 1, 1, 1.2, 1.2, 2.2, 2.2, tstop]
tref_value = [1, 1, 0, 0, -1, -1, 1, 1]
tmech_time = [0, tstop]
tmech_value = [0, 0]

print(f'\nSimulation time: {tstop} sec')
print(f'Inertia constant H = {H:.6f}')
print('\nNote: Simulink simulation (s5.m) requires manual implementation.')
print('      Torque command sequence prepared.')

if __name__ == '__main__':
    plt.show()

    # Export initial conditions
    initial_conditions = {
        'H': H,
        'rs': rs,
        'xd': xd,
        'xq': xq,
        'xmd': xmd,
        'xmq': xmq,
        'Em': Em,
        'Ipm': Ipm,
        'Psiado': Psiado,
        'Psiaqo': Psiaqo,
        'Psiqo': Psiqo,
        'Psido': Psido,
        'wrbywbo': wrbywbo,
        'IdeIqe_poly': IdeIqe,
        'VsTem_poly': VsTem
    }
