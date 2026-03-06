"""
RL Circuit with AC Source Simulation
Converted from s3.mdl to Python

Circuit: AC voltage source -> RL series circuit
State: iL (inductor current)
"""
import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt

# Parameters from m3.py
R = 0.4          # Resistance (Ohms)
L = 0.04         # Inductance (Henry)
we = 314         # Excitation frequency (rad/sec) - approximately 50 Hz
Vac_mag = 100    # AC voltage magnitude (Volts)
iLo = 0          # Initial inductor current (A)
tstop = 0.5      # Simulation stop time (sec)

# Solver configuration
rtol = 1e-5
atol = 1e-6

def model_equations(t, y):
    """
    RL circuit differential equation

    State: y[0] = iL (inductor current)

    Circuit equation (KVL):
    Vac = R*iL + L*diL/dt

    where: Vac = Vac_mag * sin(we*t)

    State equation:
    diL/dt = (Vac - R*iL)/L
    """
    iL = y[0]

    # AC voltage source
    Vac = Vac_mag * np.sin(we * t)

    # State derivative
    diL_dt = (Vac - R * iL) / L

    return [diL_dt]

def simulate_rl():
    """Run RL circuit simulation"""
    # Initial condition: [iL]
    y0 = [iLo]

    # Solve ODE
    sol = solve_ivp(model_equations, [0, tstop], y0,
                    method='RK45', rtol=rtol, atol=atol,
                    dense_output=True)

    # Create output array with time points
    t = sol.t
    iL = sol.y[0, :]

    # Calculate AC voltage at each time point
    Vac = Vac_mag * np.sin(we * t)

    # Prepare output array: [time, Vac, iL]
    yout = np.column_stack([t, Vac, iL])

    return yout

def plot_results(y):
    """
    Plot RL circuit simulation results
    y: array with columns [time, Vac, iL]
    """
    fig, axes = plt.subplots(2, 1, figsize=(10, 6))

    axes[0].plot(y[:, 0], y[:, 1])
    axes[0].set_title('AC Excitation Voltage')
    axes[0].set_ylabel('Vac (V)')
    axes[0].grid(True)

    axes[1].plot(y[:, 0], y[:, 2])
    axes[1].set_title('Mesh Current')
    axes[1].set_xlabel('Time (sec)')
    axes[1].set_ylabel('i (A)')
    axes[1].grid(True)

    plt.tight_layout()
    plt.show()

if __name__ == "__main__":
    print("RL Circuit with AC Source Simulation")
    print(f"Parameters: R={R}Ω, L={L}H")
    print(f"AC source: {Vac_mag}V at {we/(2*np.pi):.1f} Hz")
    print("Running simulation...")

    yout = simulate_rl()

    print(f"Simulation complete. {len(yout)} time points.")
    print("\nPlotting results...")
    plot_results(yout)
