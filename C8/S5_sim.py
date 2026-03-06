"""
DC Machine Simulation: Series motor
Converted from Simulink model: s5.mdl
Generated automatically by dc_machine_converter.py

Model: Series motor
Type: Series Motor
"""

import numpy as np
from scipy.integrate import solve_ivp
from scipy.interpolate import interp1d
import matplotlib.pyplot as plt
import sys
from pathlib import Path

# Add C8 directory to path to import parameters
sys.path.insert(0, str(Path(__file__).parent))

# Import machine parameters
from m5 import *

# Simulation parameters
t_stop = 35
rtol = 1e-6
atol = 1e-6


# For motors without magnetization curve, use linear approximation
# or constant field excitation
def get_Ea(If_or_flux, wm):
    """Calculate back-EMF: Ea = Kf * flux * wm"""
    # For separately excited: flux proportional to If
    # For series: If = Ia
    return If_or_flux * wm


def dc_machine_equations(t, y):
    """
    DC Series Motor Equations
    States: [Ia, wm]

    In series motor: If = Ia (field in series with armature)

    Armature circuit: (Laq + Lf) * dIa/dt = Va - Ea - (Ra + Rf)*Ia
    Mechanical: J * dwm/dt = Tem - Tload - D*wm

    Where:
    - Ea = Ka * Ia * wm (flux proportional to Ia)
    - Tem = Ka * Ia^2 (torque proportional to Ia^2)
    """
    Ia, wm = y

    # For series motor, flux proportional to Ia
    # Torque constant approximation
    Ka = Vrated / (Iarated * wmrated)

    # Back-EMF (proportional to Ia*wm for series motor)
    Ea = Ka * Ia * wm

    # Applied voltage
    Va = Vrated

    # Total inductance (armature + field in series)
    Ltotal = Laq + Lf if 'Lf' in dir() else Laq

    # Total resistance
    Rtotal = Ra + Rf if 'Rf' in dir() else Ra

    # Armature/field current derivative
    dIa_dt = (Va - Ea - Rtotal * Ia) / Ltotal

    # Developed torque (proportional to Ia^2)
    Tem = Ka * Ia * Ia

    # Mechanical load
    Tload = 0  # No load or constant load

    # Speed derivative
    dwm_dt = (Tem - Tload - D * wm) / J

    return [dIa_dt, dwm_dt]

# Initial conditions
Ia0 = 0.0
wm0 = 0.01  # Small initial speed to avoid division issues
y0 = [Ia0, wm0]


# Solve the differential equations
print(f"Simulating {description}...")
print(f"Time span: 0 to {t_stop} seconds")
print(f"Initial conditions: {y0}")

sol = solve_ivp(
    dc_machine_equations,
    [0, t_stop],
    y0,
    method='RK45',
    rtol=rtol,
    atol=atol,
    dense_output=True,
    max_step=1e-3
)

if not sol.success:
    print(f"Warning: Solver finished with status: {sol.message}")
else:
    print(f"Simulation completed successfully!")
    print(f"Number of time steps: {len(sol.t)}")

# Extract results
t = sol.t
y = sol.y


# Calculate additional variables for plotting
Ia = y[0, :]
wm = y[1, :]
wm_rpm = wm * 60 / (2 * np.pi)

# Back-EMF and torque calculation
Ka = Vrated / wmrated

Ea = Ka * Ia * wm
Tem = Ka * Ia * Ia

# Plotting
fig, axes = plt.subplots(2, 2, figsize=(12, 8))
fig.suptitle(f'{description} - Simulation Results', fontsize=14, fontweight='bold')

axes[0, 0].plot(t, Ia, 'r-', linewidth=2)
axes[0, 0].set_ylabel('Armature Current Ia (A)')
axes[0, 0].set_title('Armature Current')
axes[0, 0].grid(True)
axes[0, 0].axhline(y=Iarated, color='r', linestyle='--', label=f'Rated: {Iarated:.1f}A')
axes[0, 0].legend()

axes[0, 1].plot(t, wm_rpm, 'b-', linewidth=2)
axes[0, 1].set_ylabel('Speed (RPM)')
axes[0, 1].set_title('Rotor Speed')
axes[0, 1].grid(True)
if 'wmrated' in dir():
    axes[0, 1].axhline(y=wmrated*60/(2*np.pi), color='b', linestyle='--',
                       label=f'Rated: {wmrated*60/(2*np.pi):.0f} RPM')
    axes[0, 1].legend()

axes[1, 0].plot(t, Ea, 'g-', linewidth=2)
axes[1, 0].set_ylabel('Back-EMF Ea (V)')
axes[1, 0].set_xlabel('Time (s)')
axes[1, 0].set_title('Back-EMF')
axes[1, 0].grid(True)

axes[1, 1].plot(t, Tem, 'k-', linewidth=2)
axes[1, 1].set_ylabel('Torque Tem (Nm)')
axes[1, 1].set_xlabel('Time (s)')
axes[1, 1].set_title('Developed Torque')
axes[1, 1].grid(True)
if 'Trated' in dir():
    axes[1, 1].axhline(y=Trated, color='k', linestyle='--',
                       label=f'Rated: {Trated:.1f} Nm')
    axes[1, 1].legend()

plt.tight_layout()
plt.savefig(f'{model_name}_results.png', dpi=300, bbox_inches='tight')
print(f"Plot saved as {model_name}_results.png")
plt.show()

# Print final values
print("\nFinal Values:")
print(f"Armature Current: {Ia[-1]:.4f} A")
print(f"Speed: {wm_rpm[-1]:.2f} RPM ({wm[-1]:.4f} rad/s)")
print(f"Back-EMF: {Ea[-1]:.4f} V")
print(f"Developed Torque: {Tem[-1]:.4f} Nm")
print(f"Mechanical Power: {(Tem[-1] * wm[-1]):.2f} W")
