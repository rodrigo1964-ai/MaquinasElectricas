"""
MATLAB script file m4.py is for Project 4 on permanent magnet
synchronous motor in Chapter 7.

m4.py does the following:
  loads machine parameters of the permanent magnet motor
  set up initial operating condition
"""

import numpy as np
import matplotlib.pyplot as plt

# Clear workspace (not needed in Python)

# Enter into Python workspace the per unit parameter of
# 230 V, 4 hp, 2-pole, 60 Hz, three-phase line-start
# permanent magnet synchronous motor

Frated = 60  # 60 Hz source
Poles = 2    # 2 pole machine
Vrated = 230  # 230 V rms line to line
we = 2*np.pi*Frated
wbase = 2*np.pi*Frated
wbasem = wbase*(2/Poles)

# QD0 equivalent circuit parameters in per unit
Domega = 0  # rotor damping coefficient

print('QD0 circuit parameters in per unit')

H = 0.3
rs = 0.017
xls = 0.065
x0 = xls
xd = 0.543
xq = 1.086
xmq = xq - xls
xmd = xd - xls
rpkd = 0.054
rpkq = 0.108
xplkd = 0.132
xplkq = 0.132

# Compute settings for variables in simulation
wb = wbase
xMQ = (1/xls + 1/xmq + 1/xplkq)**(-1)
xMD = (1/xls + 1/xmd + 1/xplkd)**(-1)

print(f'wb = {wb}')
print(f'xMQ = {xMQ}')
print(f'xMD = {xMD}')

# Set choice to initialize simulation
# for starting runs, initialize with zeros

print('Choice of initial values for simulation')
print('1: Initialize with ss condition')
print('2: Initialize with zeros')
opt_initial = int(input('Option to use ss condition to initialize? '))

# Set up loop for repeating multiple cases in which
# the magnet strength has to be determined from terminal operating condition

repeat_option = 3  # set initially to 3 to repeat yes for more cases

while repeat_option == 3:
    Vt_input = input('Enter pu terminal voltage, e.g 1+0j, Vt = ')
    Vt = complex(Vt_input)
    Vm = np.abs(Vt)

    print(' Enter your choice to specify magnet excitation')
    print('1: Will specify delta and i_m directly')
    print('2: Compute im for desired operating condition')
    opt_magnet = int(input('Option to specify i_m ? '))

    if opt_magnet == 1:  # enter i'm and delta
        Ipm = float(input('Enter pu value of Ipm , e.g 1.8, Ipm = '))
        delt = float(input('Enter value of delta in radians, e.g. -1.2, delta = '))
        Emo = Ipm*xmd  # pm excitation voltage
        Ido = (Vm*np.cos(delt) - Emo)/xd
        Iqo = -Vm*np.sin(delt)/xq

    if opt_magnet == 2:  # determine i'm from given operating condition
        # Steady-state calculations to help determine the required
        # equivalent magnetizing current, i'm, of permanent magnets
        # when lambda'm is not specified.

        Sm_input = input('Enter pu complex power into motor, e.g 1+0j, Sm = ')
        Sm = complex(Sm_input)

        # Use steady-state phasor equations to determine
        # steady-state values of fluxes, etc to establish the
        # initial starting condition for simulation

        It = np.conj(Sm/Vt)  # It = (Iqe - j*Ide) in pu
        Eq = Vt - (rs + 1j*xq)*It  # Eq = Eqe - j*Ede in pu
        delt = np.angle(Eq)  # angle Eq leads Vt

        # compute rotor qd steady-state variables
        Eqo = np.abs(Eq)
        I = It*(np.cos(delt) - np.sin(delt)*1j)
        Iqo = np.real(I)
        Ido = -np.imag(I)  # d-axis lags q-axis
        Emo = Eqo - (xd-xq)*Ido  # pm excitation voltage
        print('Per unit magnetizing current of magnet, Ipm, is')
        Ipm = Emo/xmd  # equiv. magnetizing current of permanent magnet
        print(f'Ipm = {Ipm}')

    print('Computing and plotting steady-state curve next')
    # plot steady-state torque versus angle curve for motor,
    # using above Ipm and parameters
    # but neglecting stator resistance

    mdel = np.arange(0, -(np.pi + 0.1), -0.1)
    N = len(mdel)
    texcm = Vm*Ipm*xmd/xd
    trelm = Vm*Vm*(1/xq - 1/xd)/2
    texc = np.zeros(N)
    trel = np.zeros(N)
    tres = np.zeros(N)

    for n in range(N):
        mdeln = mdel[n]
        texc[n] = -texcm*np.sin(mdeln)
        trel[n] = -trelm*np.sin(2*mdeln)
        tres[n] = texc[n] + trel[n]  # ignoring stator resistance

    plt.figure()
    plt.plot(mdel, trel, '--', label='Reluctance')
    plt.plot(mdel, texc, ':', label='Excitation')
    plt.plot(mdel, tres, '-', label='Total')
    plt.ylabel('torque in pu')
    plt.xlabel('delta in radians')
    plt.axis('square')
    plt.title('Steady-state torque vs. angle curves')
    plt.legend()
    plt.grid(True)

    if opt_initial == 1:  # initialize integrators with ss condition
        Psiado = xmd*(Ido + Ipm)
        Psiaqo = xmq*(Iqo)
        Psiqo = xls*(Iqo) + Psiaqo
        Psido = xls*(Ido) + Psiado
        Psikqo = Psiaqo
        Psikdo = Psiado
        wrslipo = 0  # when wr = we, (wr-we)/we is zero
        delto = delt  # here delto = thetar(0)- thetae(0)
        temo = (xd - xq)*Ido*Iqo + xmd*Ipm*Iqo

    if opt_initial == 2:  # initialize integrators with zeros
        Psiado = xmd*Ipm  # permanent field excitation always on
        Psiaqo = 0
        Psiqo = Psiaqo
        Psido = Psiado
        Psikqo = Psiaqo
        Psikdo = Psiado
        wrslipo = -1  # at standstill, wr = 0,(wr-we)/we is -1
        delto = 0  # here delto = thetar(0)- thetae(0)
        temo = 0

    repeat_option = 2  # reset to enter next loop

    # set up loop for repeating runs with different external
    # parameters, such as rotor inertia, loading

    while repeat_option == 2:
        tstop = 1.5  # run time of simulation
        print(f'H = {H}')  # inertia constant of rotor assembly

        # program time and output arrays of repeating sequence
        # signal for input mechanical torque, Tmech, (negative for motoring load
        # and equivalent magnetizing current of magnet, Ipm.

        tmech_time = [0, tstop]
        tmech_value = [-1*temo, -1*temo]  # Tmech is negative for motoring load

        print('Save steady-state plot and enter desired changes')
        print('  in parameters or loading now via Python window')
        print('e.g.  tstop - stop time for simulation')
        print('      H - the inertia constant of rotor assembly')
        print('      tmech_value - values of Tmech')
        print('Perform simulation then type ''return'' for plots')

        input('Press Enter to continue...')

        # NOTE: Simulation would go here
        print("\nNOTE: Simulink model s4 needs to be converted to Python simulation")
        print("This is a placeholder for the simulation run")

        # Prompt for options to repeat
        print('1: Quit')
        print('2: Just new parameters')
        print('3: Recalculate Ipm for new condition')
        repeat_input = input('Repeat what options? ')
        if repeat_input == '':
            repeat_option = 1
        else:
            repeat_option = int(repeat_input)

    plt.show()
