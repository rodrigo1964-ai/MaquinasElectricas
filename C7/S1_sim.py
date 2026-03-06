"""
Synchronous Machine Simulation: Synchronous generator
Converted from Simulink model: s1.mdl
Generated automatically by sync_machine_converter.py

Model: Synchronous generator
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
from m1 import *

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
    Synchronous Generator Equations in dq0 Reference Frame
    States: [δ, ψq, ψkq, ψd, ψf, ψkd, ωm]

    Where:
    - δ: rotor angle (electrical radians)
    - ψq, ψd: q-axis and d-axis stator flux linkages
    - ψkq, ψkd: q-axis and d-axis damper winding flux linkages
    - ψf: field winding flux linkage
    - ωm: rotor speed (per unit)

    The equations are:
    Stator voltage: vq = -rs*iq + wb*ψd + dψq/dt
                   vd = -rs*id - wb*ψq + dψd/dt
    Field voltage: vf = rpf*if + dψf/dt
    Damper voltages: 0 = rpkq*ikq + dψkq/dt
                     0 = rpkd*ikd + dψkd/dt
    Mechanical: 2H*dωm/dt = Tm - Te - D*ωm
    Rotor angle: dδ/dt = wb*(ωm - 1)
    """
    delta, Psiq, Psikq, Psid, Psif, Psikd, wm = y

    # Calculate currents from flux linkages using inductance matrix
    # Current-flux relationships:
    # iq = (Psiq - Psiaq) / xls, where Psiaq is air-gap flux
    # Similar for id, if, ikq, ikd

    # Air-gap flux linkages
    Psiaq = (Psiq/xls + Psikq/xplkq) / (1/xls + 1/xmq + 1/xplkq)
    Psiad = (Psid/xls + Psif/xplf + Psikd/xplkd) / (1/xls + 1/xmd + 1/xplf + 1/xplkd)

    # Or using the pre-calculated mutual inductances
    if 'xMQ' in dir():
        Psiaq = xMQ * (Psiq/xls + Psikq/xplkq)
    if 'xMD' in dir():
        Psiad = xMD * (Psid/xls + Psif/xplf + Psikd/xplkd)

    # Currents
    iq = (Psiq - Psiaq) / xls
    ikq = (Psikq - Psiaq) / xplkq
    id = (Psid - Psiad) / xls
    iif = (Psif - Psiad) / xplf
    ikd = (Psikd - Psiad) / xplkd

    # Terminal voltages from grid or inputs
    # These can be time-varying disturbances
    if 'Vm_time' in dir() and 'Vm_value' in dir():
        Vm_interp = np.interp(t, Vm_time, Vm_value)
    else:
        Vm_interp = Vm if 'Vm' in dir() else 1.0

    # Angle of bus voltage
    theta_e = thetaeo if 'thetaeo' in dir() else 0.0

    # dq voltages (rotating with rotor)
    vq = Vm_interp * np.cos(delta - theta_e)
    vd = -Vm_interp * np.sin(delta - theta_e)

    # Field voltage (excitation control)
    if 'Ex_time' in dir() and 'Ex_value' in dir():
        Ef_interp = np.interp(t, Ex_time, Ex_value)
    else:
        Ef_interp = Efo if 'Efo' in dir() else 1.0

    vf = Ef_interp

    # Mechanical torque
    if 'tmech_time' in dir() and 'tmech_value' in dir():
        Tm = np.interp(t, tmech_time, tmech_value)
    else:
        Tm = Tmech if 'Tmech' in dir() else 1.0

    # Electromagnetic torque
    Te = Psid * iq - Psiq * id

    # Derivatives
    dPsiq_dt = vq + rs * iq - wb * wm * Psid
    dPsid_dt = vd + rs * id + wb * wm * Psiq

    dPsif_dt = vf - rpf * iif
    dPsikd_dt = -rpkd * ikd
    dPsikq_dt = -rpkq * ikq

    dwm_dt = (Tm - Te - Domega * (wm - 1.0)) / (2 * H)

    ddelta_dt = wb * (wm - 1.0)

    return [ddelta_dt, dPsiq_dt, dPsikq_dt, dPsid_dt, dPsif_dt, dPsikd_dt, dwm_dt]

# Initial conditions from parameter file
# These should be calculated in the parameter file (e.g., m1.py)
delta0 = delto if 'delto' in dir() else 0.0
Psiq0 = Psiqo if 'Psiqo' in dir() else 0.0
Psikq0 = Psikqo if 'Psikqo' in dir() else 0.0
Psid0 = Psido if 'Psido' in dir() else 0.0
Psif0 = Psifo if 'Psifo' in dir() else 1.0
Psikd0 = Psikdo if 'Psikdo' in dir() else 0.0
wm0 = 1.0  # Synchronous speed in per unit

y0 = [delta0, Psiq0, Psikq0, Psid0, Psif0, Psikd0, wm0]


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
delta = y[0, :]
Psiq = y[1, :]
Psikq = y[2, :]
Psid = y[3, :]
Psif = y[4, :]
Psikd = y[5, :]
wm = y[6, :]

# Calculate currents and other quantities
Psiaq = np.zeros_like(delta)
Psiad = np.zeros_like(delta)
iq = np.zeros_like(delta)
id = np.zeros_like(delta)
iif = np.zeros_like(delta)
Te = np.zeros_like(delta)
Pe = np.zeros_like(delta)

for i in range(len(delta)):
    if 'xMQ' in dir():
        Psiaq[i] = xMQ * (Psiq[i]/xls + Psikq[i]/xplkq)
    else:
        Psiaq[i] = (Psiq[i]/xls + Psikq[i]/xplkq) / (1/xls + 1/xmq + 1/xplkq)

    if 'xMD' in dir():
        Psiad[i] = xMD * (Psid[i]/xls + Psif[i]/xplf + Psikd[i]/xplkd)
    else:
        Psiad[i] = (Psid[i]/xls + Psif[i]/xplf + Psikd[i]/xplkd) / (1/xls + 1/xmd + 1/xplf + 1/xplkd)

    iq[i] = (Psiq[i] - Psiaq[i]) / xls
    id[i] = (Psid[i] - Psiad[i]) / xls
    iif[i] = (Psif[i] - Psiad[i]) / xplf

    Te[i] = Psid[i] * iq[i] - Psiq[i] * id[i]
    Pe[i] = Te[i] * wm[i]

# Convert angles to degrees
delta_deg = np.degrees(delta)

# Plotting
fig, axes = plt.subplots(3, 3, figsize=(15, 10))
fig.suptitle(f'{description} - Simulation Results', fontsize=14, fontweight='bold')

axes[0, 0].plot(t, delta_deg, 'b-', linewidth=2)
axes[0, 0].set_ylabel('Rotor Angle δ (deg)')
axes[0, 0].set_title('Rotor Angle')
axes[0, 0].grid(True)

axes[0, 1].plot(t, wm, 'r-', linewidth=2)
axes[0, 1].set_ylabel('Speed ω (pu)')
axes[0, 1].set_title('Rotor Speed')
axes[0, 1].axhline(y=1.0, color='k', linestyle='--', alpha=0.3, label='Synchronous')
axes[0, 1].legend()
axes[0, 1].grid(True)

axes[0, 2].plot(t, iif, 'g-', linewidth=2)
axes[0, 2].set_ylabel('Field Current (pu)')
axes[0, 2].set_title('Field Current')
axes[0, 2].grid(True)

axes[1, 0].plot(t, iq, 'm-', linewidth=2, label='iq')
axes[1, 0].plot(t, id, 'c-', linewidth=2, label='id')
axes[1, 0].set_ylabel('Stator Currents (pu)')
axes[1, 0].set_title('Stator dq Currents')
axes[1, 0].legend()
axes[1, 0].grid(True)

axes[1, 1].plot(t, Te, 'k-', linewidth=2)
axes[1, 1].set_ylabel('Torque (pu)')
axes[1, 1].set_xlabel('Time (s)')
axes[1, 1].set_title('Electromagnetic Torque')
axes[1, 1].grid(True)

axes[1, 2].plot(t, Pe, 'orange', linewidth=2)
axes[1, 2].set_ylabel('Power (pu)')
axes[1, 2].set_xlabel('Time (s)')
axes[1, 2].set_title('Electrical Power')
axes[1, 2].grid(True)

axes[2, 0].plot(t, Psiq, 'b-', linewidth=2, label='ψq')
axes[2, 0].plot(t, Psid, 'r-', linewidth=2, label='ψd')
axes[2, 0].set_ylabel('Stator Flux (pu)')
axes[2, 0].set_xlabel('Time (s)')
axes[2, 0].set_title('Stator Flux Linkages')
axes[2, 0].legend()
axes[2, 0].grid(True)

axes[2, 1].plot(t, Psif, 'g-', linewidth=2)
axes[2, 1].set_ylabel('Field Flux (pu)')
axes[2, 1].set_xlabel('Time (s)')
axes[2, 1].set_title('Field Flux Linkage')
axes[2, 1].grid(True)

axes[2, 2].plot(t, Psikq, 'm-', linewidth=2, label='ψkq')
axes[2, 2].plot(t, Psikd, 'c-', linewidth=2, label='ψkd')
axes[2, 2].set_ylabel('Damper Flux (pu)')
axes[2, 2].set_xlabel('Time (s)')
axes[2, 2].set_title('Damper Flux Linkages')
axes[2, 2].legend()
axes[2, 2].grid(True)

plt.tight_layout()
plt.savefig(f'{model_name}_results.png', dpi=300, bbox_inches='tight')
print(f"Plot saved as {model_name}_results.png")
plt.show()

# Print final values
print("\nFinal Values:")
print(f"Rotor Angle: {delta_deg[-1]:.2f} degrees")
print(f"Rotor Speed: {wm[-1]:.4f} pu")
print(f"Field Current: {iif[-1]:.4f} pu")
print(f"q-axis Current: {iq[-1]:.4f} pu")
print(f"d-axis Current: {id[-1]:.4f} pu")
print(f"Electromagnetic Torque: {Te[-1]:.4f} pu")
print(f"Electrical Power: {Pe[-1]:.4f} pu")
