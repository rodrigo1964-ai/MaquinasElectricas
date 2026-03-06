"""
VCO (Voltage Controlled Oscillator) Circuit Simulation
Converted from s1.mdl to Python

System: Two coupled integrators forming an oscillator
States: y1, y2
Equations: dy1/dt = w*y2, dy2/dt = -w*y1
"""
import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt

# Parameters
w = 377          # Angular frequency (rad/sec) - 60 Hz oscillation
y1_0 = 5         # Initial condition for y1
y2_0 = 0         # Initial condition for y2
t_stop = 0.05    # Simulation stop time (sec)

# Solver configuration
rtol = 1e-5
atol = 1e-6

def model_equations(t, y):
    """
    VCO differential equations

    States: y[0] = y1 (first state)
            y[1] = y2 (second state)

    The circuit implements a simple harmonic oscillator:
    dy1/dt = w * y2
    dy2/dt = -w * y1

    This creates a circular trajectory in the y1-y2 phase plane.
    """
    y1, y2 = y

    # State derivatives
    dy1_dt = w * y2
    dy2_dt = -w * y1

    return [dy1_dt, dy2_dt]

def simulate_vco():
    """Run VCO simulation"""
    # Initial conditions: [y1, y2]
    y0 = [y1_0, y2_0]

    # Solve ODE
    sol = solve_ivp(model_equations, [0, t_stop], y0,
                    method='RK45', rtol=rtol, atol=atol,
                    dense_output=True)

    # Create output array with time points
    t = sol.t
    y1 = sol.y[0, :]
    y2 = sol.y[1, :]

    # Prepare output array: [time, y1, y2]
    yout = np.column_stack([t, y1, y2])

    return yout

def plot_results(y):
    """
    Plot VCO simulation results
    y: array with columns [time, y1, y2]
    """
    fig, axes = plt.subplots(2, 1, figsize=(10, 8))

    axes[0].plot(y[:, 0], y[:, 1], '-', label='y1')
    axes[0].plot(y[:, 0], y[:, 2], '-.', label='y2')
    axes[0].set_title('VCO Output Signals')
    axes[0].set_xlabel('Time (sec)')
    axes[0].set_ylabel('y1 and y2')
    axes[0].legend()
    axes[0].grid(True)

    # Phase plane plot
    axes[1].plot(y[:, 1], y[:, 2], '-')
    axes[1].set_title('Phase Plane (y1 vs y2)')
    axes[1].set_xlabel('y1')
    axes[1].set_ylabel('y2')
    axes[1].axis('equal')
    axes[1].grid(True)

    plt.tight_layout()
    plt.show()

if __name__ == "__main__":
    print("VCO (Voltage Controlled Oscillator) Simulation")
    print(f"Parameters: w={w} rad/sec ({w/(2*np.pi):.1f} Hz)")
    print(f"Initial conditions: y1={y1_0}, y2={y2_0}")
    print("Running simulation...")

    yout = simulate_vco()

    print(f"Simulation complete. {len(yout)} time points.")
    print("\nPlotting results...")
    plot_results(yout)
