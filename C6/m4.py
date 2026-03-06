"""
M-file for Project 4 on linearized analysis in Chapter 6
To be used for linearization analysis of an induction machine
in the synchronous reference frame

It does the following:
  (a) loads parameters and rating of machine
  (b) set up Tmech loading levels in T vector for tasks (i) thru (iv)
  (i) uses trim function concept to determine steady-state operating point
  (ii) determines A, B, C, and D matrices (linearization)
  (iii) determines the speed-torque transfer function
  (iv) determines the poles and zeros of the speed-torque transfer function
  (c) generates a plot of poles for changing Tmech

Note: This is a simplified Python version. Full Simulink trim/linmod
functionality would require control system toolbox equivalent (python-control).
"""
import numpy as np
import matplotlib.pyplot as plt
from p20hp import *  # Parameters of 20 hp three-phase induction motor

# Define all initial value variables
Psiqso = Vm
Psipqro = Vm
Psidso = 0
Psipdro = 0
wrbywbo = 1

# Initial voltage
Vm = Vrated * np.sqrt(2 / 3)  # peak voltage per phase

# Specify range and increment of external mech torque, negative for motoring
T = np.arange(0, -Tb - 0.001, -Tb)

print("M4.py - Linearization analysis setup")
print(f"Base voltage Vm = {Vm:.2f} V")
print(f"Base torque Tb = {Tb:.2f} Nm")
print(f"Torque loading range: {T}")
print("\nNote: This Python version provides parameter setup.")
print("Full linearization analysis requires scipy.signal or python-control library")
print("for transfer function computation and root locus plotting.")

# Storage for transfer function numerators and denominators
numt = []
dent = []
numv = []
denv = []
zt = []
pt = []
kt = []
zv = []
pv = []
kv = []

print("\nFor transfer function (Δwr/wb)/ΔTmech and (Δwr/wb)/Δvqse:")
print("Linearization around operating points would be computed here.")
print("This requires numerical simulation with scipy.integrate and")
print("numerical differentiation or symbolic computation.")

# Example of how to proceed with scipy.signal:
# from scipy import signal
# For each Tmech in T:
#   1. Find steady-state (solve algebraic equations)
#   2. Linearize around that point
#   3. Compute transfer functions
#   4. Extract poles/zeros

# Root Locus Plot information
print("\nFor root locus plot with sensor TF of 1/(0.05s+1):")
print("Use python-control library: import control")
print("Example: control.root_locus(sys)")
