"""
DC Machine Simulation: Shunt generator
Converted from Simulink model: s1.mdl
Generated automatically by dc_machine_converter.py

Model: Shunt generator
Type: Shunt Generator
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
from m1 import *

# Simulation parameters
t_stop = 2
rtol = 1e-6
atol = 1e-6


# Create magnetization curve interpolator
# Ea = f(If) at rated speed wmo
mag_curve = interp1d(SHIP1, SHVP1, kind='cubic', fill_value='extrapolate')

def get_Ea(If, wm):
    """Calculate back-EMF from magnetization curve scaled by speed"""
    Ea_at_wmo = mag_curve(If)
    Ea = Ea_at_wmo * (wm / wmo)
    return Ea


def dc_machine_equations(t, y):
    """
    DC Shunt Generator Equations
    States: [If, Ia]

    Field circuit: Lf * dIf/dt = Vf - Rf*If
    Armature circuit: Laq * dIa/dt = Ea - Ra*Ia - Va

    Where:
    - Ea from magnetization curve scaled by speed
    - Va = terminal voltage across load
    - Vf = Ea - (Rf + Rrh)*If (self-excited)
    """
    If, Ia = y

    # Assume constant speed for generator
    wm = wmrated

    # Get back-EMF from magnetization curve
    Ea = get_Ea(If, wm)

    # Terminal voltage (voltage across load)
    Va = Ea - Ra * Ia

    # Field voltage (self-excited: field connected across armature)
    Vf = Va

    # Field current derivative
    dIf_dt = (Vf - (Rf + Rrh) * If) / Lf

    # Armature current derivative
    # Load current: Il = Va / Rload
    dIa_dt = (Ea - Ra * Ia - Va) / Laq

    # Developed torque
    Tem = Ea * Ia / wm  # Power balance: Tem*wm = Ea*Ia

    return [dIf_dt, dIa_dt]

# Initial conditions
If0 = 0.001  # Small initial field current to start self-excitation
Ia0 = 0.0
y0 = [If0, Ia0]


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
If = y[0, :]
Ia = y[1, :]
Ea = np.array([get_Ea(If[i], wmrated) for i in range(len(If))])
Va = Ea - Ra * Ia
Tem = Ea * Ia / wmrated

# Plotting
fig, axes = plt.subplots(3, 2, figsize=(12, 10))
fig.suptitle(f'{description} - Simulation Results', fontsize=14, fontweight='bold')

axes[0, 0].plot(t, If, 'b-', linewidth=2)
axes[0, 0].set_ylabel('Field Current If (A)')
axes[0, 0].set_title('Field Current')
axes[0, 0].grid(True)

axes[0, 1].plot(t, Ea, 'g-', linewidth=2)
axes[0, 1].set_ylabel('Back-EMF Ea (V)')
axes[0, 1].set_title('Internal Voltage')
axes[0, 1].grid(True)

axes[1, 0].plot(t, Ia, 'r-', linewidth=2)
axes[1, 0].set_ylabel('Armature Current Ia (A)')
axes[1, 0].set_title('Armature Current')
axes[1, 0].grid(True)

axes[1, 1].plot(t, Va, 'm-', linewidth=2)
axes[1, 1].set_ylabel('Terminal Voltage Va (V)')
axes[1, 1].set_title('Terminal Voltage')
axes[1, 1].grid(True)

axes[2, 0].plot(t, Tem, 'k-', linewidth=2)
axes[2, 0].set_ylabel('Torque Tem (Nm)')
axes[2, 0].set_xlabel('Time (s)')
axes[2, 0].set_title('Developed Torque')
axes[2, 0].grid(True)

axes[2, 1].plot(t, Ea * Ia, 'c-', linewidth=2)
axes[2, 1].set_ylabel('Power (W)')
axes[2, 1].set_xlabel('Time (s)')
axes[2, 1].set_title('Developed Power')
axes[2, 1].grid(True)

plt.tight_layout()
plt.savefig(f'{model_name}_results.png', dpi=300, bbox_inches='tight')
print(f"Plot saved as {model_name}_results.png")
plt.show()

# Print final values
print("\nFinal Values:")
print(f"Field Current: {If[-1]:.4f} A")
print(f"Armature Current: {Ia[-1]:.4f} A")
print(f"Terminal Voltage: {Va[-1]:.4f} V")
print(f"Back-EMF: {Ea[-1]:.4f} V")
print(f"Developed Torque: {Tem[-1]:.4f} Nm")
print(f"Output Power: {(Va[-1] * Ia[-1]):.2f} W")
