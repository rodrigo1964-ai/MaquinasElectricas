"""
MATLAB script file m3.py for Project 3 on linearized analysis
of a synchronous generator in Chapter 7.

m3.py does the following:
  (a) loads parameters and rating of the synchronous machine;
  (b) set up Pgen and Qgen lists for tasks (i) thru (iv)
      (i) uses Simulink trim function to determine
          steady-state of a desired operating point of the
          Simulink system given in s3eig.py;
      (ii) uses Python linmod to determine A,B,C, and D;
      (iii) uses Python ss2tf to determine
            the speed-torque transfer function
      (iv) uses Python tf2zp to determine the poles and zeros
           of the speed-torque transfer function
  (c) generates root locus plots
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy import signal
from scipy.optimize import fsolve

# Clear workspace (not needed in Python)

# Put synchronous machine set 1 parameters in Python workspace
from set1 import *

# Calculate base quantities
we = 2*np.pi*Frated
wbase = 2*np.pi*Frated
wbasem = wbase*(2/Poles)
Sbase = Prated/Pfrated
Vbase = Vrated*np.sqrt(2/3)  # Use peak values as base quantities
Ibase = np.sqrt(2)*(Sbase/(np.sqrt(3)*Vrated))
Zbase = Vbase/Ibase
Tbase = Sbase/wbasem

print(f'we = {we}')
print(f'wbase = {wbase}')
print(f'wbasem = {wbasem}')
print(f'Sbase = {Sbase}')
print(f'Vbase = {Vbase}')
print(f'Ibase = {Ibase}')
print(f'Zbase = {Zbase}')
print(f'Tbase = {Tbase}')

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

print(f'xmq = {xmq}')
print(f'xmd = {xmd}')
print(f'xplf = {xplf}')
print(f'xplkd = {xplkd}')
print(f'xplkq = {xplkq}')
print(f'rpf = {rpf}')
print(f'rpkd = {rpkd}')
print(f'rpkq = {rpkq}')

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

# Compute settings for variables in simulation
wb = wbase
xMQ = (1/xls + 1/xmq + 1/xplkq)**(-1)
xMD = (1/xls + 1/xmd + 1/xplf + 1/xplkd)**(-1)

print(f'wb = {wb}')
print(f'xMQ = {xMQ}')
print(f'xMD = {xMD}')

# Specify desired operating condition lists
P = np.arange(0, 1.0, 0.2)  # specify range and increment of real
Q = np.arange(0, 0.75, 0.15)  # and reactive output power,
                              # P is negative for motoring
Vt = 1. + 0*1j  # specify terminal voltage
Vm = np.abs(Vt)
St = P[0]+Q[0]*1j  # generated complex power

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

print(f'Sto = {Sto}')

delto = delt
Pemo = np.real(Sto)
Qemo = np.imag(Sto)
Tmech = Pemo

# NOTE: The following section requires implementation of:
# 1. s3eig model in Python
# 2. trim function equivalent
# 3. linmod function equivalent
# 4. ss2tf, tf2zp functions (available in scipy.signal)

print("\nNOTE: This script requires the s3eig Simulink model to be")
print("converted to a Python state-space model for linearization analysis.")
print("The trim, linmod functions need Python equivalents.")
print("\nPlaceholder for linearization analysis and root locus plots")

# Input guesses
ug = np.array([Vm, 0, Efo, Tmech])
xg = np.array([delto, Psiqo, Psikqo, Psido, Psifo, Psikdo, 0.])
yg = np.array([Pemo, Qemo, delto, -Tmech, 0])

print(f'\nInitial guesses:')
print(f'ug = {ug}')
print(f'xg = {xg}')
print(f'yg = {yg}')

# For loop to compute the desired transfer functions
# over the list of specified operating conditions
# This would require the full state-space model implementation

print("\nLinearization loop would go here with state-space model")
