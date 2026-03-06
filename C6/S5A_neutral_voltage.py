"""
Induction Machine with Neutral Voltage (Zero-Sequence Component)
Converted from S5A.MDL
Three-phase unbalanced conditions with neutral connection
"""
import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt
import sys
sys.path.append('/home/rodo/Maquinas/C6')
from p20hp import *

# Simulation parameters
tstop = 2.0  # Simulation stop time

# Initial conditions
wrbywbo = srated
Psiqso = Vm / wb * 0.95
Psidso = 0.0
Psipqro = Psiqso * 0.9
Psipdro = 0.0

# States: [psi_qs, psi_ds, psi_qr', psi_dr', wr/wb]
y0 = np.array([Psiqso, Psidso, Psipqro, Psipdro, wrbywbo])


def induction_machine_with_neutral(t, y):
    """
    Induction machine model in stationary reference frame
    Including zero-sequence (neutral) component for unbalanced conditions

    States:
        y[0] = psi_qs  : q-axis stator flux linkage
        y[1] = psi_ds  : d-axis stator flux linkage
        y[2] = psi_qr' : q-axis rotor flux linkage (referred to stator)
        y[3] = psi_dr' : d-axis rotor flux linkage (referred to stator)
        y[4] = wr/wb   : normalized rotor speed

    Note: Zero-sequence component is handled algebraically
    """
    psi_qs, psi_ds, psi_qr, psi_dr, wr_wb = y

    # Three-phase voltages - can include unbalance
    # For this example, creating a small unbalance
    unbalance_factor = 0.0  # Change to introduce unbalance (e.g., 0.1 for 10%)

    vas = Vm * np.cos(wb * t) * (1 + unbalance_factor)
    vbs = Vm * np.cos(wb * t - 2 * np.pi / 3) * (1 - unbalance_factor/2)
    vcs = Vm * np.cos(wb * t + 2 * np.pi / 3) * (1 - unbalance_factor/2)

    # Transform abc to qd0 (Clarke transformation)
    vqs = (2/3) * (vas - (vbs + vcs) / 2)
    vds = (vcs - vbs) / np.sqrt(3)
    v0s = (vas + vbs + vcs) / 3  # Zero-sequence component

    # Magnetizing flux linkages
    psi_mq = xM * (psi_qs / xls + psi_qr / xplr)
    psi_md = xM * (psi_ds / xls + psi_dr / xplr)

    # Stator currents (qd components)
    iqs = (psi_qs - psi_mq) / xls
    ids = (psi_ds - psi_md) / xls

    # Zero-sequence current (algebraic equation)
    # For star-connected stator with neutral: i0s = v0s / rs
    # For delta or star without neutral: i0s = 0
    # Assuming star with neutral impedance
    i0s = v0s / rs if abs(v0s) > 1e-6 else 0.0

    # Rotor currents (referred to stator)
    iqr = (psi_qr - psi_mq) / xplr
    idr = (psi_dr - psi_md) / xplr

    # Flux linkage derivatives - Q-axis stator
    # From S5A.MDL: wb*(u[2]+(rs/xls)*(u[1]-u[3]))
    # Note: No (we/wb) term in stationary frame
    dpsi_qs_dt = wb * (psi_mq + (rs / xls) * (vqs - psi_qs))

    # Flux linkage derivatives - D-axis stator
    dpsi_ds_dt = wb * (psi_md + (rs / xls) * (vds - psi_ds))

    # Flux linkage derivatives - Q-axis rotor
    # Speed coupling: (wr/wb) * psi_dr'
    dpsi_qr_dt = wb * (wr_wb * psi_dr + (rpr / xplr) * (psi_mq - psi_qr))

    # Flux linkage derivatives - D-axis rotor
    dpsi_dr_dt = wb * (-wr_wb * psi_qr + (rpr / xplr) * (psi_md - psi_dr))

    # Electromagnetic torque
    Te = Tfactor * (psi_qs * ids - psi_ds * iqs)

    # Mechanical load torque
    if t < 1.0:
        Tmech = 0.0
    else:
        Tmech = -Trated * 0.5

    # Rotor speed derivative
    dwr_wb_dt = (Te - Tmech) / (2 * H * wb)

    return [dpsi_qs_dt, dpsi_ds_dt, dpsi_qr_dt, dpsi_dr_dt, dwr_wb_dt]


# Solve the differential equations
print("Starting simulation - With Neutral Voltage (S5A)...")
print(f"Initial conditions: psi_qs={y0[0]:.4f}, psi_ds={y0[1]:.4f}, wr/wb={y0[4]:.4f}")

sol = solve_ivp(
    induction_machine_with_neutral,
    [0, tstop],
    y0,
    method='RK45',
    rtol=1e-6,
    atol=1e-5,
    max_step=1e-2,
    dense_output=True
)

print(f"Simulation completed. Time points: {len(sol.t)}")

# Extract results
t = sol.t
psi_qs = sol.y[0, :]
psi_ds = sol.y[1, :]
psi_qr = sol.y[2, :]
psi_dr = sol.y[3, :]
wr_wb = sol.y[4, :]

# Calculate currents and other quantities
iqs = np.zeros_like(t)
ids = np.zeros_like(t)
i0s = np.zeros_like(t)
Te = np.zeros_like(t)
wr_rpm = np.zeros_like(t)

# Phase quantities
ias = np.zeros_like(t)
ibs = np.zeros_like(t)
ics = np.zeros_like(t)
vas = np.zeros_like(t)
vbs = np.zeros_like(t)
vcs = np.zeros_like(t)

unbalance_factor = 0.0  # Same as in model

for i in range(len(t)):
    psi_mq = xM * (psi_qs[i] / xls + psi_qr[i] / xplr)
    psi_md = xM * (psi_ds[i] / xls + psi_dr[i] / xplr)

    iqs[i] = (psi_qs[i] - psi_mq) / xls
    ids[i] = (psi_ds[i] - psi_md) / xls

    # Three-phase voltages
    vas[i] = Vm * np.cos(wb * t[i]) * (1 + unbalance_factor)
    vbs[i] = Vm * np.cos(wb * t[i] - 2 * np.pi / 3) * (1 - unbalance_factor/2)
    vcs[i] = Vm * np.cos(wb * t[i] + 2 * np.pi / 3) * (1 - unbalance_factor/2)

    v0s[i] = (vas[i] + vbs[i] + vcs[i]) / 3
    i0s[i] = v0s[i] / rs if abs(v0s[i]) > 1e-6 else 0.0

    # Inverse Clarke transformation (qd0 -> abc)
    ias[i] = iqs[i] + i0s[i]
    ibs[i] = -(iqs[i] + np.sqrt(3) * ids[i]) / 2 + i0s[i]
    ics[i] = -(iqs[i] - np.sqrt(3) * ids[i]) / 2 + i0s[i]

    Te[i] = Tfactor * (psi_qs[i] * ids[i] - psi_ds[i] * iqs[i])
    wr_rpm[i] = (1 - wr_wb[i]) * wbm * 60 / (2 * np.pi)

# Plotting
fig, axes = plt.subplots(3, 2, figsize=(12, 10))
fig.suptitle('Induction Machine - With Neutral Connection (S5A)', fontsize=14)

# Three-phase voltages
axes[0, 0].plot(t, vas, 'r', label='v_as', linewidth=0.5, alpha=0.7)
axes[0, 0].plot(t, vbs, 'g', label='v_bs', linewidth=0.5, alpha=0.7)
axes[0, 0].plot(t, vcs, 'b', label='v_cs', linewidth=0.5, alpha=0.7)
axes[0, 0].set_ylabel('Voltage (V)')
axes[0, 0].set_xlabel('Time (s)')
axes[0, 0].legend()
axes[0, 0].grid(True)
axes[0, 0].set_title('Three-Phase Voltages')
axes[0, 0].set_xlim([0, min(0.1, tstop)])  # Zoom to see waveforms

# Zero-sequence voltage and current
axes[0, 1].plot(t, v0s, 'b', label='v_0s')
axes[0, 1].set_ylabel('Zero-seq Voltage (V)', color='b')
axes[0, 1].tick_params(axis='y', labelcolor='b')
axes[0, 1].set_xlabel('Time (s)')
axes[0, 1].grid(True)

ax2 = axes[0, 1].twinx()
ax2.plot(t, i0s, 'r', label='i_0s')
ax2.set_ylabel('Zero-seq Current (A)', color='r')
ax2.tick_params(axis='y', labelcolor='r')
axes[0, 1].set_title('Zero-Sequence Components')

# Three-phase currents
axes[1, 0].plot(t, ias, 'r', label='i_as', linewidth=0.5)
axes[1, 0].plot(t, ibs, 'g', label='i_bs', linewidth=0.5)
axes[1, 0].plot(t, ics, 'b', label='i_cs', linewidth=0.5)
axes[1, 0].set_ylabel('Current (A)')
axes[1, 0].set_xlabel('Time (s)')
axes[1, 0].legend()
axes[1, 0].grid(True)
axes[1, 0].set_title('Three-Phase Currents')

# dq currents
axes[1, 1].plot(t, iqs, 'b', label='i_qs')
axes[1, 1].plot(t, ids, 'r', label='i_ds')
axes[1, 1].set_ylabel('Current (A)')
axes[1, 1].set_xlabel('Time (s)')
axes[1, 1].legend()
axes[1, 1].grid(True)
axes[1, 1].set_title('qd-axis Currents')

# Electromagnetic torque
axes[2, 0].plot(t, Te / Tb, 'b', linewidth=1.5)
axes[2, 0].set_ylabel('Torque (pu)')
axes[2, 0].set_xlabel('Time (s)')
axes[2, 0].axhline(y=0, color='k', linestyle='--', linewidth=0.5)
axes[2, 0].grid(True)
axes[2, 0].set_title('Electromagnetic Torque')

# Rotor speed
axes[2, 1].plot(t, wr_rpm, 'b', linewidth=1.5)
axes[2, 1].set_ylabel('Speed (RPM)')
axes[2, 1].set_xlabel('Time (s)')
axes[2, 1].axhline(y=Nrated, color='r', linestyle='--', linewidth=0.5, alpha=0.5, label='Rated')
axes[2, 1].legend()
axes[2, 1].grid(True)
axes[2, 1].set_title('Rotor Speed')

plt.tight_layout()
plt.savefig('/home/rodo/Maquinas/C6/S5A_results.png', dpi=150)
print("Plot saved to /home/rodo/Maquinas/C6/S5A_results.png")
plt.show()

# Print final values
print("\n" + "="*60)
print("Final Values with Neutral Connection:")
print("="*60)
print(f"Rotor speed: {wr_rpm[-1]:.2f} RPM")
print(f"Electromagnetic torque: {Te[-1]/Tb:.4f} pu")
print(f"Phase currents (RMS):")
print(f"  i_as: {np.sqrt(np.mean(ias[-100:]**2)):.2f} A")
print(f"  i_bs: {np.sqrt(np.mean(ibs[-100:]**2)):.2f} A")
print(f"  i_cs: {np.sqrt(np.mean(ics[-100:]**2)):.2f} A")
print(f"Zero-sequence current (RMS): {np.sqrt(np.mean(i0s[-100:]**2)):.4f} A")

# Check for current balance
i_sum = np.mean(np.abs(ias[-100:] + ibs[-100:] + ics[-100:]))
print(f"Current sum (should be ~0 for balanced): {i_sum:.4f} A")
