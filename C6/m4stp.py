"""
M-file for the last part of Project 4 on linearized analysis in Chapter 6
m4stp.py sets up the system parameters for a simulation
to obtain a simulated response of the motor speed to a unit disturbance in Vqse
"""
import numpy as np
import matplotlib.pyplot as plt
from p20hp import *  # Use 20 hp three-phase motor parameters

# Specify initial value variables
Psiqso = Vm
Psipqro = Vm
Psidso = 0
Psipdro = 0
wrbywbo = 1

print('Using M4STP.PY to set up')
print('After simulation, call plot_step_response(y) for the plot')

def plot_step_response(y):
    """
    Plot step response
    y should be array with columns: [time, pu_speed]
    """
    plt.figure(figsize=(8, 8))
    plt.plot(y[:, 0], y[:, 1])
    plt.title('Response to one volt step')
    plt.xlabel('time in sec')
    plt.ylabel('pu speed wr/wb')
    plt.axis('equal')
    plt.grid(True)
    plt.show()
