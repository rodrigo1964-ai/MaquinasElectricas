"""
RLC Circuit Simulation
Converted from s2.mdl to Python

Circuit: Step voltage source -> RLC series circuit
States: vC (capacitor voltage), iL (inductor current)
"""
import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt

# Parameters from m2.py
Rs = 50         # Series resistance (Ohms)
L = 0.1         # Inductance (Henry)
C = 1000e-6     # Capacitance (Farad)
VS_mag = 100    # Step voltage magnitude (Volts)
tdelay = 0.05   # Step delay time (sec)
vCo = 0         # Initial capacitor voltage (V)
iLo = 0         # Initial inductor current (A)
tstop = 0.5     # Simulation stop time (sec)

# Solver configuration
rtol = 1e-5
atol = 1e-6

def model_equations(t, y):
    """
    RLC circuit differential equations

    States: y[0] = vC (capacitor voltage)
            y[1] = iL (inductor current)

    Circuit equations (KVL):
    vS = Rs*iL + L*diL/dt + vC
    iC = C*dvC/dt = iL

    State equations:
    dvC/dt = iL/C
    diL/dt = (vS - vC - Rs*iL)/L
    """
    vC, iL = y

    # Step voltage source
    if t < tdelay:
        vS = 0
    else:
        vS = VS_mag

    # State derivatives
    dvC_dt = iL / C
    diL_dt = (vS - vC - Rs * iL) / L

    return [dvC_dt, diL_dt]

def simulate_rlc():
    """Run RLC circuit simulation"""
    # Initial conditions: [vC, iL]
    y0 = [vCo, iLo]

    # Solve ODE
    sol = solve_ivp(model_equations, [0, tstop], y0,
                    method='RK45', rtol=rtol, atol=atol,
                    dense_output=True)

    # Create output array with time points
    t = sol.t
    vC = sol.y[0, :]
    iL = sol.y[1, :]

    # Calculate source current iS
    iS = iL.copy()

    # Prepare output array: [time, iS, vC, iL]
    yout = np.column_stack([t, iS, vC, iL])

    return yout

def plot_results(y):
    """
    Plot RLC circuit simulation results
    y: array with columns [time, iS, vC, iL]
    """
    fig, axes = plt.subplots(3, 1, figsize=(10, 8))

    axes[0].plot(y[:, 0], y[:, 1])
    axes[0].set_title('Source Current')
    axes[0].set_ylabel('iS (A)')
    axes[0].grid(True)

    axes[1].plot(y[:, 0], y[:, 2])
    axes[1].set_title('Capacitor Voltage')
    axes[1].set_ylabel('vC (V)')
    axes[1].grid(True)

    axes[2].plot(y[:, 0], y[:, 3])
    axes[2].set_title('Inductor Current')
    axes[2].set_xlabel('Time (sec)')
    axes[2].set_ylabel('iL (A)')
    axes[2].grid(True)

    plt.tight_layout()
    plt.show()

if __name__ == "__main__":
    print("RLC Circuit Simulation")
    print(f"Parameters: Rs={Rs}Ω, L={L}H, C={C*1e6}μF")
    print(f"Step voltage: {VS_mag}V at t={tdelay}s")
    print("Running simulation...")

    yout = simulate_rlc()

    print(f"Simulation complete. {len(yout)} time points.")
    print("\nPlotting results...")
    plot_results(yout)
