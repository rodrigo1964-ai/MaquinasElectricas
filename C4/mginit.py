"""
Python conversion of MGINIT.M
Obtains instantaneous flux linkage vs current curve from rms open-circuit curve
"""
import numpy as np
import matplotlib.pyplot as plt

we = 377  # excitation frequency

# Enter Vrms and Irms of open-circuit curve
V = np.array([0.00, 7.40, 20.50, 37.30, 47.31, 57.12, 68.85, 72.80, 81.19, 87.82,
              95.46, 100.7, 107.04, 112.37, 116.04, 119.75, 121.92, 125.61, 127.92,
              130.25, 132.53, 134.85, 136.1, 137.5])
I = np.array([0, 0.0112, 0.0310, 0.0585, 0.0740, 0.0895, 0.1084, 0.1153, 0.1308,
              0.1437, 0.1583, 0.1686, 0.1841, 0.2004, 0.2142, 0.2331, 0.2477, 0.2753,
              0.2933, 0.3131, 0.3381, 0.3639, 0.3828, 0.4000])

psi = np.sqrt(2) * V  # peak psi array
npts = len(V)
K = np.zeros(npts)
i = np.zeros(npts)
theta = np.zeros(npts)

K[0] = I[1] * np.sqrt(2) / psi[1]
i[0] = 0.
theta[0] = 0

for k in range(1, npts):
    t = np.zeros(k + 1)
    s = np.zeros(k + 1)
    g = np.zeros(k + 1)
    d = np.zeros(k + 1)
    B = np.zeros(k + 1)
    A = np.zeros(k + 1)

    for j in range(1, k + 1):
        theta[j] = np.arcsin(psi[j] / psi[k])
        theta[j-1] = np.arcsin(psi[j-1] / psi[k])
        t[j] = theta[j] - theta[j-1]
        s[j] = (np.sin(2 * theta[j]) - np.sin(2 * theta[j-1])) / 2
        g[j] = np.cos(theta[j]) - np.cos(theta[j-1])
        d[j] = t[j] * i[j-1] ** 2
        B[j] = -2 * i[j-1] * (psi[k] * g[j] + psi[j-1] * t[j])
        A[j] = (psi[k] ** 2) * (t[j] - s[j]) / 2 + 2 * psi[k] * psi[j-1] * g[j] + psi[j-1] ** 2 * t[j]

    C = d[k] - np.pi * I[k] ** 2 / 2
    for j in range(k):
        C = C + K[j] ** 2 * A[j] + K[j] * B[j] + d[j]

    K[k] = (-B[k] + np.sqrt(B[k] ** 2 - 4 * A[k] * C)) / (2 * A[k])
    i[k] = 0
    for j in range(1, k + 1):
        i[k] = i[k] + K[j] * (psi[j] - psi[j-1])

# Set up the full saturation curve
Vud = np.flipud(V)
Vud = Vud[:-1]  # Remove duplicate at origin
Vfull = np.sqrt(2) * np.concatenate((-Vud, V))

Iud = np.flipud(I)
Iud = Iud[:-1]
Ifull = np.sqrt(2) * np.concatenate((-Iud, I))

psiud = np.flipud(psi)
psiud = psiud[:-1]
psifull = np.concatenate((-psiud, psi))

iud = np.flipud(i)
iud = iud[:-1]
ifull = np.concatenate((-iud, i))

# Set up variable amplitude sinusoidal voltage source
Vmaxrms = V[-2]  # set maximum rms of run below max value
tstop = 3.5  # run period same as period of amplitude variation

print('Ready for simulation')
print(f'Vmaxrms = {Vmaxrms:.2f} V')
print(f'tstop = {tstop} sec')

# Export variables for use in other modules
__all__ = ['V', 'I', 'psi', 'i', 'Vfull', 'Ifull', 'psifull', 'ifull', 'Vmaxrms', 'tstop']
