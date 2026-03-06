"""
Series Resonant Circuit with Power Control
Converted from s4.mdl to Python

Circuit: Square wave voltage source -> Series RLC circuit with power control
States: iL (inductor current), vC (capacitor voltage)

This is a simplified version focusing on the basic RLC dynamics.
The full Simulink model includes a frequency control loop to track reference power.
"""
import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt
from scipy.interpolate import interp1d

# Parameters from m4.py
R = 12                      # Resistance (Ohms)
L = 0.231e-3               # Inductance (Henry)
C = 0.1082251e-6           # Capacitance (Farad)
wo = np.sqrt(1/(L*C))      # Resonant frequency (rad/sec)
Vdc = 100                  # DC voltage magnitude (Volts)
iLo = 0                    # Initial inductor current (A)
vCo = 0                    # Initial capacitor voltage (V)
tstop = 25e-4              # Simulation stop time (sec)

# Power reference profile
Pref_time = np.array([0, 6e-4, 11e-4, 11e-4, 18e-4, 18e-4, tstop])
Pref_value = np.array([0, 600, 600, 300, 300, 600, 600])

# Solver configuration
rtol = 1e-5
atol = 1e-6

# Simplified switching frequency (constant for basic model)
# Full model would use controller to adjust this
f_switch = wo / (2 * np.pi)  # Start near resonance

def model_equations(t, y):
    """
    Series RLC circuit differential equations

    States: y[0] = iL (inductor current)
            y[1] = vC (capacitor voltage)

    Circuit equations (KVL):
    Vs = R*iL + L*diL/dt + vC
    iL = C*dvC/dt

    State equations:
    diL/dt = (Vs - vC - R*iL)/L
    dvC/dt = iL/C

    Vs is a square wave switching at frequency f_switch
    """
    iL, vC = y

    # Square wave voltage source (simplified)
    # Sign function: +Vdc when sin(wt) > 0, -Vdc when sin(wt) < 0
    Vs = Vdc * np.sign(np.sin(2 * np.pi * f_switch * t))

    # State derivatives
    diL_dt = (Vs - vC - R * iL) / L
    dvC_dt = iL / C

    return [diL_dt, dvC_dt]

def simulate_resonant():
    """Run series resonant circuit simulation"""
    # Initial conditions: [iL, vC]
    y0 = [iLo, vCo]

    # Solve ODE
    sol = solve_ivp(model_equations, [0, tstop], y0,
                    method='RK45', rtol=rtol, atol=atol,
                    dense_output=True, max_step=tstop/10000)

    # Create output array with time points
    t = sol.t
    iL = sol.y[0, :]
    vC = sol.y[1, :]

    # Calculate voltage source and power
    Vs = Vdc * np.sign(np.sin(2 * np.pi * f_switch * t))
    PR = R * iL**2  # Instantaneous power in resistor

    # Prepare output array: [time, Vs, PR, iL, vC]
    yout = np.column_stack([t, Vs, PR, iL, vC])

    return yout

def plot_results(y):
    """
    Plot series resonant circuit simulation results
    y: array with columns [time, Vs, PR, iL, vC]
    """
    fig, axes = plt.subplots(4, 1, figsize=(10, 10))

    axes[0].plot(y[:, 0], y[:, 1])
    axes[0].set_title('Excitation Voltage')
    axes[0].set_ylabel('Vs (V)')
    axes[0].grid(True)

    axes[1].plot(y[:, 0], y[:, 2])
    axes[1].set_title('Load Power')
    axes[1].set_ylabel('PR (W)')
    axes[1].grid(True)

    axes[2].plot(y[:, 0], y[:, 3])
    axes[2].set_title('RLC Current')
    axes[2].set_ylabel('iL (A)')
    axes[2].grid(True)

    axes[3].plot(y[:, 0], y[:, 4])
    axes[3].set_title('Capacitor Voltage')
    axes[3].set_xlabel('Time (sec)')
    axes[3].set_ylabel('vC (V)')
    axes[3].grid(True)

    plt.tight_layout()
    plt.show()

if __name__ == "__main__":
    print("Series Resonant Circuit Simulation")
    print(f"Parameters: R={R}Ω, L={L*1e3}mH, C={C*1e6}μF")
    print(f"Resonant frequency: wo={wo:.2f} rad/sec ({wo/(2*np.pi):.0f} Hz)")
    print(f"Switching frequency: {f_switch:.0f} Hz")
    print("Running simulation...")

    yout = simulate_resonant()

    print(f"Simulation complete. {len(yout)} time points.")
    print("\nPlotting results...")
    plot_results(yout)
