"""
Synchronous Machine Simulation: Permanent magnet motor
Converted from Simulink model: s4.mdl
Generated automatically by sync_machine_converter.py

Model: Permanent magnet motor
Reference Frame: Rotor dq0 (d-axis lags q-axis by 90°)
"""

import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt
import sys
from pathlib import Path

# Add C7 directory to path to import parameters
sys.path.insert(0, str(Path(__file__).parent))

# Import machine parameters and setup
from m4 import *

# Use parameters from m-file
# The parameter file should define:
# - Machine parameters: rs, xd, xq, xls, xmd, xmq, etc.
# - Derived parameters: xplf, xplkd, xplkq, rpf, rpkd, rpkq
# - Initial conditions: delto, Psiqo, Psido, Psifo, Psikqo, Psikdo
# - Operating point: Vqo, Vdo, Iqo, Ido, Efo, Tmech

# Simulation parameters
t_stop_val = tstop
if isinstance(t_stop_val, str):
    t_stop_val = eval(t_stop_val) if t_stop_val in dir() else 5.0

rtol = 5e-6
atol = 1e-6


def sync_machine_equations(t, y):
    """
    Permanent Magnet Synchronous Motor Equations (dq0 frame)
    States: [id, iq, ωm, θe]

    Voltage equations:
    vd = rs*id + Ld*did/dt - ωe*Lq*iq
    vq = rs*iq + Lq*diq/dt + ωe*(Ld*id + λpm)

    Torque: Te = (3/2)*P/2*(λpm*iq + (Ld-Lq)*id*iq)
    Mechanical: J*dωm/dt = Te - TL - D*ωm
    """
    id, iq, wm, theta_e = y

    # Electrical angular velocity
    we = wm * (Poles / 2)

    # PM flux linkage (from parameters or rated conditions)
    lambda_pm = Efo / wb if 'Efo' in dir() else 1.0

    # Inductances
    Ld = xd / wb if 'xd' in dir() else 1.0
    Lq = xq / wb if 'xq' in dir() else 1.0

    # Applied voltages (from input functions or constants)
    # Vd, Vq should be defined based on control or grid connection
    if t < 0.2:
        vd = Vdo if 'Vdo' in dir() else 0
        vq = Vqo if 'Vqo' in dir() else 1.0
    else:
        vd = Vdo if 'Vdo' in dir() else 0
        vq = Vqo if 'Vqo' in dir() else 1.0

    # Current derivatives
    did_dt = (vd - rs * id + we * Lq * iq) / Ld
    diq_dt = (vq - rs * iq - we * (Ld * id + lambda_pm)) / Lq

    # Electromagnetic torque
    Te = (3/2) * (Poles/2) * (lambda_pm * iq + (Ld - Lq) * id * iq)

    # Mechanical load torque
    TL = Tmech if 'Tmech' in dir() else 0

    # Speed derivative
    dwm_dt = (Te - TL - Domega * wm) / (2 * H)

    # Angle derivative
    dtheta_dt = we

    return [did_dt, diq_dt, dwm_dt, dtheta_dt]

# Initial conditions for PM motor
id0 = Ido if 'Ido' in dir() else 0.0
iq0 = Iqo if 'Iqo' in dir() else 0.0
wm0 = 1.0  # Per unit speed
theta_e0 = delto if 'delto' in dir() else 0.0
y0 = [id0, iq0, wm0, theta_e0]


# Event function to detect instability
def unstable_event(t, y):
    """Stop if angle difference becomes too large (loss of synchronism)"""
    delta = y[0]
    return np.abs(delta) - np.pi  # Stop if delta > 180 degrees

unstable_event.terminal = True
unstable_event.direction = 1

# Solve the differential equations
print(f"Simulating {description}...")
print(f"Time span: 0 to {t_stop_val} seconds")
print(f"Initial conditions: {y0}")

sol = solve_ivp(
    sync_machine_equations,
    [0, t_stop_val],
    y0,
    method='RK45',
    rtol=rtol,
    atol=atol,
    dense_output=True,
    max_step=5e-3,
    events=unstable_event
)

if not sol.success:
    print(f"Warning: Solver finished with status: {sol.message}")
else:
    print(f"Simulation completed successfully!")
    print(f"Number of time steps: {len(sol.t)}")

# Extract results
t = sol.t
y = sol.y


# Extract states
id = y[0, :]
iq = y[1, :]
wm = y[2, :]
theta_e = y[3, :]

# Calculate additional quantities
we = wm * (Poles / 2)
lambda_pm = Efo / wb if 'Efo' in dir() else 1.0
Ld = xd / wb if 'xd' in dir() else 1.0
Lq = xq / wb if 'xq' in dir() else 1.0

Te = (3/2) * (Poles/2) * (lambda_pm * iq + (Ld - Lq) * id * iq)
Pe = Te * wm

# Plotting
fig, axes = plt.subplots(2, 3, figsize=(15, 8))
fig.suptitle(f'{description} - Simulation Results', fontsize=14, fontweight='bold')

axes[0, 0].plot(t, id, 'b-', linewidth=2)
axes[0, 0].set_ylabel('d-axis Current (pu)')
axes[0, 0].set_title('d-axis Current')
axes[0, 0].grid(True)

axes[0, 1].plot(t, iq, 'r-', linewidth=2)
axes[0, 1].set_ylabel('q-axis Current (pu)')
axes[0, 1].set_title('q-axis Current')
axes[0, 1].grid(True)

axes[0, 2].plot(t, wm, 'g-', linewidth=2)
axes[0, 2].set_ylabel('Speed (pu)')
axes[0, 2].set_title('Rotor Speed')
axes[0, 2].axhline(y=1.0, color='k', linestyle='--', alpha=0.3)
axes[0, 2].grid(True)

axes[1, 0].plot(t, Te, 'k-', linewidth=2)
axes[1, 0].set_ylabel('Torque (pu)')
axes[1, 0].set_xlabel('Time (s)')
axes[1, 0].set_title('Electromagnetic Torque')
axes[1, 0].grid(True)

axes[1, 1].plot(t, Pe, 'm-', linewidth=2)
axes[1, 1].set_ylabel('Power (pu)')
axes[1, 1].set_xlabel('Time (s)')
axes[1, 1].set_title('Electrical Power')
axes[1, 1].grid(True)

axes[1, 2].plot(t, np.degrees(theta_e), 'c-', linewidth=2)
axes[1, 2].set_ylabel('Angle (degrees)')
axes[1, 2].set_xlabel('Time (s)')
axes[1, 2].set_title('Electrical Angle')
axes[1, 2].grid(True)

plt.tight_layout()
plt.savefig(f'{model_name}_results.png', dpi=300, bbox_inches='tight')
print(f"Plot saved as {model_name}_results.png")
plt.show()
