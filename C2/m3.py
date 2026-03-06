"""
Python conversion of M3.M
RL circuit simulation - input parameters and initial conditions
"""
import numpy as np
import matplotlib.pyplot as plt

# Input parameters and initial conditions
R = 0.4  # R = 0.4 ohm
L = 0.04  # L = 0.04 Henry
we = 314  # excitation frequency in rad/sec
Vac_mag = 100  # magnitude of ac voltage Vac in Volts
iLo = 0  # initial value of inductor current
tstop = 0.5  # stop time for simulation

print('Run simulation, then call plot_results(y) to plot')

def plot_results(y):
    """
    Plot simulation results
    y: array with columns [time, Vac, i]
    """
    fig, axes = plt.subplots(2, 1, figsize=(10, 6))

    axes[0].plot(y[:, 0], y[:, 1])
    axes[0].set_title('ac excitation voltage')
    axes[0].set_ylabel('Vac in V')

    axes[1].plot(y[:, 0], y[:, 2])
    axes[1].set_title('mesh current')
    axes[1].set_xlabel('time in sec.')
    axes[1].set_ylabel('i in A')

    plt.tight_layout()
    plt.show()

# Example usage with scipy.integrate:
# from scipy.integrate import odeint
# def rl_circuit(state, t):
#     i = state[0]
#     Vac = Vac_mag * np.sin(we * t)
#     di_dt = (Vac - R * i) / L
#     return [di_dt]
# t = np.linspace(0, tstop, 1000)
# solution = odeint(rl_circuit, [iLo], t)
# y = np.column_stack([t, Vac_mag * np.sin(we * t), solution[:, 0]])
# plot_results(y)
