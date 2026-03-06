"""
Python conversion of FFTPLOT.M
Computes and plots FFT of any variable stored as column array
"""
import numpy as np
import matplotlib.pyplot as plt
from scipy.interpolate import interp1d

def fft_plot(time_array, variable_array, variable_label, Frated=60, samples_per_cycle=128,
             ncycle=21, end_time=None, nharm=8):
    """
    Compute and plot FFT of a variable

    Parameters:
    time_array: array of time values
    variable_array: array of variable values
    variable_label: string label for the variable
    Frated: fundamental frequency in Hz (default 60)
    samples_per_cycle: number of samples per cycle (default 128)
    ncycle: number of cycles for FFT (default 21)
    end_time: time when sample cycle ends (default: last time)
    nharm: highest harmonic number to display (default 8)
    """
    T_1 = 1 / Frated  # period of fundamental

    # Sampling parameters
    sample_time = T_1 / (samples_per_cycle - 1)
    sample_freq = 1 / sample_time

    print(f'Sampling frequency: {sample_freq:.4g} Hz')
    print(f'Highest frequency should be less than {sample_freq/2:.4g} Hz (Nyquist)')

    # FFT parameters
    npts_fft = ncycle * samples_per_cycle
    record_length = ncycle * T_1
    freq_resolution = 1 / record_length

    print(f'Record length: {record_length} seconds')
    print(f'Frequency resolution: {freq_resolution} Hz')

    # Set end time
    if end_time is None:
        end_time = time_array[-1]

    # Create uniformly spaced sample times
    tmargin = sample_time
    time_uniform = np.arange(end_time - T_1 - tmargin, end_time - tmargin, sample_time)

    # Interpolate variable to uniform time grid
    interp_func = interp1d(time_array, variable_array, kind='linear', fill_value='extrapolate')
    ysample = interp_func(time_uniform)

    # Extract one cycle and replicate
    ytrunc = ysample[:samples_per_cycle - 1]
    y_fft = np.copy(ysample[:samples_per_cycle - 1])
    for n in range(1, ncycle):
        y_fft = np.concatenate([y_fft, ytrunc])

    # Compute FFT
    F = np.fft.fft(y_fft)
    N = len(y_fft)

    # Extract and rescale components
    Fdc = F[0] / N
    Fp = np.zeros(N // 2 + 1, dtype=complex)
    Fp[0] = Fdc
    Fp[1:] = F[1:N//2 + 1] * (2 / N)

    # Frequency values
    freq = (sample_freq / N) * np.arange(N // 2 + 1)

    # Plot results
    fig, axes = plt.subplots(2, 1, figsize=(12, 8))

    axes[0].plot(time_array, variable_array)
    axes[0].set_title(f'Time trace of {variable_label}')
    axes[0].set_xlabel('time in sec')
    axes[0].set_ylabel(variable_label)
    axes[0].grid(True)

    axes[1].plot(freq, np.abs(Fp))
    axes[1].set_xlim(0, nharm * Frated)
    axes[1].set_xlabel('frequency in Hz')
    axes[1].set_ylabel('Fourier transform/N')
    axes[1].set_title(f'Discrete transform of {variable_label}')
    axes[1].grid(True)

    plt.tight_layout()
    plt.show()

    return freq, Fp

# Example usage:
# t = np.linspace(0, 1, 1000)
# signal = np.sin(2 * np.pi * 60 * t) + 0.3 * np.sin(2 * np.pi * 180 * t)
# freq, Fp = fft_plot(t, signal, 'Test Signal', Frated=60, nharm=5)
