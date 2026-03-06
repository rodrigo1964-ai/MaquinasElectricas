"""
Python conversion of MGPLT.M
Plots results from simulation run comparing errors from rms open-circuit curve
and from instantaneous psi vs i curve
"""
import matplotlib.pyplot as plt
import numpy as np

def plot_magnetization_results(I, V, i, psi, yin, yout):
    """
    Plot magnetization comparison results

    Parameters:
    I, V: rms open-circuit curve data
    i, psi: instantaneous flux vs current data
    yin: simulation input data
    yout: simulation output data
    """
    fig, axes = plt.subplots(2, 2, figsize=(12, 12))

    axes[0, 0].plot(I, V, '-')
    axes[0, 0].grid(True)
    axes[0, 0].set_ylabel('V rms in V')
    axes[0, 0].set_xlabel('I rms in A')
    axes[0, 0].set_aspect('equal')
    axes[0, 0].set_title('Open circuit curve in rms')

    axes[0, 1].plot(i, psi, '-')
    axes[0, 1].set_ylabel('psi in V')
    axes[0, 1].set_xlabel('i in A')
    axes[0, 1].set_aspect('equal')
    axes[0, 1].set_title('Instantaneous flux versus current')

    axes[1, 0].plot(yin[:, 0], yout[:, 1], '-')
    axes[1, 0].set_ylabel('Current error in rms amps')
    axes[1, 0].set_xlabel('time in sec')
    axes[1, 0].set_aspect('equal')
    axes[1, 0].set_ylim(-0.1, 0.1)
    axes[1, 0].set_title('Error from rms value curve')

    axes[1, 1].plot(yin[:, 0], yout[:, 0], '-')
    axes[1, 1].set_ylabel('Current error in rms amps')
    axes[1, 1].set_xlabel('time in sec')
    axes[1, 1].set_aspect('equal')
    axes[1, 1].set_ylim(-0.1, 0.1)
    axes[1, 1].set_title('Error from instantaneous value curve')

    plt.tight_layout()
    plt.show()

# Example usage:
# from mginit import I, V, i, psi
# # After simulation: yin, yout = simulate(...)
# # plot_magnetization_results(I, V, i, psi, yin, yout)
