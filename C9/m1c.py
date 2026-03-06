"""
M file for Project 1 on induction motor drive
with closed loop speed control in Chapter 9
It sets the machine parameters and also plots the simulated
results when used in conjunction with s1c.m
"""
import numpy as np
import matplotlib.pyplot as plt
from p20hp import *

# Clear previous variables (implicit in Python when reimporting)

# Parameters of 20 hp machine already loaded from p20hp

# Calculation of torque speed curves
vas = Vrated / np.sqrt(3)  # specify rms phasor voltage
we = wb  # specify excitation frequency
xls_freq = (we / wb) * xls  # reactances at excitation frequency
xplr_freq = (we / wb) * xplr  # reactances at excitation frequency
xm_freq = (we / wb) * xm  # reactances at excitation frequency

xM_calc = 1 / (1/xm_freq + 1/xls_freq + 1/xplr_freq)
xs = xls_freq + xm_freq  # stator self reactance
xr = xplr_freq + xm_freq  # rotor self reactance
xsprime = xs - xm_freq * xm_freq / xr  # stator transient reactance

# Thevenin's equivalent
vth = abs((1j * xm_freq / (rs + 1j * (xls_freq + xm_freq))) * vas)
zth = (1j * xm_freq * (rs + 1j * xls_freq) / (rs + 1j * (xls_freq + xm_freq)))
rth = np.real(zth)
xth = np.imag(zth)

# Compute rotor resistances
# rotor resistance for max torque at s=1
rpr1 = np.sqrt(rth**2 + (xth + xplr_freq)**2)
# determine smaxt for fixed voltage supply case
smaxt = rpr / rpr1

# set up vector of rotor resistances
rprv = [rpr]
Nrr = len(rprv)

s = np.arange(1, 0.02 - 0.02, -0.02)
N = len(s)

# Initialize arrays
wr = np.zeros(N)
pfin = np.zeros((Nrr, N))
iin = np.zeros((Nrr, N))
te = np.zeros((Nrr, N))
pe = np.zeros((Nrr, N))
eff = np.zeros((Nrr, N))

for n in range(N):
    sn = s[n]
    wr[n] = 2 * we * (1 - sn) / P
    for nrr in range(Nrr):
        rrn = rprv[nrr]
        zin = (rs + 1j * xls_freq) + 1j * xm_freq * (rrn / sn + 1j * xplr_freq) / (rrn / sn + 1j * (xm_freq + xplr_freq))
        ias = vas / zin
        Sin = 3 * vas * np.conj(ias)
        pin = np.real(Sin)
        pfin[nrr, n] = np.cos(-np.angle(ias))
        iin[nrr, n] = abs(ias)
        te[nrr, n] = (3 * P / (2 * we)) * (vth**2 * rrn / sn) / ((rth + rrn / sn)**2 + (xth + xplr_freq)**2)
        pe[nrr, n] = te[nrr, n] * wr[n]
        eff[nrr, n] = 100 * pe[nrr, n] / pin

# add in synchronous speed values
z = np.array([0])
inl = vas / (rs + 1j * (xls_freq + xm_freq))
inlm = abs(inl)
inla = np.cos(-np.angle(inl))
iin = np.column_stack([iin, [[inlm]]])
pfin = np.column_stack([pfin, [[inla]]])
eff = np.column_stack([eff, z])
te = np.column_stack([te, z])
pe = np.column_stack([pe, z])
s = np.append(s, 0)
wr = np.append(wr, 2 * we / P)

# Plot operating characteristics
fig1 = plt.figure(figsize=(10, 8))
plt.subplot(2, 2, 1)
plt.plot(wr, te[0, :], '-')
plt.xlabel('Rotor speed in rad/sec')
plt.ylabel('Torque in Nm')
plt.grid(True)

plt.subplot(2, 2, 2)
plt.plot(wr, pe[0, :], '-')
plt.xlabel('Rotor speed in rad/sec')
plt.ylabel('Developed power in Watts')
plt.grid(True)

plt.subplot(2, 2, 3)
plt.plot(wr, iin[0, :], '-')
plt.xlabel('Rotor speed in rad/sec')
plt.ylabel('Stator current in Amps')
plt.grid(True)

plt.subplot(2, 2, 4)
plt.plot(wr, eff[0, :], '-')
plt.xlabel('Rotor speed in rad/sec')
plt.ylabel('Efficiency in percent')
plt.grid(True)

plt.tight_layout()
print('Displaying Operating Characteristics in Fig. 1')

# determine the volts per hertz table for the machine
w = np.arange(-400, 400 + 4, 4)  # for lookup table, w has to be monotonically increasing
emb = 1j * iasb * xm
f = w / (2 * np.pi)
N = len(w)
vrms = np.zeros(N)

for n in range(N):
    we_temp = w[n]
    em = abs(we_temp) * emb / wb
    zs = rs + 1j * (abs(we_temp) / wb) * xls
    vrms[n] = abs(em + iasb * zs)

vrms_vf = vrms
we_vf = w

# Plot volts/hertz curve
plt.figure(figsize=(10, 6))
plt.plot(f, vrms, '-')
plt.ylabel('Rms stator phase voltage in V')
plt.xlabel('Excitation frequency in Hz.')
plt.grid(True)
print('Displaying Volts/Hertz curve')

# Simulation setup
print('Set for simulation to start from standstill and')
print('load cycling at fixed frequency,')
print('Note: Simulink model s1c needs to be run separately')

# setting all initial conditions in SIMULINK simulation to zero
Psiqso = 0
Psidso = 0
Psipqro = 0
Psipdro = 0
wrbywbo = 0

# set up speed reference signal for load cycling
time_wref = [0, 0.5, 4]
speed_wref = [0, 1, 1]  # speed in per unit

# set up Tmech signal for load cycling
time_tmech = [0, 0.75, 0.75, 1.0, 1.0, 1.25, 1.25, 1.5, 1.5, 2]
tmech_tmech = [0, 0, -Trated, -Trated, -Trated/2, -Trated/2, -Trated, -Trated, 0, 0]
tstop = 2

print('\nSimulation parameters defined. To run simulation:')
print('- Use a suitable ODE solver (e.g., scipy.integrate.solve_ivp)')
print('- Implement the induction motor model equations')
print('- The Simulink model s1c.M contains the system equations')

plt.show()
