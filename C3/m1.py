"""
Python conversion of M1.M
Project 1 on line parameters and circuit models in Chapter 3

Determines the RLC parameters of the line from its physical description
and computes the ABCD matrix and circuit parameters of series RL,
nominal pi and equivalent pi model of the line.
Computes and plots receiving-end real and reactive power circle diagram.
"""
import numpy as np
import matplotlib.pyplot as plt

# Input constants
epso = 8.854e-12  # permittivity of free space in F/m
muo = 4e-7 * np.pi  # permeability of free space in H/m
we = 2 * np.pi * 60  # system frequency in rad/sec

# Input conductor spacings, length, and resistance
D12p = 7.772  # conductor spacing in m
D1p2 = 6.858  # conductor spacing in m
radc = 4.4755e-2 / 2  # envelope radius of conductor in m
GMRc = 1.6276e-2  # GMR of conductor in m
d = 160  # length of line in m

s = (D12p - D1p2) / 2  # conductor spacing of bundle in m
D12 = D12p + s  # conductor spacing in m
D12eq = (D12 * D12 * D12p * D1p2) ** (1/4)
D23eq = D12eq
D13eq = ((D12 + D1p2) * (D12 + D12p) * (D12p + D1p2) ** 2) ** (1/4)
GMD = (D12eq * D23eq * D13eq) ** (1/3)
GMR = np.sqrt(GMRc * s)
GMR1 = np.sqrt(radc * s)

# RLC per m of line
r = 0.02896e-3 / 2  # resistance per meter length of phase bundle
l = (muo / (2 * np.pi)) * np.log(GMD / GMR)  # inductance per meter length
c = 2 * np.pi * epso / np.log(GMD / GMR1)  # capacitance per meter length

print(f'r = {r:.6e} Ω/m')
print(f'l = {l:.6e} H/m')
print(f'c = {c:.6e} F/m')

# Series RL circuit model parameters
R = r * d
L = l * d
Z = R + 1j * we * L
ABCD_RL = np.array([[1, Z], [0, 1]])
print('\nSeries RL ABCD matrix:')
print(ABCD_RL)

# Nominal pi circuit model parameters
Cby2 = c * (d / 2)
Yby2 = 1j * we * Cby2
Y = 1j * we * Cby2 * 2
ABCD_nompi = np.array([[1 + Z * Yby2, Z],
                       [Y * (1 + Z * Y / 4), 1 + Z * Yby2]])
print('\nNominal pi ABCD matrix:')
print(ABCD_nompi)

# Equivalent pi circuit model parameters
gamma = np.sqrt((r + 1j * we * l) * 1j * we * c)
Zc = np.sqrt((r + 1j * we * l) / (1j * we * c))
gammad = gamma * d
ABCD_eqpi = np.array([[np.cosh(gammad), Zc * np.sinh(gammad)],
                      [np.sinh(gammad) / Zc, np.cosh(gammad)]])
print('\nEquivalent pi ABCD matrix:')
print(ABCD_eqpi)

# Receiving-end condition
PR = 120e6 / 3  # per phase receiving-end power in W
VR = 345e3 / np.sqrt(3)  # receiving-end phase voltage in rms V
pfR = 0.9  # pf of load at receiving end
sinphiR = -np.sqrt(1 - pfR ** 2)  # sine of pf angle, neg for lagging
SR = PR * (1 - 1j * sinphiR / pfR)  # per phase complex load power
IR = np.conj(SR / VR)  # receiving-end current

print(f'\nReceiving-end complex power: {SR:.2e}')
print(f'Receiving-end current: {IR:.2f} A')

# Compute sending-end conditions
VIS_RL = ABCD_RL @ np.array([VR, IR])
SS_RL = VIS_RL[0] * np.conj(VIS_RL[1])
pfS_RL = np.cos(np.angle(SS_RL))
VS_RL = abs(VIS_RL[0])
IS_RL = abs(VIS_RL[1])

print(f'\nSeries RL model:')
print(f'  VS = {VS_RL:.2f} V, IS = {IS_RL:.2f} A, pf = {pfS_RL:.4f}')

VIS_nompi = ABCD_nompi @ np.array([VR, IR])
SS_nompi = VIS_nompi[0] * np.conj(VIS_nompi[1])
pfS_nompi = np.cos(np.angle(SS_nompi))
VS_nompi = abs(VIS_nompi[0])
IS_nompi = abs(VIS_nompi[1])

print(f'Nominal pi model:')
print(f'  VS = {VS_nompi:.2f} V, IS = {IS_nompi:.2f} A, pf = {pfS_nompi:.4f}')

VIS_eqpi = ABCD_eqpi @ np.array([VR, IR])
SS_eqpi = VIS_eqpi[0] * np.conj(VIS_eqpi[1])
pfS_eqpi = np.cos(np.angle(SS_eqpi))
VS_eqpi = abs(VIS_eqpi[0])
IS_eqpi = abs(VIS_eqpi[1])

print(f'Equivalent pi model:')
print(f'  VS = {VS_eqpi:.2f} V, IS = {IS_eqpi:.2f} A, pf = {pfS_eqpi:.4f}')

# Locus of PQ at receiving-end with changing angle of VS
# while the magnitude of VS and VR held fixed
VS_mag = np.arange(0.94, 1.07, 0.06) * np.real(VIS_eqpi[0])
del_VS = np.arange(-1, 1.01, 1/180) * np.pi

SR_locus = np.zeros((len(VS_mag), len(del_VS)), dtype=complex)

for inmag, VSm in enumerate(VS_mag):
    for indel, delta in enumerate(del_VS):
        VS = VSm * np.exp(1j * delta)
        IR = (VS - ABCD_eqpi[0, 0] * VR) / ABCD_eqpi[0, 1]
        SR_locus[inmag, indel] = VR * np.conj(IR)

# Plot PQ locus
plt.figure(figsize=(10, 10))
plt.plot(np.real(SR_locus[0, :]), np.imag(SR_locus[0, :]), '-.', label='0.94 pu')
plt.plot(np.real(SR_locus[1, :]), np.imag(SR_locus[1, :]), '-', label='1.00 pu')
plt.plot(np.real(SR_locus[2, :]), np.imag(SR_locus[2, :]), ':', label='1.06 pu')
plt.title('Loci of receiving-end P+jQ')
plt.xlabel('P in W')
plt.ylabel('Q in Var')
plt.axis('square')
plt.axis('equal')
plt.legend()
plt.grid(True)
plt.show()
