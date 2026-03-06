"""
Induction Machine with Unbalanced Load
Converted from S5B.MDL
Models unbalanced loading conditions with rectifier-type loads
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

# States: [psi_qs, psi_ds, psi_qr', psi_dr', wr/wb, theta_integ]
# theta_integ is integrated angle for phase reference
y0 = np.array([Psiqso, Psidso, Psipqro, Psipdro, wrbywbo, 0.0])


def sign_function(x):
    """Sign function: returns 1 if x>0, -1 if x<0, 0 if x==0"""
    if x > 0:
        return 1.0
    elif x < 0:
        return -1.0
    else:
        return 0.0


def induction_machine_unbalanced_load(t, y):
    """
    Induction machine model with unbalanced load
    Simulates rectifier loads on each phase

    States:
        y[0] = psi_qs  : q-axis stator flux linkage
        y[1] = psi_ds  : d-axis stator flux linkage
        y[2] = psi_qr' : q-axis rotor flux linkage (referred to stator)
        y[3] = psi_dr' : d-axis rotor flux linkage (referred to stator)
        y[4] = wr/wb   : normalized rotor speed
        y[5] = theta   : integrated angle
    """
    psi_qs, psi_ds, psi_qr, psi_dr, wr_wb, theta = y

    # Magnetizing flux linkages
    psi_mq = xM * (psi_qs / xls + psi_qr / xplr)
    psi_md = xM * (psi_ds / xls + psi_dr / xplr)

    # Stator currents (qd components)
    iqs = (psi_qs - psi_mq) / xls
    ids = (psi_ds - psi_md) / xls

    # Rotor currents
    iqr = (psi_qr - psi_mq) / xplr
    idr = (psi_dr - psi_md) / xplr

    # Inverse Clarke to get phase currents
    ias = iqs
    ibs = -(iqs + np.sqrt(3) * ids) / 2
    ics = -(iqs - np.sqrt(3) * ids) / 2

    # Unbalanced load model - diode rectifier with different loads per phase
    # Load resistance values (different for each phase to create unbalance)
    Rload_a = 10.0   # Ohms
    Rload_b = 15.0   # Different load
    Rload_c = 12.0   # Different load

    # Voltage drop across loads (rectified behavior - uses sign function)
    # Simple model: Vload = sign(i) * |i| * Rload (approximates diode rectifier)
    vload_a = sign_function(ias) * abs(ias) * Rload_a
    vload_b = sign_function(ibs) * abs(ibs) * Rload_b
    vload_c = sign_function(ics) * abs(ics) * Rload_c

    # Applied phase voltages (source voltages)
    vas_source = Vm * np.cos(wb * t)
    vbs_source = Vm * np.cos(wb * t - 2 * np.pi / 3)
    vcs_source = Vm * np.cos(wb * t + 2 * np.pi / 3)

    # Actual voltages at machine terminals (source - load drop)
    vas = vas_source - vload_a
    vbs = vbs_source - vload_b
    vcs = vcs_source - vload_c

    # Transform abc to qd0 (Clarke transformation)
    vqs = (2/3) * (vas - (vbs + vcs) / 2)
    vds = (vcs - vbs) / np.sqrt(3)

    # Flux linkage derivatives - Q-axis stator
    dpsi_qs_dt = wb * (psi_mq + (rs / xls) * (vqs - psi_qs))

    # Flux linkage derivatives - D-axis stator
    dpsi_ds_dt = wb * (psi_md + (rs / xls) * (vds - psi_ds))

    # Flux linkage derivatives - Q-axis rotor
    dpsi_qr_dt = wb * (wr_wb * psi_dr + (rpr / xplr) * (psi_mq - psi_qr))

    # Flux linkage derivatives - D-axis rotor
    dpsi_dr_dt = wb * (-wr_wb * psi_qr + (rpr / xplr) * (psi_md - psi_dr))

    # Electromagnetic torque
    Te = Tfactor * (psi_qs * ids - psi_ds * iqs)

    # Mechanical load torque (fan-type load: proportional to speed squared)
    Tmech_base = -Trated * 0.3
    speed_ratio = (1 - wr_wb) * wbm / wmrated
    Tmech = Tmech_base * speed_ratio**2 if speed_ratio > 0 else 0

    # Rotor speed derivative
    dwr_wb_dt = (Te - Tmech) / (2 * H * wb)

    # Angle derivative (for reference)
    dtheta_dt = wb

    return [dpsi_qs_dt, dpsi_ds_dt, dpsi_qr_dt, dpsi_dr_dt, dwr_wb_dt, dtheta_dt]


# Solve the differential equations
print("Starting simulation - Unbalanced Load (S5B)...")
print(f"Initial conditions: psi_qs={y0[0]:.4f}, psi_ds={y0[1]:.4f}, wr/wb={y0[4]:.4f}")
print("Unbalanced rectifier loads: Ra=10Ω, Rb=15Ω, Rc=12Ω")

sol = solve_ivp(
    induction_machine_unbalanced_load,
    [0, tstop],
    y0,
    method='Radau',  # Stiff solver for discontinuous loads
    rtol=5e-6,
    atol=1e-6,
    max_step=5e-3,
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
Te = np.zeros_like(t)
wr_rpm = np.zeros_like(t)
ias = np.zeros_like(t)
ibs = np.zeros_like(t)
ics = np.zeros_like(t)
vas = np.zeros_like(t)
vbs = np.zeros_like(t)
vcs = np.zeros_like(t)

for i in range(len(t)):
    psi_mq = xM * (psi_qs[i] / xls + psi_qr[i] / xplr)
    psi_md = xM * (psi_ds[i] / xls + psi_dr[i] / xplr)

    iqs[i] = (psi_qs[i] - psi_mq) / xls
    ids[i] = (psi_ds[i] - psi_md) / xls

    # Phase currents
    ias[i] = iqs[i]
    ibs[i] = -(iqs[i] + np.sqrt(3) * ids[i]) / 2
    ics[i] = -(iqs[i] - np.sqrt(3) * ids[i]) / 2

    # Phase voltages with load
    Rload_a, Rload_b, Rload_c = 10.0, 15.0, 12.0
    vload_a = sign_function(ias[i]) * abs(ias[i]) * Rload_a
    vload_b = sign_function(ibs[i]) * abs(ibs[i]) * Rload_b
    vload_c = sign_function(ics[i]) * abs(ics[i]) * Rload_c

    vas_source = Vm * np.cos(wb * t[i])
    vbs_source = Vm * np.cos(wb * t[i] - 2 * np.pi / 3)
    vcs_source = Vm * np.cos(wb * t[i] + 2 * np.pi / 3)

    vas[i] = vas_source - vload_a
    vbs[i] = vbs_source - vload_b
    vcs[i] = vcs_source - vload_c

    Te[i] = Tfactor * (psi_qs[i] * ids[i] - psi_ds[i] * iqs[i])
    wr_rpm[i] = (1 - wr_wb[i]) * wbm * 60 / (2 * np.pi)

# Plotting
fig, axes = plt.subplots(3, 2, figsize=(12, 10))
fig.suptitle('Induction Machine - Unbalanced Load (S5B)', fontsize=14)

# Three-phase currents
t_zoom = min(0.1, tstop)
idx_zoom = t < t_zoom
axes[0, 0].plot(t[idx_zoom], ias[idx_zoom], 'r', label='i_as', linewidth=1)
axes[0, 0].plot(t[idx_zoom], ibs[idx_zoom], 'g', label='i_bs', linewidth=1)
axes[0, 0].plot(t[idx_zoom], ics[idx_zoom], 'b', label='i_cs', linewidth=1)
axes[0, 0].set_ylabel('Current (A)')
axes[0, 0].set_xlabel('Time (s)')
axes[0, 0].legend()
axes[0, 0].grid(True)
axes[0, 0].set_title('Three-Phase Currents (Zoomed)')

# Three-phase currents full time
axes[0, 1].plot(t, ias, 'r', label='i_as', linewidth=0.5, alpha=0.6)
axes[0, 1].plot(t, ibs, 'g', label='i_bs', linewidth=0.5, alpha=0.6)
axes[0, 1].plot(t, ics, 'b', label='i_cs', linewidth=0.5, alpha=0.6)
axes[0, 1].set_ylabel('Current (A)')
axes[0, 1].set_xlabel('Time (s)')
axes[0, 1].legend()
axes[0, 1].grid(True)
axes[0, 1].set_title('Three-Phase Currents (Full)')

# Terminal voltages
axes[1, 0].plot(t[idx_zoom], vas[idx_zoom], 'r', label='v_as', linewidth=1)
axes[1, 0].plot(t[idx_zoom], vbs[idx_zoom], 'g', label='v_bs', linewidth=1)
axes[1, 0].plot(t[idx_zoom], vcs[idx_zoom], 'b', label='v_cs', linewidth=1)
axes[1, 0].set_ylabel('Voltage (V)')
axes[1, 0].set_xlabel('Time (s)')
axes[1, 0].legend()
axes[1, 0].grid(True)
axes[1, 0].set_title('Terminal Voltages (with load drop)')

# Current RMS values
window = 100
ias_rms = np.sqrt(np.convolve(ias**2, np.ones(window)/window, mode='same'))
ibs_rms = np.sqrt(np.convolve(ibs**2, np.ones(window)/window, mode='same'))
ics_rms = np.sqrt(np.convolve(ics**2, np.ones(window)/window, mode='same'))

axes[1, 1].plot(t, ias_rms, 'r', label='i_as (RMS)', linewidth=1.5)
axes[1, 1].plot(t, ibs_rms, 'g', label='i_bs (RMS)', linewidth=1.5)
axes[1, 1].plot(t, ics_rms, 'b', label='i_cs (RMS)', linewidth=1.5)
axes[1, 1].set_ylabel('Current RMS (A)')
axes[1, 1].set_xlabel('Time (s)')
axes[1, 1].legend()
axes[1, 1].grid(True)
axes[1, 1].set_title('Phase Current RMS (showing unbalance)')

# Electromagnetic torque
axes[2, 0].plot(t, Te / Tb, 'b', linewidth=1)
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
plt.savefig('/home/rodo/Maquinas/C6/S5B_results.png', dpi=150)
print("Plot saved to /home/rodo/Maquinas/C6/S5B_results.png")
plt.show()

# Analysis of unbalance
print("\n" + "="*60)
print("Unbalanced Load Analysis:")
print("="*60)

# Calculate RMS values from last 200 samples (steady state)
n_ss = min(200, len(t) // 2)
ias_rms_ss = np.sqrt(np.mean(ias[-n_ss:]**2))
ibs_rms_ss = np.sqrt(np.mean(ibs[-n_ss:]**2))
ics_rms_ss = np.sqrt(np.mean(ics[-n_ss:]**2))

print(f"\nSteady-state Phase Currents (RMS):")
print(f"  i_as: {ias_rms_ss:.2f} A")
print(f"  i_bs: {ibs_rms_ss:.2f} A")
print(f"  i_cs: {ics_rms_ss:.2f} A")

i_avg = (ias_rms_ss + ibs_rms_ss + ics_rms_ss) / 3
unbalance_percent = max(abs(ias_rms_ss - i_avg), abs(ibs_rms_ss - i_avg), abs(ics_rms_ss - i_avg)) / i_avg * 100

print(f"\nCurrent unbalance: {unbalance_percent:.2f}%")
print(f"Average torque: {np.mean(Te[-n_ss:])/Tb:.4f} pu")
print(f"Torque ripple (std dev): {np.std(Te[-n_ss:])/Tb:.4f} pu")
print(f"Final speed: {wr_rpm[-1]:.2f} RPM")
