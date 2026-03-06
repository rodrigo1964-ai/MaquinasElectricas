"""
M-file for the second part of Project 4 on linearized analysis in Chapter 6
to obtain the unit step response of the motor transfer function, numG/denG.
It can only be used after the transfer function has been
determined by m4.py, that is numG/denG must be already defined.

M4USTP.PY computes the step response and plots the unit step response
of the transfer function numG/denG.
Requires scipy.signal for step response computation.
"""
import numpy as np
import matplotlib.pyplot as plt
from scipy import signal

def plot_step_response(numG, denG):
    """
    Compute and plot step response of transfer function numG/denG

    Parameters:
    -----------
    numG : array_like
        Numerator polynomial coefficients
    denG : array_like
        Denominator polynomial coefficients
    """
    # Set up the regularly spaced time points
    t = np.arange(0, 0.25 + 0.0005, 0.0005)

    # Create transfer function
    sys = signal.TransferFunction(numG, denG)

    # Obtain the step response
    t, y = signal.step(sys, T=t)

    # Plot
    plt.figure(figsize=(10, 6))
    plt.plot(t, y)
    plt.title('step response of numG/denG')
    plt.xlabel('time (s)')
    plt.ylabel('response')
    plt.grid(True)
    plt.show()

    return t, y

# Example usage:
# After running m4.py and obtaining numG, denG:
# t, y = plot_step_response(numG, denG)
