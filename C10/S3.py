"""
Subsynchronous Resonance (SSR) Study
IEEE First Benchmark Model with 6-mass torsional system
Series capacitor compensation
Based on s3.mdl - SSR with torsional dynamics
"""
import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt
import sys
sys.path.append('/home/rodo/Maquinas/C10')
from i3essr import *

# Simulation parameters
t_stop = 2.0
rtol = 1e-5
atol = 1e-6

# Base quantities
wb = 2 * np.pi * Frated
we = wb

# Series compensation
Xc_percent = 0.45  # 45% compensation
Xline = 0.5  # line reactance in pu
Xc = Xc_percent * Xline  # series capacitor reactance
Rline = 0.02  # line resistance

# Torsional system parameters (6-mass IEEE benchmark)
# Inertias in seconds (H constants)
H_HP = 0.092897  # High pressure turbine
H_IP = 0.155589  # Intermediate pressure turbine
H_LPA = 0.858670  # Low pressure turbine A
H_LPB = 0.884215  # Low pressure turbine B
H_GEN = 0.868495  # Generator
H_EXC = 0.0342165  # Exciter

H_total = H_HP + H_IP + H_LPA + H_LPB + H_GEN + H_EXC

# Spring constants (in pu torque/rad)
K_HP_IP = 19.303
K_IP_LPA = 34.929
K_LPA_LPB = 52.038
K_LPB_GEN = 70.858
K_GEN_EXC = 2.822

# Damping coefficients
D_HP = 0.0
D_IP = 0.0
D_LPA = 0.0
D_LPB = 0.0
D_GEN = 0.0
D_EXC = 0.0

# Modal analysis matrices for 6-mass system
# Qbar matrix transforms modal to physical coordinates
Qbar = np.array([
    [0.2777, 0.3174, 0.4984, 0.3636, -0.6427, 0.0559],
    [0.2777, 0.3174, 0.1036, -0.5515, 0.4805, 0.5468],
    [0.2777, 0.3174, -0.1680, 0.2357, 0.6586, -0.5956],
    [0.2777, 0.3174, -0.4340, 0.0476, -0.4692, 0.5939],
    [0.2777, -0.9696, 0.0000, 0.0000, 0.0000, 0.0000],
    [0.2777, 0.3174, 0.0000, -0.0954, -0.0272, -0.0010]
])

# Natural frequencies (rad/s)
omega_modes = np.array([0.0, 99.78, 128.2, 161.1, 202.5, 303.4])

# Infinite bus voltage
vqe_inf = 0.0
vde_inf = 1.0

# Mechanical torque
Tmech_total = 0.9

def model_equations(t, y):
    """
    SSR model with 6-mass torsional system
    States: [psid, psipf, psipkd, psipkq, psipkq2, psiq,
             delta_mode0, modal_angles[5], modal_speeds[5],
             vdc, vqc, idc, iqc]
    """
    # Unpack states
    # Generator electrical: 6 states
    psid, psipf, psipkd, psipkq, psipkq2, psiq = y[0:6]

    # Torsional mechanical: 12 states (6 angles + 6 speeds)
    delta_mode0 = y[6]
    modal_angles = y[7:12]  # 5 modal angles
    modal_speeds = y[12:17]  # 5 modal speeds

    # Network: 4 states
    vdc, vqc, idc, iqc = y[17:21]

    # Field voltage (constant)
    Ef_const = 1.8

    # Transform modal to physical coordinates
    delta_modal = np.concatenate([[delta_mode0], modal_angles])
    delta_physical = Qbar @ delta_modal

    # Generator angle is 5th mass (index 4)
    delta_gen = delta_physical[4]

    # Rotor speed from mode 0 (uniform mode)
    wr = 1.0 + modal_speeds[0]  # Note: mode 0 is uniform rotation

    # Generator electrical equations (detailed model with subtransient)
    # d-axis
    xad = xd - xls
    xaq = xq - xls
    xfd = xad + 0.15  # field leakage
    xkd = xad + 0.15  # d-axis damper leakage
    xkq = xaq + 0.20  # q-axis damper leakage (first)
    xkq2 = xaq + 0.25  # q-axis damper leakage (second)

    # Flux linkages
    psimd = psid + xls * (-id if 'id' in locals() else 0)
    psimq = psiq + xls * (-iq if 'iq' in locals() else 0)

    # Currents
    ipf = (psipf - psimd) / (xfd - xad)
    ikd = (psipkd - psimd) / (xkd - xad)
    ikq = (psipkq - psimq) / (xkq - xaq)
    ikq2 = (psipkq2 - psimq) / (xkq2 - xaq)

    id = -(psid / xppd + psimd * (1/xad - 1/xppd))
    iq = -(psiq / xppq + psimq * (1/xaq - 1/xppq))

    # Transform currents to network frame
    iqe = iq * np.cos(delta_gen) - id * np.sin(delta_gen)
    ide = iq * np.sin(delta_gen) + id * np.cos(delta_gen)

    # Network voltages at generator terminals
    vde_term = vde_inf - Rline * ide + (Xline - Xc) * iqe - vdc
    vqe_term = vqe_inf - Rline * iqe - (Xline - Xc) * ide - vqc

    # Transform to rotor frame
    vqr = vqe_term * np.cos(delta_gen) - vde_term * np.sin(delta_gen)
    vdr = vqe_term * np.sin(delta_gen) + vde_term * np.cos(delta_gen)

    # Stator flux derivatives
    dpsiq = vqr - rs * iq + wr * psid
    dpsid = vdr - rs * id - wr * psiq

    # Field and damper flux derivatives
    rfd = 0.0006  # field resistance
    rkd = 0.02  # d-axis damper resistance
    rkq = 0.02  # q-axis damper resistance
    rkq2 = 0.03

    dpsipf = Ef_const - rfd * ipf
    dpsipkd = -rkd * ikd
    dpsipkq = -rkq * ikq + wr * psipkq2
    dpsipkq2 = -rkq2 * ikq2 - wr * psipkq

    # Electromagnetic torque
    Tem = psid * iq - psiq * id

    # Torsional dynamics
    # Mode 0 (uniform rotation)
    dslip = (Tmech_total - Tem - Domega * modal_speeds[0]) / (2 * H_total)
    ddelta_mode0 = modal_speeds[0] * wb

    # Modal equations for modes 1-5
    dmodal_speeds = np.zeros(5)
    dmodal_angles = np.zeros(5)

    for i in range(5):
        # Torque contribution to each mode (simplified)
        if i == 0:  # Mode 1
            T_modal = -Tem * Qbar[4, i+1]  # Generator contribution
        else:
            T_modal = 0.0

        # Modal equation: simple harmonic oscillator
        dmodal_speeds[i] = -(omega_modes[i+1]/wb)**2 * modal_angles[i] + T_modal / (2*H_total)
        dmodal_angles[i] = modal_speeds[i] * wb

    # Series capacitor dynamics
    Ccap = 1.0 / (wb * Xc)
    dvdc = ide / Ccap
    dvqc = iqe / Ccap

    # Transmission line dynamics
    Lline = Xline / wb
    didc = (vdc + vde_term - vde_inf - Rline * idc) / Lline
    diqc = (vqc + vqe_term - vqe_inf - Rline * iqc) / Lline

    dydt = [dpsid, dpsipf, dpsipkd, dpsipkq, dpsipkq2, dpsiq,
            ddelta_mode0, *dmodal_angles, dslip, *dmodal_speeds[1:],
            dvdc, dvqc, didc, diqc]

    return dydt

# Initial conditions (steady state)
psid0 = 0.8
psipf0 = 1.5
psipkd0 = 0.8
psipkq0 = -0.4
psipkq20 = -0.4
psiq0 = 1.0
delta_mode00 = 0.7
modal_angles0 = np.zeros(5)
modal_speeds0 = np.zeros(5)
vdc0 = 0.0
vqc0 = 0.0
idc0 = 0.0
iqc0 = 0.0

y0 = [psid0, psipf0, psipkd0, psipkq0, psipkq20, psiq0,
      delta_mode00, *modal_angles0, *modal_speeds0,
      vdc0, vqc0, idc0, iqc0]

# Solve
print("Simulating SSR with 6-mass torsional system...")
print(f"Series compensation: {Xc_percent*100:.0f}%")
sol = solve_ivp(model_equations, [0, t_stop], y0,
                method='RK45', rtol=rtol, atol=atol, max_step=1e-3)

# Extract results
t = sol.t
delta_mode0 = sol.y[6, :]
modal_angle1 = sol.y[7, :]
modal_angle2 = sol.y[8, :]

# Plot results
fig, axes = plt.subplots(3, 1, figsize=(10, 10))

# Mode 0 angle (uniform rotation)
axes[0].plot(t, delta_mode0 * 180/np.pi, 'b-', linewidth=2)
axes[0].set_ylabel('Mode 0 Angle (deg)')
axes[0].set_title('SSR - Torsional Modes')
axes[0].grid(True)

# Modal angle 1 (first torsional mode)
axes[1].plot(t, modal_angle1 * 180/np.pi, 'r-', linewidth=2)
axes[1].set_ylabel('Modal Angle 1 (deg)')
axes[1].grid(True)

# Modal angle 2 (second torsional mode)
axes[2].plot(t, modal_angle2 * 180/np.pi, 'g-', linewidth=2)
axes[2].set_xlabel('Time (s)')
axes[2].set_ylabel('Modal Angle 2 (deg)')
axes[2].grid(True)

plt.tight_layout()
plt.savefig('/home/rodo/Maquinas/C10/S3_SSR_results.png', dpi=150)
print(f"Results saved to S3_SSR_results.png")
plt.show()

print(f"Modal frequencies: {omega_modes[1:]} rad/s")
print(f"Simulation completed successfully")
