"""
M-file m5.py is for Project 5 on series dc machine hoist in Chapter 8

m5.py loads the following dc machine parameters
and plots results of simulation
"""

import numpy as np
import matplotlib.pyplot as plt

# Machine parameters
Prated = 1500
Vrated = 125
Iarated = 13.2
wmrated = 1425 * (2 * np.pi) / 60
Trated = Prated / wmrated
Ra = 0.24
Rse = 0.2
Laq = 0.018
Lse = 0.044
J = 0.5  # rotor inertia in kgm2

# Enter magnetization curve data
wmo = 1200 * (2 * np.pi) / 60  # speed at which mag. curve data was taken

# Load voltage values of mag. curve
SEVP5 = np.array([-160, -155, -150, -145, -140, -135, -130, -125, -120,
                  -115, -110, -105, -100, -90, -80, -70, -60, -50, -40,
                  -30, -20, -10, 0, 10, 20, 30, 40, 50, 60, 70, 80, 90,
                  100, 105, 110, 115, 120, 125, 130, 135, 140, 145, 150,
                  155, 160])

# Load main field current values of mag. curve
SEIP5 = np.array([-27.224, -23.547, -20.624, -18.739, -17.560, -16.617,
                  -15.627, -14.826, -13.977, -13.317, -12.643, -11.969,
                  -11.290, -10.041, -8.886, -7.613, -6.576, -5.647, -4.643,
                  -3.582, -2.521, -1.423, -0.400, 0.623, 1.721, 2.782,
                  3.843, 4.847, 5.776, 6.813, 8.086, 9.241, 10.490, 11.169,
                  11.843, 12.517, 13.177, 14.026, 14.827, 15.817, 16.760,
                  17.939, 19.824, 22.747, 26.424])

# Plotting of machine characteristics
plot_option = input('Plot machine characteristics? (y/n): ').lower() == 'y'

if plot_option:
    plt.figure()
    plt.plot(SEIP5, SEVP5)
    plt.xlabel('Armature current Ia in A')
    plt.ylabel('Armature voltage Ea in V')
    plt.axis('square')
    plt.grid(True)
    plt.title('Magnetization Characteristics')

    # Transfer to keyboard for actions (e.g. printing) on above plot
    print('Displaying Mag characteristics, return for simulation')
    input('Press Enter to continue...')

# Obtain positive half of Ea without zero value
hseriesV = SEVP5[23:45]  # indices 24:45 in MATLAB (0-indexed in Python)
hseriesI = SEIP5[23:45]  # obtain positive half of Ia
kaphi = hseriesV / wmo
tem = kaphi * hseriesI

# Compute speed-torque characteristic with rated supply voltage
# and no external resistor
Vmotor = Vrated - 2  # provide for 2 volt of brush drop
Rtotal = Ra + Rse
E = Vmotor - hseriesI * Rtotal
wm = E / kaphi
pem = E * hseriesI  # tem * wm

# Case of Vbrake = Vmotor (only insert Rbrake)
Vbrake = Vmotor
print(f'Vbrake = {Vbrake}')

# Compute braking resistor to limit speed to wbrake with Tload=Trated
wbrake = -400 * 2 * np.pi / 60  # braking speed to rad/sec
print(f'wbrake = {wbrake}')

Iabrake = np.interp(Trated, tem, hseriesI)  # interpolate for Trated
print(f'Iabrake = {Iabrake}')

kaphibrake = np.interp(Iabrake, hseriesI, kaphi)
print(f'kaphibrake = {kaphibrake}')

Rbrake = (Vbrake - kaphibrake * wbrake) / Iabrake - Ra - Rse
print(f'Rbrake = {Rbrake}')

Rtotal = Ra + Rse + Rbrake
E1 = Vbrake - hseriesI * Rtotal
wm1 = E1 / kaphi

# Transferring to keyboard to simulate the case of braking with Va = Vrated
print('Run simulation of braking with Va=Vrated, before returning')
input('Press Enter to continue...')

# Plotting results. Save and return
# Note: 'y' should come from simulation
# y = ... # from simulation

"""
plt.figure()
plt.subplot(4, 1, 1)
plt.plot(y[:, 0], y[:, 4])
plt.title('Rotor speed')
plt.ylabel('wm in rad/sec')

plt.subplot(4, 1, 2)
plt.plot(y[:, 0], y[:, 3])
plt.ylim(-200, 200)
plt.title('Braking Torque Tem with Va=Vrated')
plt.ylabel('Tem in Nm')

plt.subplot(4, 1, 3)
plt.plot(y[:, 0], y[:, 2])
plt.title('Armature current')
plt.ylabel('Ia in A')

plt.subplot(4, 1, 4)
plt.plot(y[:, 0], y[:, 1])
plt.title('Internal voltage Ea')
plt.ylabel('Ea in V')
plt.xlabel('time in sec')

plt.tight_layout()
"""

print('Displaying results of simulation in Fig. 1')
print('Return next for plot of braking characteristics')
input('Press Enter to continue...')

# Case of Vbrake = 0
Vbrake = 0
print(f'Vbrake = {Vbrake}')

Rbrake = (Vbrake - kaphibrake * wbrake) / Iabrake - Ra - Rse
print(f'Rbrake = {Rbrake}')

Rtotal = Ra + Rse + Rbrake
E2 = Vbrake - hseriesI * Rtotal
wm2 = E2 / kaphi

# Plot braking performance with Va = 0 and Vrated along with
# motoring char. with rated voltage
plt.figure()
plt.plot(tem, wm, '-', label='Motoring')
plt.plot(tem, wm1, '-.', label='Braking Va=Vrated')
plt.plot(tem, wm2, '--', label='Braking Va=0')
plt.xlim(right=20)
plt.ylim(-50, 300)
plt.axis('square')
plt.xlabel('Torque in Nm')
plt.ylabel('Rotor speed in rad/sec')
plt.legend()
plt.grid(True)

# Transfer to keyboard for simulating the braking with Va = 0
print('Displaying braking characteristics in Fig. 1')
print('Run simulation of braking with Va=0 before returning')
input('Press Enter to continue...')

"""
plt.figure()
plt.subplot(4, 1, 1)
plt.plot(y[:, 0], y[:, 4])
plt.title('Rotor speed')
plt.ylabel('wm in rad/sec')

plt.subplot(4, 1, 2)
plt.plot(y[:, 0], y[:, 3])
plt.ylim(-200, 200)
plt.title('Braking Torque Tem with Va=0')
plt.ylabel('Tem in Nm')

plt.subplot(4, 1, 3)
plt.plot(y[:, 0], y[:, 2])
plt.title('Armature current')
plt.ylabel('Ia in A')

plt.subplot(4, 1, 4)
plt.plot(y[:, 0], y[:, 1])
plt.title('Internal voltage Ea')
plt.ylabel('Ea in V')
plt.xlabel('time in sec')

plt.tight_layout()
plt.show()
"""
