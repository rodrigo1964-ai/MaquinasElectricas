"""
Python conversion of M1.M
Plots the Simulation results of the vco circuit
"""
import numpy as np
import matplotlib.pyplot as plt

# Assuming yout is loaded from simulation results
# yout should be a numpy array with columns [time, y1, y2]

def plot_results(yout):
    """
    Plot simulation results
    yout: array with columns [time, y1, y2]
    """
    plt.plot(yout[:, 1], yout[:, 2], '-', label='y1')
    plt.plot(yout[:, 1], yout[:, 3], '-.', label='y2')
    plt.xlabel('time in sec')
    plt.ylabel('y1 and y2')
    plt.legend()
    plt.show()

# Example usage:
# yout = np.loadtxt('simulation_results.txt')  # Load your simulation data
# plot_results(yout)
