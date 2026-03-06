"""
Distributed Transmission Line with Circuit Breaker Switching
Converted from s2.mdl to Python

System: AC source -> Circuit breaker -> Distributed line -> RL load
Models: Transmission line with delay and attenuation
        Circuit breaker with switching logic

This is a simplified version. The full Simulink model includes
complex breaker dynamics and control logic.
"""
import numpy as np
from scipy.integrate import solve_ivp
from scipy.interpolate import interp1d
import matplotlib.pyplot as plt

# Parameters from m2.py
Vrated = 500e3              # Rated line-to-line voltage (V)
Epk = Vrated * np.sqrt(2/3) # Peak phase voltage (V)
we = 2 * np.pi * 60         # Angular frequency (rad/sec) - 60 Hz
Te = 1 / 60                 # Period (sec)
Ls = 0.1                    # Source inductance (H)
tstop = 15 * Te             # Simulation time (sec)

# Distributed line parameters
d = 100                     # Line length (miles)
R_line = 0.15               # Resistance (Ohm/mile)
L_line = 2.96e-3            # Inductance (H/mile)
C_line = 0.017e-6           # Capacitance (F/mile)
Zc = np.sqrt(L_line / C_line)  # Characteristic impedance (Ohm)
tdelay = d * np.sqrt(L_line * C_line)  # Propagation delay (sec)
atten = np.exp(-(R_line/2) * np.sqrt(C_line/L_line) * d)  # Attenuation

# Load parameters
SL = 30e6 * (0.8 + 1j*0.6)  # Load power (VA) at 0.8 pf
ZL = Vrated**2 / np.conj(SL)  # Load impedance (Ohm)
RL = np.real(ZL)            # Load resistance (Ohm)
LL = np.imag(ZL) / we       # Load inductance (H)

# Breaker parameters
tc = Te                     # Closing time (1 cycle)
to = Te                     # Opening time (1 cycle)
Rc = 1000                   # Closing resistance (Ohm)
Ro = 1000                   # Opening resistance (Ohm)

# Solver configuration
rtol = 1e-5
atol = 1e-5

print(f"Characteristic impedance Zc = {Zc:.2f} Ω")
print(f"Propagation delay = {tdelay:.6f} sec")
print(f"Attenuation = {atten:.6f}")
print(f"Load: ZL = {abs(ZL):.2f} Ω, RL = {RL:.2f} Ω, LL = {LL:.6f} H")

# Breaker switching schedule
t_close = 2 * Te            # Close breaker at t=2 cycles
t_open = 10 * Te            # Open breaker at t=10 cycles

def model_equations(t, y):
    """
    Transmission line with RL load differential equations

    State: y[0] = iR (load current)

    Simplified model without full breaker dynamics:
    - Source voltage: e = Epk*sin(we*t)
    - Transmission line modeled as delayed/attenuated voltage
    - Load: RL-LL series circuit

    Load equation:
    VR = RL*iR + LL*diR/dt

    where VR is the receiving-end voltage (delayed/attenuated from source)
    """
    iR = y[0]

    # Source voltage
    e = Epk * np.sin(we * t)

    # Breaker state (simplified)
    if t < t_close:
        breaker_closed = False
    elif t < t_open:
        breaker_closed = True
    else:
        breaker_closed = False

    # Voltage at receiving end (simplified transmission line model)
    # Includes propagation delay and attenuation
    if breaker_closed and t > tdelay:
        # Delayed and attenuated source voltage
        VR = atten * Epk * np.sin(we * (t - tdelay))
    else:
        VR = 0

    # Load current derivative
    diR_dt = (VR - RL * iR) / LL

    return [diR_dt]

def simulate_transmission_line():
    """Run transmission line simulation"""
    # Initial condition: [iR]
    y0 = [0]

    # Solve ODE
    sol = solve_ivp(model_equations, [0, tstop], y0,
                    method='RK45', rtol=rtol, atol=atol,
                    dense_output=True, max_step=tstop/10000)

    # Create output array with time points
    t = sol.t
    iR = sol.y[0, :]

    # Calculate other quantities
    e = Epk * np.sin(we * t)

    # Sending-end voltage (simplified)
    VS = np.zeros_like(t)
    VR = np.zeros_like(t)
    IS = np.zeros_like(t)
    Vb = np.zeros_like(t)  # Breaker voltage

    for i, ti in enumerate(t):
        if ti < t_close:
            breaker_closed = False
        elif ti < t_open:
            breaker_closed = True
        else:
            breaker_closed = False

        if breaker_closed and ti > tdelay:
            VR[i] = atten * Epk * np.sin(we * (ti - tdelay))
            VS[i] = VR[i] / atten  # Approximate
            IS[i] = iR[i]  # Approximate
            Vb[i] = 0  # Breaker closed
        else:
            VR[i] = RL * iR[i]  # Voltage across load
            VS[i] = 0
            IS[i] = 0
            Vb[i] = e[i]  # Full voltage across breaker

    # Prepare output array: [time, e, Vb, IS, VS, VR, IR]
    yout = np.column_stack([t, e, Vb, IS, VS, VR, iR])

    return yout

def plot_results(y):
    """
    Plot transmission line simulation results
    y: array with columns [time, e, Vb, IS, VS, VR, IR]
    """
    fig1, axes1 = plt.subplots(3, 1, figsize=(10, 10))

    axes1[0].plot(y[:, 0], y[:, 1], '-')
    axes1[0].set_ylabel('e (V)')
    axes1[0].set_title('Source Voltage')
    axes1[0].grid(True)

    axes1[1].plot(y[:, 0], y[:, 2], '-')
    axes1[1].set_ylabel('Vb (V)')
    axes1[1].set_title('Breaker Voltage')
    axes1[1].grid(True)

    axes1[2].plot(y[:, 0], y[:, 3], '-')
    axes1[2].set_ylabel('IS (A)')
    axes1[2].set_xlabel('Time (sec)')
    axes1[2].set_title('Sending End Current')
    axes1[2].grid(True)

    plt.tight_layout()

    fig2, axes2 = plt.subplots(3, 1, figsize=(10, 10))

    axes2[0].plot(y[:, 0], y[:, 4], '-')
    axes2[0].set_ylabel('VS (V)')
    axes2[0].set_title('Sending End Voltage')
    axes2[0].grid(True)

    axes2[1].plot(y[:, 0], y[:, 6], '-')
    axes2[1].set_ylabel('IR (A)')
    axes2[1].set_title('Receiving End Current')
    axes2[1].grid(True)

    axes2[2].plot(y[:, 0], y[:, 5], '-')
    axes2[2].set_ylabel('VR (V)')
    axes2[2].set_xlabel('Time (sec)')
    axes2[2].set_title('Load Terminal Voltage')
    axes2[2].grid(True)

    plt.tight_layout()
    plt.show()

if __name__ == "__main__":
    print("\nDistributed Transmission Line with Switching Simulation")
    print(f"Breaker closes at t={t_close:.4f} sec")
    print(f"Breaker opens at t={t_open:.4f} sec")
    print("Running simulation...")

    yout = simulate_transmission_line()

    print(f"Simulation complete. {len(yout)} time points.")
    print("\nPlotting results...")
    plot_results(yout)
