"""
MATLAB script file m5.py file for Project 5 on a 2X3
synchronous machine model having three rotor circuits
with coupling in Chapter 7

m5.py does the following:
    loads machine parameters
    set up approximate operating condition for s5.py
"""

import numpy as np
import matplotlib.pyplot as plt

# Clear workspace (not needed in Python)

# Select machine parameter file to enter into Python workspace
print('Enter filename of machine parameter file without .py')
print('Example: set3a, or set3b')
setX = input('Input machine parameter filename > ')

# Import the machine parameter module
exec(f'from {setX} import *')

# Calculate base quantities
we = 2*np.pi*Frated
wbase = 2*np.pi*Frated
wbasem = wbase*(2/Poles)
Sbase = Srated
Vbase = Vrated*np.sqrt(2/3)  # Use peak values as base quantities
Ibase = np.sqrt(2)*(Sbase/(np.sqrt(3)*Vrated))
Zbase = Vbase/Ibase
Tbase = Sbase/wbasem

# Enter d-axis circuit X matrix
X = np.array([[xp3c + xpr2c, xpr2c, xpr2c],
              [xpr2c, xp2c + xpr1c + xpr2c, xpr1c + xpr2c],
              [xpr2c, xpr1c + xpr2c, xp1c + xpr1c + xpr2c]])

B = np.linalg.inv(X)  # inverse of X
b1col = B[0, 0] + B[1, 0] + B[2, 0]  # column 1 sum of B
b2col = B[0, 1] + B[1, 1] + B[2, 1]  # column 2 sum of B
b3col = B[0, 2] + B[1, 2] + B[2, 2]  # column 3 sum of B
bsum = b1col + b2col + b3col  # all element sum of B

# Compute settings for variables in simulation
wb = wbase
xMQ = (1/xls + 1/xmq + 1/xplkq3 + 1/xplkq2 + 1/xplkq1)**(-1)
xMD = (1/xls + 1/xmd + bsum)**(-1)

# Specify desired initial operating condition
P = 1  # specify range and increment of real
Q = 0  # and reactive output power,
       # P is negative for motoring
Vt = 1. + 0*1j  # specify terminal voltage
thetaeo = np.angle(Vt)  # initial value of bus voltage angle
Vm = np.abs(Vt)
St = P+Q*1j  # generated complex power

# Use steady-state phasor equations to determine
# steady-state values of fluxes, etc to establish good
# initial starting condition for simulation
# - or good estimates for the trim function

It = np.conj(St/Vt)
Eq = Vt + (rs + 1j*xq)*It
delt = np.angle(Eq)  # angle Eq leads Vt

# compute q-d steady-state variables
Eqo = np.abs(Eq)
I = It*(np.cos(delt) - np.sin(delt)*1j)
Iqo = np.real(I)
Ido = -np.imag(I)  # when the d-axis lags the q-axis
Efo = Eqo + (xd-xq)*Ido
Ifo = Efo/xmd

Psiado = xmd*(-Ido + Ifo)
Psiaqo = xmq*(-Iqo)

Psiqo = xls*(-Iqo) + Psiaqo
Psido = xls*(-Ido) + Psiado
Psifo = (xpr2c+xpr1c+xp1c)*Ifo + Psiado
Psikd2o = (xpr2c+xpr1c)*Ifo + Psiado
Psikd3o = xpr2c*Ifo + Psiado
Psikq1o = Psiaqo
Psikq2o = Psiaqo
Psikq3o = Psiaqo

Vto = Vt*(np.cos(delt) - np.sin(delt)*1j)
Vqo = np.real(Vto)
Vdo = -np.imag(Vto)
Sto = Vto*np.conj(I)
print(f'Sto = {Sto}')
Eqpo = Vqo + xpd*Ido + rs*Iqo
Edpo = Vdo - xpq*Iqo + rs*Ido

delto = delt  # initial value for rotor angle
thetaro = delto+thetaeo  # thetar(0) of variable frequency oscillator
print(f'thetaro = {thetaro}')
Pemo = np.real(Sto)
Qemo = np.imag(Sto)
Tmech = Pemo

# constant in voltage source
T2piby3 = 2*np.pi/3

# set up loop for repeating multiple cases using the same
# starting condition

repeat_option = 2  # set initially to 2 to repeat yes for more cases

while repeat_option == 2:
    # prompt for choice of disturbance
    print('Choices of disturbance')
    print('1: Step change in Eex')
    print('2: Step change in Tmech')
    print('3: Step change in Vm')
    opt_dist = int(input('Your choice of disturbances? '))

    if opt_dist == 1:  # step change in Eex
        tstop = 5  # run time
        Vm_time = [0, tstop]
        Vm_value = [1, 1]
        Vm_value = [v*Vm for v in Vm_value]  # Bus voltage kept constant
        tmech_time = [0, tstop]
        tmech_value = [1, 1]
        tmech_value = [v*Tmech for v in tmech_value]  # Tmech kept constant
        Ex_time = [0, 0.2, 0.2, tstop]
        Ex_value = [1, 1, 1.1, 1.1]
        Ex_value = [v*Efo for v in Ex_value]  # step change in Eex
        print(' Disturbance sequence in Eex is ')
        print(Ex_time)
        print(Ex_value)

    if opt_dist == 2:  # step change in Tmech
        tstop = 5  # run time
        Vm_time = [0, tstop]
        Vm_value = [1, 1]
        Vm_value = [v*Vm for v in Vm_value]  # Bus voltage kept constant
        tmech_time = [0, 0.5, 0.5, 3, 3, tstop]
        tmech_value = [1, 1, 0, 0, -1, -1]
        tmech_value = [v*Tmech for v in tmech_value]  # step change in Tmech
        Ex_time = [0, tstop]
        Ex_value = [1, 1]
        Ex_value = [v*Efo for v in Ex_value]  # Eex kept constant
        print(' Disturbance sequence in Tmech is ')
        print(tmech_time)
        print(tmech_value)

    if opt_dist == 3:  # step change in Vm
        tstop = 1.5  # run time
        tmech_time = [0, tstop]
        tmech_value = [1, 1]
        tmech_value = [v*Tmech for v in tmech_value]  # step change in Tmech
        Ex_time = [0, tstop]
        Ex_value = [1, 1]
        Ex_value = [v*Efo for v in Ex_value]  # Eex kept constant
        print('Three phase terminal short-circuit fault')
        print('will be applied at 0.1 second into the simulation')
        ncycle = float(input('Enter in the number of cycles desired > '))
        tfault = ncycle/Frated  # fault time
        tfstart = 0.1  # set fault to begin at 0.1 sec into simulation
        Vm_time = [0, tfstart, tfstart, (tfstart+tfault), (tfstart+tfault), tstop]
        Vm_value = [1, 1, 0, 0, 1, 1]
        Vm_value = [v*Vm for v in Vm_value]  # Vm is zero during short circuit
        print(' Disturbance sequence in Vm is ')
        print(Vm_time)
        print(Vm_value)

    # Transfer to keyboard for simulation
    print('Simulation s5.py is now ready for running,')
    print(' You may enter changes to parameters and input values')
    print(' via the Python window before running your simulation.')
    print(' After running simulation, type ''return'' for plots.')

    input('Press Enter to continue...')

    # NOTE: Simulation would go here
    print("\nNOTE: Simulink model s5 needs to be converted to Python simulation")
    print("This is a placeholder for the simulation run")

    # Plotting would go here after simulation is implemented

    # prompt for options to repeat
    print('1: Quit')
    print('2: Repeat run')
    repeat_input = input('Repeat run? ')
    if repeat_input == '':
        repeat_option = 1
    else:
        repeat_option = int(repeat_input)
