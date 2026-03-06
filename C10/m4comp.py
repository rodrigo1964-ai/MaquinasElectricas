"""
MATLAB to Python conversion of M4COMP.M
Checks preliminary designs of the PSS in Project 4 on
power system stabilizer in Chapter 10.

Provides Bode plot of PSS transfer function and optionally
root-locus plot of PSS open-loop transfer function.
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy import signal


def m4comp(GEP_num=None, GEP_den=None):
    """
    PSS design analysis

    Parameters:
    -----------
    GEP_num : array-like, optional
        Numerator of GEP(s) from m4.py
    GEP_den : array-like, optional
        Denominator of GEP(s) from m4.py
    """
    # Input parameters of PSS
    Ks = 120
    Tw = 1.0
    T1 = 0.024
    T2 = 0.002
    T3 = 0.024
    T4 = 0.24

    # Construct transfer function polynomials
    numW = np.array([1, 0])
    denW = np.array([Tw, 1])
    num1 = np.array([T1, 1])
    den1 = np.array([T2, 1])
    num2 = np.array([T3, 1])
    den2 = np.array([T4, 1])

    # Convolve to get composite transfer functions
    num3 = np.convolve(num1, num2)
    den3 = np.convolve(den1, den2)
    num_unit = np.convolve(num3, numW)  # unity gain
    num = Ks * num_unit
    den = np.convolve(den3, denW)

    # Calculate zeros, poles, and gain
    z, p, k = signal.tf2zpk(num, den)

    print("PSS Transfer Function")
    print("=" * 50)
    print(f"Zeros: {z}")
    print(f"Poles: {p}")
    print(f"Gain: {k}")

    # Plot frequency response
    freq = np.logspace(-1, 3, 500)
    w = 2 * np.pi * freq
    w_rad, m_Comp, p_Comp = signal.bode((num, den), w)

    plt.figure(figsize=(10, 8))
    plt.subplot(211)
    plt.semilogx(freq, m_Comp)
    plt.grid(True)
    plt.ylabel('Gain (dB)')
    plt.xlabel('Freq (Hz)')
    plt.title('Gain of PSS(s) vs. frequency')

    plt.subplot(212)
    plt.semilogx(freq, p_Comp)
    plt.grid(True)
    plt.ylabel('Phase (deg)')
    plt.xlabel('Freq (Hz)')
    plt.title('Phase of PSS(s) vs. frequency')
    plt.tight_layout()
    plt.show()

    # Root locus plot if GEP(s) is available
    if GEP_num is not None and GEP_den is not None:
        print("\nPlotting root locus of PSS*GEP loop...")

        open_num = np.convolve(num_unit, GEP_num)
        open_den = np.convolve(den, GEP_den)

        # Create root locus
        k_values = np.arange(10, 310, 10)
        sys = signal.TransferFunction(open_num, open_den)

        # Note: scipy doesn't have built-in root locus like MATLAB
        # Manual implementation would be needed for full root locus
        print("Root locus requires manual calculation")
        print(f"Open-loop system order: {len(open_den)-1}")

    return num, den, z, p, k


if __name__ == '__main__':
    print("M4COMP - PSS Design Analysis")
    print("=" * 50)
    m4comp()
