"""
MATLAB to Python conversion of M4.M
Project 4 on power system stabilizer in Chapter 10
To be used with s4.m

This script:
- Determines steady-state values for Simulink simulation
- Computes transfer functions for designing PSS with slip as input
- Provides options for simulation or transfer function analysis
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy import signal
import warnings

# Load machine parameters
try:
    from set1 import *
except ImportError:
    print("Warning: Could not import set1.py")
    # Use default values (from set1.py)
    exec(open('/home/rodo/Maquinas/C10/set1.py').read())

# PSS parameters
Ks = 120
Tw = 1.0
T1 = 0.024
T2 = 0.002
T3 = 0.024
T4 = 0.24
pss_limit = 0.1

# Calculate base quantities
we = 2 * np.pi * Frated
wb = we
wbm = wb * (2 / Poles)
Sbase = Prated / Pfrated
Vbase = Vrated * np.sqrt(2 / 3)
Ibase = np.sqrt(2) * (Sbase / (np.sqrt(3) * Vrated))
Zbase = Vbase / Ibase

# Example operating point (user would normally input these)
re = 0.027  # external resistance
xe = 0.1    # external reactance
Vi = 1.0 + 0j  # infinite bus voltage
Si = 0.8 + 0.6j  # delivered complex power

print("M4 - Power System Stabilizer Design")
print("=" * 60)
print("Operating Condition:")
print(f"  re = {re:.4f} pu, xe = {xe:.4f} pu")
print(f"  Vi = {Vi}")
print(f"  Si = {Si}")

# Steady-state calculations
Ie = np.conj(Si / Vi)
Eqe = Vi + ((rs + re) + 1j * (xq + xe)) * Ie
Vte = Vi + (re + xe * 1j) * Ie
deltat = np.angle(Vte)
delta = np.angle(Eqe)

Eqo = np.abs(Eqe)
I = (np.conj(Eqe) / Eqo) * Ie
Iqo = np.real(I)
Ido = -np.imag(I)
Vio = np.abs(Vi)
Vto = (np.conj(Eqe) / Eqo) * Vte
Vqo = np.real(Vto)
Vdo = -np.imag(Vto)
Sto = Vto * np.conj(I)
Eqpo = Vqo + xpd * Ido + rs * Iqo
Edpo = Vdo - xpq * Iqo + rs * Ido
Efo = Eqo + (xd - xq) * Ido
delio = delta
Pmecho = np.real(Sto)

# Initialize excitation variables
VR = KE * Efo
Vs = Efo * KF / TF
Vref = np.abs(Vto)
Dz = (re + rs) * (re + rs) + (xe + xq) * (xe + xpd)

print("\nSteady-State Values:")
print(f"  Efo = {Efo:.4f} pu")
print(f"  |Vt| = {np.abs(Vto):.4f} pu")
print(f"  Vref = {Vref:.4f} pu")
print(f"  P = {Pmecho:.4f} pu")
print(f"  Q = {np.imag(Sto):.4f} pu")
print(f"  delta = {np.degrees(delta):.2f} degrees")

# Transfer function calculations
Vq_ratio = Vqo / np.abs(Vto)
Vd_ratio = Vdo / np.abs(Vto)
co = np.cos(delta)
si = np.sin(delta)

# Compute nonlinear gains
K1 = (Eqo * Vio / Dz) * (re * si + (xe + xpd) * co) + \
     (Iqo * Vio / Dz) * ((xq - xpd) * (xe + xq) * si - re * (xe - xpd) * co)
K2 = re * Eqo / Dz + Iqo * (1 + (xq - xpd) * (xe + xq) / Dz)
K3 = 1 / (1 + (xd - xpd) * (xe + xq) / Dz)
K4 = (Vio * (xd - xpd) / Dz) * ((xe + xq) * si - re * co)
K5 = (Vio * Vq_ratio * xpd / Dz) * (re * co - (xe + xq) * si) + \
     (Vio * Vd_ratio * xq / Dz) * (re * si + (xe + xpd) * co)
K6 = Vq_ratio * (1 - xpd * (xe + xq) / Dz) + Vd_ratio * xq * re / Dz

print(f"\nTransfer Function Gains:")
print(f"  K1 = {K1:.4f}")
print(f"  K2 = {K2:.4f}")
print(f"  K3 = {K3:.4f}")
print(f"  K4 = {K4:.4f}")
print(f"  K5 = {K5:.4f}")
print(f"  K6 = {K6:.4f}")

# Exciter transfer function Exc(s)
Exc_num = KA * np.array([TF, 1])
Exc_den = np.array([TA * TE * TF,
                    TA * TE + TA * TF + TE * TF,
                    TA + TE + TF + KA * KF,
                    1])

z, p, k = signal.tf2zpk(Exc_num, Exc_den)
print(f"\nExc(s) Transfer Function:")
print(f"  Zeros: {z}")
print(f"  Poles: {p}")
print(f"  Gain: {k}")

# GEP(s) transfer function
G_num = K3 * Exc_num
G_den = np.convolve([K3 * Tpdo, 1], Exc_den)
GEP_num = K2 * G_num

# Pad to equalize lengths
lp = len(G_den)
lq = len(G_num)
if lp > lq:
    G_num = np.concatenate([np.zeros(lp - lq), G_num])
elif lq > lp:
    G_den = np.concatenate([np.zeros(lq - lp), G_den])

GEP_den = G_den + K6 * G_num

zz, pp, kk = signal.tf2zpk(GEP_num, GEP_den)
print(f"\nGEP(s) Transfer Function:")
print(f"  Zeros: {zz}")
print(f"  Poles: {pp}")
print(f"  Gain: {kk}")

# Bode plot of GEP(s)
freq = np.logspace(-1, 3, 500)
w = 2 * np.pi * freq
w_rad, m_GEP, p_GEP = signal.bode((GEP_num, GEP_den), w)

plt.figure(figsize=(10, 8))
plt.subplot(211)
plt.semilogx(freq, m_GEP)
plt.grid(True)
plt.ylabel('Gain (dB)')
plt.xlabel('Freq (Hz)')
plt.title('Gain vs. frequency of GEP(s)')

plt.subplot(212)
plt.semilogx(freq, p_GEP)
plt.grid(True)
plt.ylabel('Phase (deg)')
plt.xlabel('Freq (Hz)')
plt.title('Phase vs. frequency of GEP(s)')
plt.tight_layout()
plt.savefig('/home/rodo/Maquinas/C10/m4_GEP_bode.png', dpi=150)
print("\nGEP(s) Bode plot saved to m4_GEP_bode.png")

print("\nNote: For full PSS design, use m4comp.py with these results.")
print("      Simulink simulation (s4.m) requires manual implementation.")

if __name__ == '__main__':
    # Store results for use with m4comp
    results = {
        'GEP_num': GEP_num,
        'GEP_den': GEP_den,
        'K1': K1, 'K2': K2, 'K3': K3, 'K4': K4, 'K5': K5, 'K6': K6,
        'Efo': Efo,
        'Vref': Vref,
        'Pmecho': Pmecho
    }
