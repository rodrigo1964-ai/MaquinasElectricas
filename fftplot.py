"""
This script is for obtaining the FFT plot of any variable
that is stored as a column array.
It requires the column array of the variable as well as the
column array of the time corresponding to the variable values.
The time step need not be uniform.
Here FFT computation is a post-processing procedure, the
integration step size may be variable.

The FFT computation is faster when
the number of data points, npts_fft, is even.

To minimize leakage, the time window, T_window, of the data points
should be integer multiples of the fundamental frequency, T_1.
The frequency resolution of the discrete Fourier transform
is inversely proportional to the size of the time window.
freq_resolution = 1/T_window Hz, for distinct peak in FFT plot
freq_resolution should be a small fraction of fundamental frequency
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy.interpolate import interp1d


def fftplot(xx, yy, ystring, Frated, tt=None, ncycle=21, samples_per_cycle=128, nharm=8):
    """
    Compute and plot FFT of a time series variable.

    Parameters:
    -----------
    xx : array-like
        Time array (column array)
    yy : array-like
        Variable array (column array)
    ystring : str
        String label for the variable (e.g., 'i_1')
    Frated : float
        Fundamental frequency in Hz
    tt : float, optional
        Time when sample cycle ends. If None, uses the last time point.
    ncycle : int, optional
        Total number of cycles used in FFT calculation (default: 21)
    samples_per_cycle : int, optional
        Number of samples per cycle (default: 128)
    nharm : int, optional
        Highest harmonic number to display on the x axis (default: 8)

    Returns:
    --------
    freq : ndarray
        Frequency values
    Fp : ndarray
        FFT magnitudes (rescaled)
    """

    print('Script file computes Fourier transform of variable')
    print('based on its value in the cycle before the time you provide.')
    print('It plots the variable vs time and its transform vs frequency.')

    # Convert to numpy arrays
    xx = np.array(xx).flatten()
    yy = np.array(yy).flatten()

    T_1 = 1 / Frated  # period of fundamental

    # Select sampling frequency based on highest harmonic of interest
    sample_time = T_1 / (samples_per_cycle - 1)  # sampling time
    sample_freq = 1 / sample_time  # sampling frequency
    print(f'Sampling frequency: {sample_freq:.4g} Hz')
    print(f'Highest frequency should be less than {sample_freq/2:.4g} Hz')

    # Pad with odd number of cycles to get even npts_fft and
    # the desired frequency resolution
    npts_fft = ncycle * samples_per_cycle  # number of FFT points
    record_length = ncycle * T_1  # total record length in seconds
    print(f'Record length: {record_length:.4g} seconds')

    freq_resolution = 1 / record_length  # frequency resolution of FFT output
    print(f'Frequency resolution: {freq_resolution:.4g} Hz')

    # Use provided time or last time point
    if tt is None:
        tt = xx[-1]

    tmargin = sample_time  # margin to avoid exceeding range
    time = np.arange(tt - T_1 - tmargin, tt - tmargin, sample_time)

    # Linear interpolation
    f_interp = interp1d(xx, yy, kind='linear', fill_value='extrapolate')
    ysample = f_interp(time)

    # Ensure column vector
    ysample = ysample.flatten()

    ytrunc = ysample[:samples_per_cycle - 1]
    y_fft = ysample.copy()

    for n in range(1, ncycle):
        y_fft = np.concatenate([y_fft, ytrunc])

    # Compute FFT
    F = np.fft.fft(y_fft)
    N = len(y_fft)  # determine actual length of array

    Fdc = F[0] / N  # extract zero frequency point and rescale DC component

    # Extract positive frequency points and rescale magnitude
    Fp = np.concatenate([[Fdc], F[1:N//2 + 1] * (2 / N)])

    # Frequency values for plotting
    freq = (sample_freq / N) * np.arange(N // 2 + 1)

    # Create plot
    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(10, 8))

    # Time trace plot
    ax1.plot(xx, yy)
    ax1.set_title(f'Time trace of {ystring}')
    ax1.set_xlabel('time in sec')
    ax1.set_ylabel(ystring)
    ax1.grid(True)

    # FFT plot
    ax2.plot(freq, np.abs(Fp))
    ax2.set_xlim([0, nharm * Frated])
    ax2.set_xlabel('frequency in Hz')
    ax2.set_ylabel('Fourier transform/N')
    ax2.set_title(f'Discrete transform of {ystring}')
    ax2.grid(True)

    plt.tight_layout()
    plt.show()

    print('Close the plot window to continue or save the plot before closing.')

    return freq, Fp


def fftplot_interactive():
    """
    Interactive version that prompts for inputs.
    """
    print('Script file computes Fourier transform of variable')
    print('based on its value in the cycle before the time you provide.')
    print('It plots the variable vs time and its transform vs frequency.')
    print('It will prompt you next for information regarding variable')
    print('')

    Frated = float(input('Enter fundamental frequency in Hz > '))

    print("Enter the time and variable arrays (must be available in your namespace)")
    print("Example usage: after loading data, call this function with arrays")
    print("For programmatic use, call fftplot(xx, yy, ystring, Frated) instead")

    # Note: Interactive input of arrays is difficult in Python
    # This would typically be called programmatically


if __name__ == '__main__':
    print("This module provides FFT plotting functionality.")
    print("Import and use: fftplot(time_array, variable_array, 'label', frequency)")
    print("Or use fftplot_interactive() for interactive mode")
