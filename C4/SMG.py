"""
SMG.py - Magnetization curve validation model
Project 3 on magnetization curves in Chapter 4

Validates instantaneous psi vs i curve against RMS open-circuit curve.
Uses:
- Lookup table for psi vs i (from mginit.py)
- Variable amplitude sinusoidal voltage
- Butterworth low-pass filters for RMS calculation
- Inner product blocks for error calculation

Compares:
1. Error from RMS curve
2. Error from instantaneous curve
"""
import numpy as np
from scipy.integrate import solve_ivp
from scipy.interpolate import interp1d
from scipy.signal import butter, lfilter
import matplotlib.pyplot as plt


def butter_lowpass_filter(data, cutoff, fs, order=2):
    """Apply Butterworth lowpass filter."""
    nyq = 0.5 * fs
    normal_cutoff = cutoff / nyq
    b, a = butter(order, normal_cutoff, btype='low', analog=False)
    y = lfilter(b, a, data)
    return y


def simulate_magnetization_validation(params, t_stop=3.5, rtol=1e-5, atol=1e-6):
    """
    Simulate magnetization curve validation.

    Parameters:
    -----------
    params : dict
        Parameters from mginit.py including psifull, ifull, V, I curves
    t_stop : float
        Simulation stop time (should match amplitude variation period)
    rtol, atol : float
        ODE solver tolerances

    Returns:
    --------
    results : dict
        Simulation results including voltage, current, flux, and errors
    """

    # Extract parameters
    psifull = params['psifull']
    ifull = params['ifull']
    V_rms = params['V']
    I_rms = params['I']
    Vmaxrms = params['Vmaxrms']
    we = params.get('we', 377)  # Excitation frequency

    # Create interpolation functions
    # Lookup: psi vs i (instantaneous curve)
    psi_vs_i = interp1d(ifull, psifull, kind='linear',
                        bounds_error=False, fill_value='extrapolate')

    # Lookup: Open-circuit curve (V_rms vs I_rms)
    oc_curve = interp1d(I_rms, V_rms, kind='linear',
                        bounds_error=False, fill_value='extrapolate')

    # Scaled open-circuit curve (for comparison)
    psi_rms = V_rms / we  # ψ_rms ≈ V_rms / ω
    scaled_oc = interp1d(I_rms, psi_rms, kind='linear',
                         bounds_error=False, fill_value='extrapolate')

    # Time array for simulation
    dt = 1e-4  # Time step
    t = np.arange(0, t_stop, dt)
    n = len(t)

    # Voltage amplitude variation (sine wave modulation)
    v_amplitude = Vmaxrms * np.sin(np.pi * t / t_stop)

    # Sinusoidal voltage source
    v = np.sqrt(2) * v_amplitude * np.sin(we * t)

    # Calculate flux by integrating voltage
    psi = np.zeros(n)
    for i in range(1, n):
        psi[i] = psi[i-1] + v[i] * dt

    # Calculate current from instantaneous curve
    i_inst = np.zeros(n)
    for i in range(n):
        i_inst[i] = psi_vs_i(psi[i])

    # Calculate RMS values using low-pass filters
    # Butterworth LP filter approximates RMS calculation
    fs = 1 / dt
    cutoff_freq = 10  # Hz (low frequency to get smooth RMS)

    # RMS voltage and current (approximated by filtering squared values)
    v_squared = v ** 2
    i_squared = i_inst ** 2

    v_rms_filtered = np.sqrt(butter_lowpass_filter(v_squared, cutoff_freq, fs))
    i_rms_filtered = np.sqrt(butter_lowpass_filter(i_squared, cutoff_freq, fs))

    # Calculate expected values from open-circuit curve
    i_expected_from_oc = np.zeros(n)
    psi_expected_from_oc = np.zeros(n)

    for i in range(n):
        if v_rms_filtered[i] > V_rms[0]:
            # Inverse lookup: given V_rms, find I_rms
            i_expected_from_oc[i] = np.interp(v_rms_filtered[i], V_rms, I_rms)
            psi_expected_from_oc[i] = scaled_oc(i_expected_from_oc[i])

    # Calculate errors
    # Error from RMS curve
    error_rms = i_rms_filtered - i_expected_from_oc

    # Error from instantaneous curve (flux comparison)
    psi_rms_inst = np.sqrt(butter_lowpass_filter(psi**2, cutoff_freq, fs))
    error_inst = psi_rms_inst - psi_expected_from_oc

    return {
        't': t,
        'v': v,
        'v_amplitude': v_amplitude,
        'psi': psi,
        'i': i_inst,
        'v_rms': v_rms_filtered,
        'i_rms': i_rms_filtered,
        'i_expected': i_expected_from_oc,
        'psi_rms': psi_rms_inst,
        'psi_expected': psi_expected_from_oc,
        'error_rms': error_rms,
        'error_inst': error_inst
    }


def plot_magnetization_results(results, params):
    """Plot magnetization validation results."""

    t = results['t']
    V_rms = params['V']
    I_rms = params['I']
    psifull = params['psifull']
    ifull = params['ifull']

    # Figure 1: Time domain signals
    fig1, axes = plt.subplots(4, 1, figsize=(12, 10))

    axes[0].plot(t, results['v'])
    axes[0].set_ylabel('Voltage (V)')
    axes[0].set_title('Applied Voltage (Variable Amplitude)')
    axes[0].grid(True)

    axes[1].plot(t, results['psi'])
    axes[1].set_ylabel('Flux Linkage (Wb-turns)')
    axes[1].set_title('Flux Linkage ψ')
    axes[1].grid(True)

    axes[2].plot(t, results['i'])
    axes[2].set_ylabel('Current (A)')
    axes[2].set_title('Instantaneous Current')
    axes[2].grid(True)

    axes[3].plot(t, results['v_amplitude'])
    axes[3].set_ylabel('V_rms (V)')
    axes[3].set_xlabel('Time (s)')
    axes[3].set_title('Voltage Amplitude Variation')
    axes[3].grid(True)

    plt.tight_layout()

    # Figure 2: Error plots
    fig2, axes = plt.subplots(2, 1, figsize=(12, 8))

    axes[0].plot(t, results['error_rms'] * 1000)  # Convert to mA
    axes[0].set_ylabel('Current Error (mA)')
    axes[0].set_title('Error from RMS Open-Circuit Curve')
    axes[0].grid(True)

    axes[1].plot(t, results['error_inst'])
    axes[1].set_ylabel('Flux Error (Wb-turns)')
    axes[1].set_xlabel('Time (s)')
    axes[1].set_title('Error from Instantaneous Curve')
    axes[1].grid(True)

    plt.tight_layout()

    # Figure 3: Magnetization curves comparison
    fig3, axes = plt.subplots(1, 2, figsize=(14, 6))

    # RMS curve
    axes[0].plot(I_rms, V_rms, 'b-', linewidth=2, label='Open-circuit data')
    axes[0].plot(results['i_rms'][::100], results['v_rms'][::100],
                 'ro', markersize=3, label='Simulated RMS')
    axes[0].set_xlabel('I_rms (A)')
    axes[0].set_ylabel('V_rms (V)')
    axes[0].set_title('RMS Magnetization Curve')
    axes[0].legend()
    axes[0].grid(True)

    # Instantaneous curve
    axes[1].plot(ifull, psifull, 'b-', linewidth=2, label='Instantaneous curve')
    axes[1].plot(results['i'][::100], results['psi'][::100],
                 'ro', markersize=1, alpha=0.5, label='Simulated')
    axes[1].set_xlabel('Current i (A)')
    axes[1].set_ylabel('Flux Linkage ψ (Wb-turns)')
    axes[1].set_title('Instantaneous Magnetization Curve')
    axes[1].legend()
    axes[1].grid(True)

    plt.tight_layout()
    plt.show()


if __name__ == '__main__':
    # Load parameters from mginit.py
    import sys
    sys.path.insert(0, '/home/rodo/Maquinas/C4')
    from mginit import (V, I, psifull, ifull, Vmaxrms, tstop)

    params = {
        'V': V,
        'I': I,
        'psifull': psifull,
        'ifull': ifull,
        'Vmaxrms': Vmaxrms,
        'we': 377  # 60 Hz * 2π
    }

    print("\n=== Magnetization Curve Validation (SMG) ===")
    print(f"Maximum RMS voltage: {Vmaxrms:.2f} V")
    print(f"Simulation time: {tstop:.2f} s")
    print("\nSimulating...")

    # Simulate
    results = simulate_magnetization_validation(params, t_stop=tstop)

    # Calculate statistics
    max_error_rms = np.max(np.abs(results['error_rms'])) * 1000  # mA
    max_error_inst = np.max(np.abs(results['error_inst']))

    print(f"\nValidation Results:")
    print(f"  Max error from RMS curve: {max_error_rms:.3f} mA")
    print(f"  Max error from instantaneous curve: {max_error_inst:.4f} Wb-turns")
    print(f"  Mean error from RMS curve: {np.mean(np.abs(results['error_rms']))*1000:.3f} mA")
    print(f"  Mean error from instantaneous curve: {np.mean(np.abs(results['error_inst'])):.4f} Wb-turns")

    # Plot results
    plot_magnetization_results(results, params)

    print("\nSimulation complete!")
