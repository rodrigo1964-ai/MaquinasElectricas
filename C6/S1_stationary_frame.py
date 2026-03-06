"""
Induction Machine Simulation in Stationary Reference Frame (abc -> qd0)
Converted from S1.MDL
"""
import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt
import sys
sys.path.append('/home/rodo/Maquinas/C6')
from p20hp import *

# Simulation parameters
tstop = 2.0  # Simulation stop time

# Initial conditions computation
# Assuming steady state at rated conditions initially
theta0 = 0
wrbywbo = srated  # Initial slip = rated slip
wro = wbm * (1 - wrbywbo)  # Initial rotor speed

# Compute steady-state flux linkages (approximate)
# For steady state analysis, we use the equivalent circuit
Zs = rs + 1j * xls
Zm = 1j * xm
Zr = rpr / srated + 1j * xplr
Z_eq = Zs + (Zm * Zr) / (Zm + Zr)

Vas = Vm  # Phase voltage magnitude
Ias = Vas / np.abs(Z_eq)  # Approximate steady state current

# Initial flux linkages (approximation for steady state)
Psiqso = Vm / wb  # Approximate q-axis stator flux
Psidso = 0.0      # d-axis stator flux (assuming aligned)
Psipqro = Psiqso * xm / (xls + xm) * 0.9  # Approximate q-axis rotor flux
Psipdro = 0.0     # d-axis rotor flux

# States: [psi_qs, psi_ds, psi_qr', psi_dr', wr/wb]
y0 = np.array([Psiqso, Psidso, Psipqro, Psipdro, wrbywbo])


def induction_machine_stationary(t, y):
    """
    Induction machine model in stationary reference frame (qd0)

    States:
        y[0] = psi_qs  : q-axis stator flux linkage
        y[1] = psi_ds  : d-axis stator flux linkage
        y[2] = psi_qr' : q-axis rotor flux linkage (referred to stator)
        y[3] = psi_dr' : d-axis rotor flux linkage (referred to stator)
        y[4] = wr/wb   : normalized rotor speed
    """
    psi_qs, psi_ds, psi_qr, psi_dr, wr_wb = y

    # Three-phase voltages (balanced, 60 Hz)
    vas = Vm * np.cos(wb * t)
    vbs = Vm * np.cos(wb * t - 2 * np.pi / 3)
    vcs = Vm * np.cos(wb * t + 2 * np.pi / 3)

    # Transform abc to qd0 (stationary frame)
    # Clarke transformation
    vqs = (2/3) * (vas - (vbs + vcs) / 2)
    vds = (vcs - vbs) / np.sqrt(3)
    v0s = (vas + vbs + vcs) / 3

    # Magnetizing flux linkages
    psi_mq = xM * (psi_qs / xls + psi_qr / xplr)
    psi_md = xM * (psi_ds / xls + psi_dr / xplr)

    # Stator currents
    iqs = (psi_qs - psi_mq) / xls
    ids = (psi_ds - psi_md) / xls

    # Rotor currents (referred to stator)
    iqr = (psi_qr - psi_mq) / xplr
    idr = (psi_dr - psi_md) / xplr

    # Flux linkage derivatives - Q-axis stator
    dpsi_qs_dt = wb * (vqs + (rs / xls) * (psi_mq - psi_qs))

    # Flux linkage derivatives - D-axis stator
    dpsi_ds_dt = wb * (vds + (rs / xls) * (psi_md - psi_ds))

    # Flux linkage derivatives - Q-axis rotor
    dpsi_qr_dt = wb * (wr_wb * psi_dr + (rpr / xplr) * (psi_mq - psi_qr))

    # Flux linkage derivatives - D-axis rotor
    dpsi_dr_dt = wb * (-wr_wb * psi_qr + (rpr / xplr) * (psi_md - psi_dr))

    # Electromagnetic torque
    Te = Tfactor * (psi_qs * ids - psi_ds * iqs)

    # Mechanical load torque (example: constant load)
    if t < 1.0:
        Tmech = 0.0  # No load initially
    else:
        Tmech = -Trated * 0.5  # 50% rated load applied at t=1s

    # Rotor speed derivative
    dwr_wb_dt = (Te - Tmech) / (2 * H * wb)

    return [dpsi_qs_dt, dpsi_ds_dt, dpsi_qr_dt, dpsi_dr_dt, dwr_wb_dt]


# Solve the differential equations
print("Starting simulation...")
print(f"Initial conditions: psi_qs={y0[0]:.4f}, psi_ds={y0[1]:.4f}, wr/wb={y0[4]:.4f}")

sol = solve_ivp(
    induction_machine_stationary,
    [0, tstop],
    y0,
    method='RK45',
    rtol=1e-6,
    atol=1e-5,
    max_step=1e-3,
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
iqr = np.zeros_like(t)
idr = np.zeros_like(t)
Te = np.zeros_like(t)
wr_rpm = np.zeros_like(t)

for i in range(len(t)):
    psi_mq = xM * (psi_qs[i] / xls + psi_qr[i] / xplr)
    psi_md = xM * (psi_ds[i] / xls + psi_dr[i] / xplr)

    iqs[i] = (psi_qs[i] - psi_mq) / xls
    ids[i] = (psi_ds[i] - psi_md) / xls
    iqr[i] = (psi_qr[i] - psi_mq) / xplr
    idr[i] = (psi_dr[i] - psi_md) / xplr

    Te[i] = Tfactor * (psi_qs[i] * ids[i] - psi_ds[i] * iqs[i])
    wr_rpm[i] = (1 - wr_wb[i]) * wbm * 60 / (2 * np.pi)

# Calculate phase currents (transform back from qd0 to abc)
ias = np.zeros_like(t)
ibs = np.zeros_like(t)
ics = np.zeros_like(t)

for i in range(len(t)):
    # Inverse Clarke transformation
    ias[i] = iqs[i]
    ibs[i] = -(iqs[i] + np.sqrt(3) * ids[i]) / 2
    ics[i] = -(iqs[i] - np.sqrt(3) * ids[i]) / 2

# Plotting
fig, axes = plt.subplots(3, 2, figsize=(12, 10))
fig.suptitle('Induction Machine - Stationary Reference Frame (S1)', fontsize=14)

# Flux linkages
axes[0, 0].plot(t, psi_qs, 'b', label='ψ_qs')
axes[0, 0].plot(t, psi_ds, 'r', label='ψ_ds')
axes[0, 0].set_ylabel('Stator Flux (Wb)')
axes[0, 0].set_xlabel('Time (s)')
axes[0, 0].legend()
axes[0, 0].grid(True)

axes[0, 1].plot(t, psi_qr, 'b', label="ψ_qr'")
axes[0, 1].plot(t, psi_dr, 'r', label="ψ_dr'")
axes[0, 1].set_ylabel("Rotor Flux (Wb)")
axes[0, 1].set_xlabel('Time (s)')
axes[0, 1].legend()
axes[0, 1].grid(True)

# Stator currents in qd frame
axes[1, 0].plot(t, iqs, 'b', label='i_qs')
axes[1, 0].plot(t, ids, 'r', label='i_ds')
axes[1, 0].set_ylabel('Stator Current (A)')
axes[1, 0].set_xlabel('Time (s)')
axes[1, 0].legend()
axes[1, 0].grid(True)

# Phase currents (abc frame)
axes[1, 1].plot(t, ias, 'b', label='i_as', linewidth=0.5)
axes[1, 1].plot(t, ibs, 'r', label='i_bs', linewidth=0.5)
axes[1, 1].plot(t, ics, 'g', label='i_cs', linewidth=0.5)
axes[1, 1].set_ylabel('Phase Current (A)')
axes[1, 1].set_xlabel('Time (s)')
axes[1, 1].legend()
axes[1, 1].grid(True)

# Electromagnetic torque
axes[2, 0].plot(t, Te / Tb, 'b', label='T_e (pu)')
axes[2, 0].set_ylabel('Torque (pu)')
axes[2, 0].set_xlabel('Time (s)')
axes[2, 0].axhline(y=0, color='k', linestyle='--', linewidth=0.5)
axes[2, 0].legend()
axes[2, 0].grid(True)

# Rotor speed
axes[2, 1].plot(t, wr_rpm, 'b', label='Speed')
axes[2, 1].set_ylabel('Speed (RPM)')
axes[2, 1].set_xlabel('Time (s)')
axes[2, 1].axhline(y=Nrated, color='r', linestyle='--', linewidth=0.5, label='Rated')
axes[2, 1].legend()
axes[2, 1].grid(True)

plt.tight_layout()
plt.savefig('/home/rodo/Maquinas/C6/S1_results.png', dpi=150)
print("Plot saved to /home/rodo/Maquinas/C6/S1_results.png")
plt.show()

# Print final values
print("\n" + "="*60)
print("Final Steady-State Values:")
print("="*60)
print(f"Rotor speed: {wr_rpm[-1]:.2f} RPM (rated: {Nrated:.2f} RPM)")
print(f"Slip: {wr_wb[-1]:.4f} pu")
print(f"Electromagnetic torque: {Te[-1]/Tb:.4f} pu")
print(f"Stator current magnitude: {np.sqrt(iqs[-1]**2 + ids[-1]**2):.2f} A")
print(f"Phase current RMS (approx): {np.sqrt(ias[-100:]**2).mean():.2f} A")
