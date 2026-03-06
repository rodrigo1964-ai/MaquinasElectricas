"""
Field-Oriented Control (FOC) of Induction Motor
Implements rotor flux orientation with id*, iq* current control
Based on s3.mdl - Project 3 FOC
"""
import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt
import sys
sys.path.append('/home/rodo/Maquinas/C9')
from p20hp import *

# Simulation parameters
t_stop = 2.0
rtol = 1e-6
atol = 1e-6

# Machine parameters in per unit
rs_pu = rs / Zb
xls_pu = xls / Zb
xm_pu = xm / Zb
xplr_pu = xplr / Zb
rpr_pu = rpr / Zb

# Inductances
Lls = xls_pu / wb
Lm = xm_pu / wb
Llr = xplr_pu / wb
Ls = Lls + Lm
Lr = Llr + Lm

# FOC parameters
Tr = Lr / rpr_pu  # rotor time constant
lambda_r_ref = 0.8  # rotor flux reference in pu

# Torque controller (PI)
Kp_torque = 5.0
Ki_torque = 20.0

# Speed reference
def speed_ref(t):
    """Speed reference profile"""
    if t < 0.1:
        return 0.0
    elif t < 0.5:
        return (t - 0.1) / 0.4 * 1.0  # ramp to rated speed
    else:
        return 1.0

# Load torque
def Tmech(t, wr):
    """Step load at t=1.0s"""
    if t < 1.0:
        return 0.1
    else:
        return 0.5

def model_equations(t, y):
    """
    FOC induction motor control
    States: [psiqs, psids, psiqr, psidr, wr, theta_r, torque_int, i0s]
    """
    psiqs, psids, psiqr, psidr, wr, theta_r, torque_int, i0s = y

    # Calculate rotor flux magnitude
    lambda_dr = np.sqrt(psiqr**2 + psidr**2)

    # Field orientation: align d-axis with rotor flux
    if lambda_dr > 0.01:
        cos_rho = psidr / lambda_dr
        sin_rho = psiqr / lambda_dr
    else:
        cos_rho = 1.0
        sin_rho = 0.0

    # Stator currents in stationary frame
    Det = Ls * Lr - Lm * Lm
    iqs = (Lr * psiqs - Lm * psiqr) / Det
    ids = (Lr * psids - Lm * psidr) / Det

    # Transform to rotor flux frame
    ids_e = ids * cos_rho + iqs * sin_rho  # d-axis (aligned with flux)
    iqs_e = -ids * sin_rho + iqs * cos_rho  # q-axis (torque producing)

    # Field weakening logic
    if wr < 0.9:
        lambda_r_cmd = lambda_r_ref
    else:
        lambda_r_cmd = lambda_r_ref * 0.9 / wr  # reduce flux above base speed

    # d-axis current reference (flux control)
    ids_e_ref = lambda_r_cmd / Lm

    # Torque controller
    wr_ref = speed_ref(t)
    speed_error = wr_ref - wr
    Tem_ref = Kp_torque * speed_error + Ki_torque * torque_int

    # q-axis current reference (torque control)
    if lambda_dr > 0.01:
        iqs_e_ref = Tem_ref * Lr / (Lm * lambda_dr)
    else:
        iqs_e_ref = 0.0

    # Current controller (simple P control for voltage commands)
    Kp_curr = 50.0
    vds_e = Kp_curr * (ids_e_ref - ids_e)
    vqs_e = Kp_curr * (iqs_e_ref - iqs_e)

    # Limit voltages
    v_max = 1.0
    v_mag = np.sqrt(vds_e**2 + vqs_e**2)
    if v_mag > v_max:
        vds_e = vds_e * v_max / v_mag
        vqs_e = vqs_e * v_max / v_mag

    # Transform voltages back to stationary frame
    vqs = vqs_e * cos_rho - vds_e * sin_rho
    vds = vqs_e * sin_rho + vds_e * cos_rho
    v0s = 0.0

    # Rotor flux angle derivative (slip frequency)
    if lambda_dr > 0.01:
        we_slip = rpr_pu * iqs_e / lambda_dr
    else:
        we_slip = 0.0

    # Stator flux derivatives
    dpsiqs = vqs - rs_pu * iqs
    dpsids = vds - rs_pu * ids

    # Rotor flux derivatives
    dpsiqr = -rpr_pu * (Ls * psiqr - Lm * psiqs) / Det - wr * psidr
    dpsidr = -rpr_pu * (Ls * psidr - Lm * psids) / Det + wr * psiqr

    # Electromagnetic torque
    Tem = psiqs * ids - psids * iqs

    # Mechanical equation
    TL = Tmech(t, wr)
    dwr = (Tem - TL - Domega * wr) / (2 * H)

    # Rotor flux angle
    dtheta_r = (wr + we_slip) * wb

    # Torque controller integrator
    dtorque_int = speed_error

    # Zero sequence
    di0s = (v0s - rs_pu * i0s) * wb / xls_pu

    return [dpsiqs, dpsids, dpsiqr, dpsidr, dwr, dtheta_r, dtorque_int, di0s]

# Initial conditions
psiqs0 = 0.0
psids0 = 0.0
psiqr0 = 0.0
psidr0 = 0.0
wr0 = 0.0
theta_r0 = 0.0
torque_int0 = 0.0
i0s0 = 0.0

y0 = [psiqs0, psids0, psiqr0, psidr0, wr0, theta_r0, torque_int0, i0s0]

# Solve
print("Simulating Field-Oriented Control...")
sol = solve_ivp(model_equations, [0, t_stop], y0,
                method='RK45', rtol=rtol, atol=atol, max_step=1e-3)

# Extract results
t = sol.t
psiqs = sol.y[0, :]
psids = sol.y[1, :]
psiqr = sol.y[2, :]
psidr = sol.y[3, :]
wr = sol.y[4, :]

# Calculate derived quantities
Det = Ls * Lr - Lm * Lm
lambda_r = np.sqrt(psiqr**2 + psidr**2)
Tem_array = []
ids_e_array = []
iqs_e_array = []
wr_ref_array = []

for i in range(len(t)):
    iqs = (Lr * psiqs[i] - Lm * psiqr[i]) / Det
    ids = (Lr * psids[i] - Lm * psidr[i]) / Det
    Tem = psiqs[i] * ids - psids[i] * iqs

    # Transform to flux frame
    if lambda_r[i] > 0.01:
        cos_rho = psidr[i] / lambda_r[i]
        sin_rho = psiqr[i] / lambda_r[i]
    else:
        cos_rho = 1.0
        sin_rho = 0.0

    ids_e = ids * cos_rho + iqs * sin_rho
    iqs_e = -ids * sin_rho + iqs * cos_rho

    Tem_array.append(Tem)
    ids_e_array.append(ids_e)
    iqs_e_array.append(iqs_e)
    wr_ref_array.append(speed_ref(t[i]))

Tem_array = np.array(Tem_array)
ids_e_array = np.array(ids_e_array)
iqs_e_array = np.array(iqs_e_array)
wr_ref_array = np.array(wr_ref_array)

# Plot results
fig, axes = plt.subplots(4, 1, figsize=(10, 12))

# Speed tracking
axes[0].plot(t, wr, 'b-', linewidth=2, label='Actual')
axes[0].plot(t, wr_ref_array, 'r--', linewidth=1.5, label='Reference')
axes[0].set_ylabel('Speed (pu)')
axes[0].set_title('Field-Oriented Control - Induction Motor')
axes[0].grid(True)
axes[0].legend()

# Rotor flux
axes[1].plot(t, lambda_r, 'g-', linewidth=2)
axes[1].axhline(y=lambda_r_ref, color='r', linestyle='--', label='Reference')
axes[1].set_ylabel('Rotor Flux (pu)')
axes[1].grid(True)
axes[1].legend()

# Torque
axes[2].plot(t, Tem_array, 'b-', linewidth=2)
axes[2].set_ylabel('Torque (pu)')
axes[2].grid(True)

# d-q currents in flux frame
axes[3].plot(t, ids_e_array, 'b-', linewidth=2, label='ids (flux)')
axes[3].plot(t, iqs_e_array, 'r-', linewidth=2, label='iqs (torque)')
axes[3].set_xlabel('Time (s)')
axes[3].set_ylabel('Current (pu)')
axes[3].grid(True)
axes[3].legend()

plt.tight_layout()
plt.savefig('/home/rodo/Maquinas/C9/S3_FOC_results.png', dpi=150)
print(f"Results saved to S3_FOC_results.png")
plt.show()

print(f"Final speed: {wr[-1]:.4f} pu")
print(f"Final rotor flux: {lambda_r[-1]:.4f} pu")
print(f"Final torque: {Tem_array[-1]:.4f} pu")
