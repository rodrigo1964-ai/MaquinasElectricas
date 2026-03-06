"""
Single-Phase Induction Motor Simulation
Converted from S6.MDL
Models a single-phase motor with auxiliary winding (main and auxiliary windings)
"""
import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt
import sys
sys.path.append('/home/rodo/Maquinas/C6')
from p20hp import *

# Single-phase motor parameters (modified from 3-phase parameters)
# For a single-phase motor, we need separate d and q axis parameters
# Main winding parameters (direct axis)
rpds = rs * 1.2  # Main winding resistance (slightly higher)
xplds = xls * 1.1  # Main winding leakage reactance

# Auxiliary winding parameters (quadrature axis)
rqs = rs * 1.5  # Auxiliary winding resistance (higher due to thinner wire)
xlqs = xls * 1.3  # Auxiliary winding leakage reactance

# Magnetizing reactances (different for d and q due to asymmetry)
xMd = xm * 0.9  # d-axis magnetizing reactance
xMq = xm * 0.7  # q-axis magnetizing reactance (lower due to auxiliary winding)

# Simulation parameters
tstop = 2.0

# Initial conditions (motor starting from rest)
wrbywbo = 0.0  # Starting from standstill
Psipdso = 0.0
Psipqro = 0.0
Psipdro = 0.0

# States: [psi'_ds, psi_qr', psi_dr']
# Note: Single-phase motor in d-q model (asymmetric)
y0 = np.array([Psipdso, Psipqro, Psipdro, wrbywbo])


def single_phase_motor(t, y):
    """
    Single-phase induction motor model
    Using asymmetric d-q axis model

    States:
        y[0] = psi'_ds  : d-axis stator flux linkage (main winding)
        y[1] = psi_qr'  : q-axis rotor flux linkage
        y[2] = psi_dr'  : d-axis rotor flux linkage
        y[3] = wr/wb    : normalized rotor speed
    """
    psi_pds, psi_qr, psi_dr, wr_wb = y

    # Applied voltages
    # Main winding voltage (d-axis)
    vpds = Vm * np.cos(wb * t)

    # For starting, auxiliary winding may be energized through a capacitor
    # This creates a phase shift. After starting, it may be disconnected.
    # Here we model continuous operation with phase-shifted auxiliary voltage
    if t < 0.5:  # Auxiliary winding active during starting
        vqs = Vm * np.sin(wb * t) * 0.8  # 90 degrees phase shift, reduced magnitude
    else:  # Centrifugal switch disconnects auxiliary winding
        vqs = 0.0

    # Magnetizing flux linkages
    # D-axis
    psi_md = xMd * (psi_pds / xplds + psi_dr / xplr)

    # Q-axis (for auxiliary winding and rotor q-axis)
    # Note: No q-axis stator flux state since auxiliary may be disconnected
    # We'll calculate q-axis stator flux algebraically when auxiliary is active
    if abs(vqs) > 1e-6:
        # Simplified: assuming auxiliary winding contributes to q-axis
        psi_qs = vqs * xMq / (wb * rqs)  # Approximate for capacitor-run motor
    else:
        psi_qs = 0.0

    psi_mq = xMq * (psi_qs / xlqs + psi_qr / xplr) if abs(psi_qs) > 1e-6 else xMq * psi_qr / xplr

    # Currents
    # D-axis stator current (main winding)
    ipds = (psi_pds - psi_md) / xplds

    # Q-axis stator current (auxiliary winding)
    iqs = (psi_qs - psi_mq) / xlqs if abs(psi_qs) > 1e-6 else 0.0

    # Rotor currents
    iqr = (psi_qr - psi_mq) / xplr
    idr = (psi_dr - psi_md) / xplr

    # Flux linkage derivatives
    # D-axis stator (main winding)
    # From S6.MDL: wb*(u[2]+(rpds/xplds)*(u[1]-u[3]))
    dpsi_pds_dt = wb * (psi_md + (rpds / xplds) * (vpds - psi_pds))

    # Q-axis rotor
    # From S6.MDL: wb*(u[2] +(rpr/xplr)*(u[3]-u[1]))
    # With speed coupling: (wr/wb) * psi_dr
    dpsi_qr_dt = wb * (wr_wb * psi_dr + (rpr / xplr) * (psi_mq - psi_qr))

    # D-axis rotor
    # With speed coupling: -(wr/wb) * psi_qr
    dpsi_dr_dt = wb * (-wr_wb * psi_qr + (rpr / xplr) * (psi_md - psi_dr))

    # For S6, there's an additional output: dpsidr'/dt scaled
    # From S6.MDL: xmq/(wb*(xplr+xmq)) * dpsi_dr_dt
    # This is used for analysis but doesn't affect state equations

    # Electromagnetic torque
    # Modified for single-phase motor
    # From S6.MDL analysis, torque includes both d and q axis contributions
    # Approximate torque for single-phase motor
    Te = Tfactor * (psi_pds * idr - psi_dr * ipds)

    # Mechanical load torque
    if t < 1.0:
        Tmech = 0.0  # No load during starting
    else:
        Tmech = -Trated * 0.3  # Light load

    # Rotor speed derivative
    dwr_wb_dt = (Te - Tmech) / (2 * H * wb)

    return [dpsi_pds_dt, dpsi_qr_dt, dpsi_dr_dt, dwr_wb_dt]


# Solve the differential equations
print("Starting simulation - Single-Phase Induction Motor (S6)...")
print(f"Initial conditions: starting from rest")
print(f"Main winding: rpds={rpds:.4f}Ω, xplds={xplds:.4f}Ω")
print(f"Auxiliary winding: rqs={rqs:.4f}Ω, xlqs={xlqs:.4f}Ω")
print("Auxiliary winding disconnects at t=0.5s")

sol = solve_ivp(
    single_phase_motor,
    [0, tstop],
    y0,
    method='Radau',  # Stiff solver
    rtol=1e-6,
    atol=1e-6,
    max_step=1e-2,
    dense_output=True
)

print(f"Simulation completed. Time points: {len(sol.t)}")

# Extract results
t = sol.t
psi_pds = sol.y[0, :]
psi_qr = sol.y[1, :]
psi_dr = sol.y[2, :]
wr_wb = sol.y[3, :]

# Calculate currents and other quantities
ipds = np.zeros_like(t)
iqs = np.zeros_like(t)
idr = np.zeros_like(t)
iqr = np.zeros_like(t)
Te = np.zeros_like(t)
wr_rpm = np.zeros_like(t)
vpds_array = np.zeros_like(t)
vqs_array = np.zeros_like(t)

for i in range(len(t)):
    # Applied voltages
    vpds_array[i] = Vm * np.cos(wb * t[i])
    if t[i] < 0.5:
        vqs_array[i] = Vm * np.sin(wb * t[i]) * 0.8
        psi_qs_temp = vqs_array[i] * xMq / (wb * rqs)
    else:
        vqs_array[i] = 0.0
        psi_qs_temp = 0.0

    # Magnetizing flux
    psi_md = xMd * (psi_pds[i] / xplds + psi_dr[i] / xplr)
    psi_mq = xMq * (psi_qs_temp / xlqs + psi_qr[i] / xplr) if abs(psi_qs_temp) > 1e-6 else xMq * psi_qr[i] / xplr

    # Currents
    ipds[i] = (psi_pds[i] - psi_md) / xplds
    iqs[i] = (psi_qs_temp - psi_mq) / xlqs if abs(psi_qs_temp) > 1e-6 else 0.0
    idr[i] = (psi_dr[i] - psi_md) / xplr
    iqr[i] = (psi_qr[i] - psi_mq) / xplr

    # Torque
    Te[i] = Tfactor * (psi_pds[i] * idr[i] - psi_dr[i] * ipds[i])

    # Speed
    wr_rpm[i] = (1 - wr_wb[i]) * wbm * 60 / (2 * np.pi)

# Plotting
fig, axes = plt.subplots(3, 2, figsize=(12, 10))
fig.suptitle('Single-Phase Induction Motor (S6)', fontsize=14)

# Applied voltages
axes[0, 0].plot(t, vpds_array, 'b', linewidth=1, label="v'_ds (main)")
axes[0, 0].plot(t, vqs_array, 'r', linewidth=1, label='v_qs (aux)')
axes[0, 0].set_ylabel('Voltage (V)')
axes[0, 0].set_xlabel('Time (s)')
axes[0, 0].legend()
axes[0, 0].grid(True)
axes[0, 0].set_title('Applied Voltages')
axes[0, 0].axvline(x=0.5, color='k', linestyle='--', linewidth=0.5, alpha=0.5)
axes[0, 0].set_xlim([0, min(0.1, tstop)])  # Zoom to see waveforms

# Flux linkages
axes[0, 1].plot(t, psi_pds, 'b', label="ψ'_ds")
axes[0, 1].plot(t, psi_dr, 'r', label="ψ_dr'")
axes[0, 1].plot(t, psi_qr, 'g', label="ψ_qr'")
axes[0, 1].set_ylabel('Flux Linkage (Wb)')
axes[0, 1].set_xlabel('Time (s)')
axes[0, 1].legend()
axes[0, 1].grid(True)
axes[0, 1].set_title('Flux Linkages')
axes[0, 1].axvline(x=0.5, color='k', linestyle='--', linewidth=0.5, alpha=0.5)

# Main winding current
axes[1, 0].plot(t, ipds, 'b', linewidth=0.5)
axes[1, 0].set_ylabel('Current (A)')
axes[1, 0].set_xlabel('Time (s)')
axes[1, 0].grid(True)
axes[1, 0].set_title("Main Winding Current (i'_ds)")
axes[1, 0].axvline(x=0.5, color='k', linestyle='--', linewidth=0.5, alpha=0.5)

# Auxiliary winding current
axes[1, 1].plot(t, iqs, 'r', linewidth=0.5)
axes[1, 1].set_ylabel('Current (A)')
axes[1, 1].set_xlabel('Time (s)')
axes[1, 1].grid(True)
axes[1, 1].set_title('Auxiliary Winding Current (i_qs)')
axes[1, 1].axvline(x=0.5, color='k', linestyle='--', linewidth=0.5, alpha=0.5, label='Switch opens')
axes[1, 1].legend()

# Electromagnetic torque
axes[2, 0].plot(t, Te / Tb, 'b', linewidth=1.5)
axes[2, 0].set_ylabel('Torque (pu)')
axes[2, 0].set_xlabel('Time (s)')
axes[2, 0].axhline(y=0, color='k', linestyle='--', linewidth=0.5)
axes[2, 0].axvline(x=0.5, color='k', linestyle='--', linewidth=0.5, alpha=0.5)
axes[2, 0].grid(True)
axes[2, 0].set_title('Electromagnetic Torque')

# Rotor speed
axes[2, 1].plot(t, wr_rpm, 'b', linewidth=1.5)
axes[2, 1].set_ylabel('Speed (RPM)')
axes[2, 1].set_xlabel('Time (s)')
axes[2, 1].axhline(y=Nrated, color='r', linestyle='--', linewidth=0.5, alpha=0.5, label='Rated (3-ph)')
axes[2, 1].axvline(x=0.5, color='k', linestyle='--', linewidth=0.5, alpha=0.5)
axes[2, 1].legend()
axes[2, 1].grid(True)
axes[2, 1].set_title('Rotor Speed')

plt.tight_layout()
plt.savefig('/home/rodo/Maquinas/C6/S6_results.png', dpi=150)
print("Plot saved to /home/rodo/Maquinas/C6/S6_results.png")
plt.show()

# Print results
print("\n" + "="*60)
print("Single-Phase Motor Performance:")
print("="*60)

# Starting phase (0 to 0.5s)
idx_start = t < 0.5
if len(idx_start) > 0:
    start_torque_avg = np.mean(Te[idx_start]) / Tb
    start_current_peak = np.max(np.abs(ipds[idx_start]))
    print(f"\nStarting Phase (auxiliary ON, t < 0.5s):")
    print(f"  Average starting torque: {start_torque_avg:.4f} pu")
    print(f"  Peak main current: {start_current_peak:.2f} A")
    print(f"  Speed reached: {wr_rpm[idx_start][-1]:.2f} RPM")

# Running phase (after 0.5s)
idx_run = t >= 0.5
if len(idx_run) > 10:
    run_torque_avg = np.mean(Te[idx_run]) / Tb
    run_current_rms = np.sqrt(np.mean(ipds[idx_run]**2))
    print(f"\nRunning Phase (auxiliary OFF, t >= 0.5s):")
    print(f"  Average torque: {run_torque_avg:.4f} pu")
    print(f"  Main current RMS: {run_current_rms:.2f} A")
    print(f"  Final speed: {wr_rpm[-1]:.2f} RPM")
    print(f"  Final slip: {wr_wb[-1]:.4f} pu")

# Torque pulsations (characteristic of single-phase motors)
if len(idx_run) > 100:
    torque_ripple = np.std(Te[idx_run]) / np.abs(np.mean(Te[idx_run])) * 100
    print(f"\nTorque ripple: {torque_ripple:.2f}% (typical for single-phase)")
