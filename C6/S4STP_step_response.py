"""
Induction Machine Step Response in Synchronous Reference Frame
Converted from S4STP.MDL - Step response with voltage change
"""
import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt
import sys
sys.path.append('/home/rodo/Maquinas/C6')
from p20hp import *

# Simulation parameters
tstop = 1.2  # Simulation stop time

# Initial conditions - steady state at rated conditions
wrbywbo = srated  # Initial slip = rated slip

# Steady-state flux linkages (synchronous frame, d-axis aligned with voltage)
Psidso = Vm / wb * 0.95
Psiqso = 0.0
Psipdro = Psidso * 0.9
Psipqro = 0.0

# States: [psi_qs^e, psi_ds^e, psi_qr'^e, psi_dr'^e, wr/wb]
y0 = np.array([Psiqso, Psidso, Psipqro, Psipdro, wrbywbo])


def voltage_input(t):
    """
    Step voltage input as defined in S4STP.MDL
    Voltage steps up at t=1.0s
    """
    if t < 1.0:
        vqse = Vm  # Initial voltage
    else:
        vqse = Vm + 1.0  # Step increase of 1V
    vdse = 0.0  # Ground (no d-axis voltage)
    return vqse, vdse


def induction_machine_step(t, y):
    """
    Induction machine model in synchronous reference frame
    For step response analysis

    States:
        y[0] = psi_qs^e  : q-axis stator flux linkage (synchronous frame)
        y[1] = psi_ds^e  : d-axis stator flux linkage (synchronous frame)
        y[2] = psi_qr'^e : q-axis rotor flux linkage (synchronous frame, referred)
        y[3] = psi_dr'^e : d-axis rotor flux linkage (synchronous frame, referred)
        y[4] = wr/wb     : normalized rotor speed
    """
    psi_qse, psi_dse, psi_qre, psi_dre, wr_wb = y

    # Applied voltages in synchronous frame
    vqse, vdse = voltage_input(t)

    # Magnetizing flux linkages
    psi_mqe = xM * (psi_qse / xls + psi_qre / xplr)
    psi_mde = xM * (psi_dse / xls + psi_dre / xplr)

    # Stator currents
    iqse = (psi_qse - psi_mqe) / xls
    idse = (psi_dse - psi_mde) / xls

    # Rotor currents (referred to stator)
    iqre = (psi_qre - psi_mqe) / xplr
    idre = (psi_dre - psi_mde) / xplr

    # Flux linkage derivatives - Q-axis stator
    dpsi_qse_dt = wb * (psi_mqe + (we / wb) * psi_dse + (rs / xls) * (vqse - psi_qse))

    # Flux linkage derivatives - D-axis stator
    dpsi_dse_dt = wb * (psi_mde - (we / wb) * psi_qse + (rs / xls) * (vdse - psi_dse))

    # Flux linkage derivatives - Q-axis rotor
    speed_coupling_q = (wr_wb * wbm / wb - we / wb) * psi_dre
    dpsi_qre_dt = wb * (speed_coupling_q + (rpr / xplr) * (psi_mqe - psi_qre))

    # Flux linkage derivatives - D-axis rotor
    speed_coupling_d = -(wr_wb * wbm / wb - we / wb) * psi_qre
    dpsi_dre_dt = wb * (speed_coupling_d + (rpr / xplr) * (psi_mde - psi_dre))

    # Electromagnetic torque
    Te = Tfactor * (psi_qse * idse - psi_dse * iqse)

    # Mechanical load torque (constant at base torque)
    Tmech = -Tb

    # Rotor speed derivative
    dwr_wb_dt = (Te - Tmech) / (2 * H * wb)

    return [dpsi_qse_dt, dpsi_dse_dt, dpsi_qre_dt, dpsi_dre_dt, dwr_wb_dt]


# Solve the differential equations
print("Starting simulation - Step Response (S4STP)...")
print(f"Initial conditions: psi_qse={y0[0]:.4f}, psi_dse={y0[1]:.4f}, wr/wb={y0[4]:.4f}")
print(f"Voltage step applied at t=1.0s from {Vm:.2f}V to {Vm+1.0:.2f}V")
print(f"Load torque: {Tb:.2f} Nm (base torque)")

sol = solve_ivp(
    induction_machine_step,
    [0, tstop],
    y0,
    method='Radau',  # Using Radau for stiff system (as original uses ode15s)
    rtol=1e-6,
    atol=1e-6,
    max_step=0.0005,
    dense_output=True
)

print(f"Simulation completed. Time points: {len(sol.t)}")

# Extract results
t = sol.t
psi_qse = sol.y[0, :]
psi_dse = sol.y[1, :]
psi_qre = sol.y[2, :]
psi_dre = sol.y[3, :]
wr_wb = sol.y[4, :]

# Calculate currents and other quantities
iqse = np.zeros_like(t)
idse = np.zeros_like(t)
iqre = np.zeros_like(t)
idre = np.zeros_like(t)
Te = np.zeros_like(t)
wr_rpm = np.zeros_like(t)
vqse_array = np.zeros_like(t)
vdse_array = np.zeros_like(t)

for i in range(len(t)):
    psi_mqe = xM * (psi_qse[i] / xls + psi_qre[i] / xplr)
    psi_mde = xM * (psi_dse[i] / xls + psi_dre[i] / xplr)

    iqse[i] = (psi_qse[i] - psi_mqe) / xls
    idse[i] = (psi_dse[i] - psi_mde) / xls
    iqre[i] = (psi_qre[i] - psi_mqe) / xplr
    idre[i] = (psi_dre[i] - psi_mde) / xplr

    Te[i] = Tfactor * (psi_qse[i] * idse[i] - psi_dse[i] * iqse[i])

    # Speed in RPM (mechanical)
    wr_mech = wr_wb[i] * wbm
    wr_rpm[i] = wr_mech * 60 / (2 * np.pi)

    vqse_array[i], vdse_array[i] = voltage_input(t[i])

# Current magnitude
i_mag = np.sqrt(iqse**2 + idse**2)

# Plotting
fig, axes = plt.subplots(3, 2, figsize=(12, 10))
fig.suptitle('Induction Machine - Step Response (S4STP)', fontsize=14)

# Voltage input
axes[0, 0].plot(t, vqse_array, 'b', linewidth=2, label='v_qs^e')
axes[0, 0].plot(t, vdse_array, 'r', linewidth=2, label='v_ds^e')
axes[0, 0].set_ylabel('Voltage (V)')
axes[0, 0].set_xlabel('Time (s)')
axes[0, 0].legend()
axes[0, 0].grid(True)
axes[0, 0].set_title('Applied Voltages (Synchronous Frame)')
axes[0, 0].axvline(x=1.0, color='k', linestyle='--', linewidth=0.5, alpha=0.5)

# Stator flux linkages
axes[0, 1].plot(t, psi_qse, 'b', label='ψ_qs^e')
axes[0, 1].plot(t, psi_dse, 'r', label='ψ_ds^e')
axes[0, 1].set_ylabel('Stator Flux (Wb)')
axes[0, 1].set_xlabel('Time (s)')
axes[0, 1].legend()
axes[0, 1].grid(True)
axes[0, 1].set_title('Stator Flux Linkages')
axes[0, 1].axvline(x=1.0, color='k', linestyle='--', linewidth=0.5, alpha=0.5)

# Stator currents
axes[1, 0].plot(t, iqse, 'b', label='i_qs^e')
axes[1, 0].plot(t, idse, 'r', label='i_ds^e')
axes[1, 0].set_ylabel('Current (A)')
axes[1, 0].set_xlabel('Time (s)')
axes[1, 0].legend()
axes[1, 0].grid(True)
axes[1, 0].set_title('Stator Currents')
axes[1, 0].axvline(x=1.0, color='k', linestyle='--', linewidth=0.5, alpha=0.5)

# Current magnitude
axes[1, 1].plot(t, i_mag, 'b', linewidth=1.5)
axes[1, 1].set_ylabel('Current Magnitude (A)')
axes[1, 1].set_xlabel('Time (s)')
axes[1, 1].grid(True)
axes[1, 1].set_title('Stator Current Magnitude')
axes[1, 1].axvline(x=1.0, color='k', linestyle='--', linewidth=0.5, alpha=0.5)

# Electromagnetic torque
axes[2, 0].plot(t, Te / Tb, 'b', linewidth=1.5)
axes[2, 0].set_ylabel('Torque (pu)')
axes[2, 0].set_xlabel('Time (s)')
axes[2, 0].axhline(y=1.0, color='r', linestyle='--', linewidth=0.5, label='Load (1 pu)')
axes[2, 0].axvline(x=1.0, color='k', linestyle='--', linewidth=0.5, alpha=0.5)
axes[2, 0].legend()
axes[2, 0].grid(True)
axes[2, 0].set_title('Electromagnetic Torque')

# Rotor speed
axes[2, 1].plot(t, wr_rpm, 'b', linewidth=1.5)
axes[2, 1].set_ylabel('Speed (RPM)')
axes[2, 1].set_xlabel('Time (s)')
axes[2, 1].axhline(y=Nrated, color='r', linestyle='--', linewidth=0.5, alpha=0.5, label='Rated')
axes[2, 1].axvline(x=1.0, color='k', linestyle='--', linewidth=0.5, alpha=0.5)
axes[2, 1].legend()
axes[2, 1].grid(True)
axes[2, 1].set_title('Rotor Speed')

plt.tight_layout()
plt.savefig('/home/rodo/Maquinas/C6/S4STP_results.png', dpi=150)
print("Plot saved to /home/rodo/Maquinas/C6/S4STP_results.png")
plt.show()

# Print step response characteristics
print("\n" + "="*60)
print("Step Response Analysis:")
print("="*60)

# Find indices before and after step
idx_before = np.where(t < 1.0)[0]
idx_after = np.where(t >= 1.0)[0]

if len(idx_before) > 10 and len(idx_after) > 10:
    print(f"\nBefore step (t < 1.0s):")
    print(f"  Steady-state torque: {Te[idx_before[-1]]/Tb:.4f} pu")
    print(f"  Steady-state current: {i_mag[idx_before[-1]]:.2f} A")
    print(f"  Steady-state speed: {wr_rpm[idx_before[-1]]:.2f} RPM")

    print(f"\nAfter step (t = {tstop}s):")
    print(f"  Final torque: {Te[-1]/Tb:.4f} pu")
    print(f"  Final current: {i_mag[-1]:.2f} A")
    print(f"  Final speed: {wr_rpm[-1]:.2f} RPM")

    # Peak values after step
    peak_current_idx = idx_after[np.argmax(i_mag[idx_after])]
    peak_torque_idx = idx_after[np.argmax(Te[idx_after])]

    print(f"\nTransient response:")
    print(f"  Peak current: {i_mag[peak_current_idx]:.2f} A at t={t[peak_current_idx]:.4f}s")
    print(f"  Peak torque: {Te[peak_torque_idx]/Tb:.4f} pu at t={t[peak_torque_idx]:.4f}s")

    # Change in speed
    delta_speed = wr_rpm[-1] - wr_rpm[idx_before[-1]]
    print(f"  Speed change: {delta_speed:.2f} RPM")
