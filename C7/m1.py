"""
MATLAB script file m1.py for Projects 1 and 5 on
operating characteristics of synchronous machine in Chapter 7

m1.py does the following:
    loads machine parameters
    set up study condition for s1.py
"""

import numpy as np
import matplotlib.pyplot as plt

# Clear workspace (not needed in Python, but kept for reference)
# Variables are local to the script

# Select machine parameter file to enter into Python workspace
print('Enter filename of machine parameter file without .py')
print('Example: set1 or set3c')
setX = input('Input machine parameter filename > ')

# Import the machine parameter module
exec(f'from {setX} import *')

# Calculate base quantities
we = 2*np.pi*Frated
wbase = 2*np.pi*Frated
wbasem = wbase*(2/Poles)
Sbase = Prated/Pfrated
Vbase = Vrated*np.sqrt(2/3)  # Use peak values as base quantities
Ibase = np.sqrt(2)*(Sbase/(np.sqrt(3)*Vrated))
Zbase = Vbase/Ibase
Tbase = Sbase/wbasem

# Calculate dq0 equivalent circuit parameters
if xls == 0:
    xls = x0  # assume leakage reactance = zero_sequence

xmq = xq - xls
xmd = xd - xls

xplf = xmd*(xpd - xls)/(xmd - (xpd-xls))

xplkd = xmd*xplf*(xppd-xls)/(xplf*xmd - (xppd-xls)*(xmd+xplf))

xplkq = xmq*(xppq - xls)/(xmq - (xppq-xls))

rpf = (xplf + xmd)/(wbase*Tpdo)

rpkd = (xplkd + xpd - xls)/(wbase*Tppdo)

rpkq = (xplkq + xmq)/(wbase*Tppqo)

# Convert to per unit dqo circuit parameters
if Perunit == 0:  # parameters given in Engineering units
    print('Dq0 circuit parameters in per unit')

    H = 0.5*J_rotor*wbasem*wbasem/Sbase
    rs = rs/Zbase
    xls = xls/Zbase

    xppd = xppd/Zbase
    xppq = xppq/Zbase
    xpd = xpd/Zbase
    xpq = xpq/Zbase

    x2 = x2/Zbase
    x0 = x0/Zbase

    xd = xd/Zbase
    xq = xq/Zbase

    xmd = xmd/Zbase
    xmq = xmq/Zbase

    rpf = rpf/Zbase
    rpkd = rpkd/Zbase
    rpkq = rpkq/Zbase

    xplf = xplf/Zbase
    xplkd = xplkd/Zbase
    xplkq = xplkq/Zbase

# Establish initial conditions for starting simulation
wb = wbase
xMQ = (1/xls + 1/xmq + 1/xplkq)**(-1)
xMD = (1/xls + 1/xmd + 1/xplf + 1/xplkd)**(-1)

# Specify desired operating condition lists
P = 1.0  # specify range and increment of real
Q = 0    # and reactive output power,
         # P is negative for motoring
Vt = 1. + 0*1j  # specify terminal voltage
thetaeo = np.angle(Vt)  # initial value of voltage angle
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
Psifo = xplf*Ifo + Psiado
Psikqo = Psiaqo
Psikdo = Psiado

Vto = Vt*(np.cos(delt) - np.sin(delt)*1j)
Vqo = np.real(Vto)
Vdo = -np.imag(Vto)
Sto = Vto*np.conj(I)
Eqpo = Vqo + xpd*Ido + rs*Iqo
Edpo = Vdo - xpq*Iqo + rs*Ido

delto = delt  # initial value of rotor angle
thetaro = delto+thetaeo  # thetar(0) in variable frequency oscillator
Pemo = np.real(Sto)
Qemo = np.imag(Sto)
Tmech = Pemo

T2piby3 = 2*np.pi/3  # phase angle of bus phase voltages

# Set up loop for repeating multiple cases using the same starting condition
repeat_option = 2  # set initially to 2 to repeat yes for more cases

while repeat_option == 2:
    # Prompt for choice of disturbance
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
    print('Simulation s1.py is now ready for running,')
    print(' You may still enter changes to parameters or input values')
    print('  via the Python window before running s1')
    print('After running s1, type ''return'' for plots')

    # Note: In Python, you would call the simulation function here
    # For now, this is a stub that would be replaced with actual simulation
    print('NOTE: Simulink model s1 needs to be converted to Python simulation')
    print('This is a placeholder for the simulation run')

    # Simulate the system (placeholder)
    # y = run_simulation_s1(...)

    # Plotting would go here after simulation is implemented

    # Prompt for options to repeat
    print('1: Quit')
    print('2: Repeat run')
    repeat_input = input('Repeat run? ')
    if repeat_input == '':
        repeat_option = 1
    else:
        repeat_option = int(repeat_input)
