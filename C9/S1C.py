"""
V/f Closed Loop Control of Induction Motor
Implements constant V/f ratio control with speed feedback
Based on s1c.mdl - Project 1 closed loop
"""
import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt
import sys
sys.path.append('/home/rodo/Maquinas/C9')
from p20hp import *

# Simulation parameters
t_stop = 2.0  # simulation time in seconds
rtol = 1e-5
atol = 1e-6

# Machine parameters in per unit (from p20hp.py)
rs_pu = rs / Zb
xls_pu = xls / Zb
xm_pu = xm / Zb
xplr_pu = xplr / Zb
rpr_pu = rpr / Zb

# Inductances in per unit
Lls = xls_pu / wb
Lm = xm_pu / wb
Llr = xplr_pu / wb
Ls = Lls + Lm
Lr = Llr + Lm

# V/f control parameters
Vf_ratio = Vb / frated  # V/Hz ratio
f_base = frated
slip_limit = 0.1  # maximum slip

# Speed controller (PI controller)
Kp_speed = 10.0
Ki_speed = 50.0

# Speed reference profile
def speed_ref(t):
    """Speed reference in per unit"""
    if t < 0.1:
        return 0.0
    elif t < 0.5:
        return (t - 0.1) / 0.4 * 0.8  # ramp to 0.8 pu
    else:
        return 0.8

# Mechanical torque
def Tmech(wr):
    """Load torque as function of speed"""
    TL = 0.3  # constant load torque in pu
    return TL

def model_equations(t, y):
    """
    Induction motor with V/f closed-loop control
    States: [psiqs, psids, psiqr, psidr, wr, theta, speed_int, i0s]
    """
    psiqs, psids, psiqr, psidr, wr, theta, speed_int, i0s = y

    # Speed controller
    wr_ref = speed_ref(t)
    speed_error = wr_ref - wr
    slip_cmd = Kp_speed * speed_error + Ki_speed * speed_int

    # Limit slip
    slip_cmd = np.clip(slip_cmd, -slip_limit, slip_limit)

    # Calculate electrical frequency from slip
    we = wr + slip_cmd  # electrical frequency in pu
    we = max(we, 0.1)  # minimum frequency

    # V/f control: voltage magnitude proportional to frequency
    Vs_mag = (we / 1.0) * 1.0  # voltage in pu (we in pu of rated)
    Vs_mag = min(Vs_mag, 1.0)  # limit to rated voltage

    # Three-phase voltages in stationary frame
    vqs = Vs_mag * np.cos(theta)
    vds = Vs_mag * np.sin(theta)
    v0s = 0.0

    # Stator currents from flux linkages
    Det = Ls * Lr - Lm * Lm
    iqs = (Lr * psiqs - Lm * psiqr) / Det
    ids = (Lr * psids - Lm * psidr) / Det

    # Rotor currents
    iqr = (Ls * psiqr - Lm * psiqs) / Det
    idr = (Ls * psidr - Lm * psids) / Det

    # Stator flux derivatives (in stationary reference frame)
    dpsiqs = vqs - rs_pu * iqs
    dpsids = vds - rs_pu * ids

    # Rotor flux derivatives (in rotor reference frame, transformed)
    dpsiqr = -rpr_pu * iqr - wr * psidr
    dpsidr = -rpr_pu * idr + wr * psiqr

    # Electromagnetic torque
    Tem = psiqs * ids - psids * iqs

    # Mechanical equation
    TL = Tmech(wr)
    dwr = (Tem - TL - Domega * wr) / (2 * H)

    # Angle integration
    dtheta = we * wb

    # Speed controller integrator
    dspeed_int = speed_error

    # Zero sequence current
    di0s = (v0s - rs_pu * i0s) * wb / xls_pu

    return [dpsiqs, dpsids, dpsiqr, dpsidr, dwr, dtheta, dspeed_int, di0s]

# Initial conditions
# Start from zero speed, zero flux
psiqs0 = 0.0
psids0 = 0.0
psiqr0 = 0.0
psidr0 = 0.0
wr0 = 0.0
theta0 = 0.0
speed_int0 = 0.0
i0s0 = 0.0

y0 = [psiqs0, psids0, psiqr0, psidr0, wr0, theta0, speed_int0, i0s0]

# Solve ODE
print("Simulating V/f closed-loop control...")
sol = solve_ivp(model_equations, [0, t_stop], y0,
                method='RK45', rtol=rtol, atol=atol, max_step=1e-3)

# Extract results
t = sol.t
psiqs = sol.y[0, :]
psids = sol.y[1, :]
psiqr = sol.y[2, :]
psidr = sol.y[3, :]
wr = sol.y[4, :]
theta = sol.y[5, :]

# Calculate currents and torque
iqs_array = []
ids_array = []
Tem_array = []
wr_ref_array = []

Det = Ls * Lr - Lm * Lm
for i in range(len(t)):
    iqs = (Lr * psiqs[i] - Lm * psiqr[i]) / Det
    ids = (Lr * psids[i] - Lm * psidr[i]) / Det
    Tem = psiqs[i] * ids - psids[i] * iqs
    iqs_array.append(iqs)
    ids_array.append(ids)
    Tem_array.append(Tem)
    wr_ref_array.append(speed_ref(t[i]))

iqs_array = np.array(iqs_array)
ids_array = np.array(ids_array)
Tem_array = np.array(Tem_array)
wr_ref_array = np.array(wr_ref_array)

# Calculate stator current magnitude
Is_mag = np.sqrt(iqs_array**2 + ids_array**2)

# Plot results
fig, axes = plt.subplots(3, 1, figsize=(10, 10))

# Speed
axes[0].plot(t, wr, 'b-', linewidth=2, label='Actual speed')
axes[0].plot(t, wr_ref_array, 'r--', linewidth=1.5, label='Reference speed')
axes[0].set_ylabel('Speed (pu)')
axes[0].set_title('V/f Closed Loop Control - Induction Motor')
axes[0].grid(True)
axes[0].legend()

# Torque
axes[1].plot(t, Tem_array, 'g-', linewidth=2)
axes[1].set_ylabel('Torque (pu)')
axes[1].grid(True)
axes[1].axhline(y=0.3, color='r', linestyle='--', label='Load torque')
axes[1].legend()

# Stator current
axes[2].plot(t, Is_mag, 'b-', linewidth=2)
axes[2].set_xlabel('Time (s)')
axes[2].set_ylabel('Stator Current (pu)')
axes[2].grid(True)

plt.tight_layout()
plt.savefig('/home/rodo/Maquinas/C9/S1C_results.png', dpi=150)
print(f"Results saved to S1C_results.png")
plt.show()

print(f"Final speed: {wr[-1]:.4f} pu")
print(f"Final torque: {Tem_array[-1]:.4f} pu")
print(f"Final current: {Is_mag[-1]:.4f} pu")
