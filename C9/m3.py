"""
MATLAB script file m3.m for Project 3 on field-oriented
motor drive in Chapter 9
m3.m sets up the machine parameters, simulated disturbances,
and also plots the results.
Changes in machine parameters and simulated disturbances
can be made by either editing this file and rerunning it
or entering the changes directly in the Python environment
after running this file to initialize the workspace.
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

# set up vector of rotor resistances
rprv = [rpr]
Nrr = len(rprv)

s = np.arange(1, 0.02 - 0.01, -0.01)
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

# determine the rotor flux at no-load
eprime = vas - (rs + 1j * xsprime) * inl  # voltage behind stator transient reactance
lambdadr = np.real(eprime) * (xr / xm_freq) / we

# set up speed and flux vectors in lookup table of simulation
speed = np.arange(-2, 2 + 0.1, 0.1)
mask = np.abs(speed) > 1.1
notmask = ~mask
i = np.where(speed == 0)[0]  # find index of zero speed element
if len(i) > 0:
    speed[i[0]] = np.finfo(float).tiny  # replace with smallest usable positive number
invspeed = np.abs(1.0 / speed)  # before dividing to avoid divide by zero

# scale flux and speed axis
lambdadre = lambdadr * (invspeed * mask + notmask)
speed = wbm * speed

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

# setting all initial conditions in SIMULINK simulation to zero
Psiqso = 0
Psidso = 0
Psipqro = 0
Psipdro = 0
wrbywbo = 0

tstop = 2.0  # run duration in seconds

# set up speed reference signal for load cycling
time_wref = [0, 0.5, tstop]
speed_wref = [0, wbm, wbm]

# set up Tmech signal for load cycling
time_tmech = [0, 0.75, 0.75, 1.0, 1.0, 1.25, 1.25, 1.5, 1.5, 2]
tmech_tmech = [0, 0, -Trated, -Trated, -Trated/2, -Trated/2, -Trated, -Trated, 0, 0]

print('Simulation set up to start from standstill and')
print('load cycling at fixed frequency.')
print('Run simulation then return for plots')
print('Note: Simulink model s3 needs to be implemented separately')

# For second study case
# set up speed reference signal for speed cycling
time_wref_2 = [0, 0.25, 0.5, 1.0, 1.25, 1.5]
speed_wref_2 = [0, wbm/2, wbm/2, -wbm/2, -wbm/2, 0]

# set up Tmech signal
time_tmech_2 = [0, tstop]
tmech_tmech_2 = [0, 0]

print('\nSimulation also configured for speed cycling at no_load')
print('Simulation parameters defined.')

plt.show()
