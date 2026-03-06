"""
V/f Open Loop Control of Induction Motor
Implements constant V/f ratio control without speed feedback
Based on s1o.mdl - Project 1 open loop
"""
import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt
import sys
sys.path.append('/home/rodo/Maquinas/C9')
from p20hp import *

# Simulation parameters
t_stop = 2.0
rtol = 1e-5
atol = 1e-6

# Machine parameters in per unit
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

# Open loop frequency command
def freq_cmd(t):
    """Frequency command in Hz"""
    if t < 0.1:
        return 1.0  # start at low frequency
    elif t < 1.0:
        return 1.0 + (t - 0.1) / 0.9 * 59.0  # ramp to 60 Hz
    else:
        return 60.0

# V/f control
def voltage_cmd(f):
    """Voltage magnitude in pu based on frequency"""
    Vs = (f / frated) * 1.0  # V/f = constant
    return min(Vs, 1.0)  # limit to rated

# Mechanical load torque
def Tmech(wr):
    """Load torque proportional to speed squared (fan load)"""
    TL = 0.5 * (wr / 1.0)**2
    return TL

def model_equations(t, y):
    """
    Induction motor with V/f open-loop control
    States: [psiqs, psids, psiqr, psidr, wr, theta, i0s]
    """
    psiqs, psids, psiqr, psidr, wr, theta, i0s = y

    # Open loop frequency command
    f_cmd = freq_cmd(t)
    we = 2 * np.pi * f_cmd / wb  # electrical frequency in pu

    # Voltage from V/f control
    Vs_mag = voltage_cmd(f_cmd)

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

    # Stator flux derivatives (stationary frame)
    dpsiqs = vqs - rs_pu * iqs
    dpsids = vds - rs_pu * ids

    # Rotor flux derivatives (rotor frame)
    dpsiqr = -rpr_pu * iqr - wr * psidr
    dpsidr = -rpr_pu * idr + wr * psiqr

    # Electromagnetic torque
    Tem = psiqs * ids - psids * iqs

    # Mechanical equation
    TL = Tmech(wr)
    dwr = (Tem - TL - Domega * wr) / (2 * H)

    # Angle integration
    dtheta = we * wb

    # Zero sequence
    di0s = (v0s - rs_pu * i0s) * wb / xls_pu

    return [dpsiqs, dpsids, dpsiqr, dpsidr, dwr, dtheta, di0s]

# Initial conditions
psiqs0 = 0.0
psids0 = 0.0
psiqr0 = 0.0
psidr0 = 0.0
wr0 = 0.0
theta0 = 0.0
i0s0 = 0.0

y0 = [psiqs0, psids0, psiqr0, psidr0, wr0, theta0, i0s0]

# Solve ODE
print("Simulating V/f open-loop control...")
sol = solve_ivp(model_equations, [0, t_stop], y0,
                method='RK45', rtol=rtol, atol=atol, max_step=1e-3)

# Extract results
t = sol.t
psiqs = sol.y[0, :]
psids = sol.y[1, :]
psiqr = sol.y[2, :]
psidr = sol.y[3, :]
wr = sol.y[4, :]

# Calculate slip
Det = Ls * Lr - Lm * Lm
slip_array = []
freq_array = []
Tem_array = []
Is_array = []

for i in range(len(t)):
    f_cmd = freq_cmd(t[i])
    we_sync = 2 * np.pi * f_cmd / wb
    slip = (we_sync - wr[i]) / we_sync if we_sync > 0 else 0

    iqs = (Lr * psiqs[i] - Lm * psiqr[i]) / Det
    ids = (Lr * psids[i] - Lm * psidr[i]) / Det
    Tem = psiqs[i] * ids - psids[i] * iqs
    Is = np.sqrt(iqs**2 + ids**2)

    slip_array.append(slip)
    freq_array.append(f_cmd)
    Tem_array.append(Tem)
    Is_array.append(Is)

slip_array = np.array(slip_array)
freq_array = np.array(freq_array)
Tem_array = np.array(Tem_array)
Is_array = np.array(Is_array)

# Convert speed to rpm
wr_rpm = wr * wbm * 60 / (2 * np.pi)

# Plot results
fig, axes = plt.subplots(4, 1, figsize=(10, 12))

# Speed
axes[0].plot(t, wr_rpm, 'b-', linewidth=2)
axes[0].set_ylabel('Speed (rpm)')
axes[0].set_title('V/f Open Loop Control - Induction Motor')
axes[0].grid(True)

# Frequency command
axes[1].plot(t, freq_array, 'r-', linewidth=2)
axes[1].set_ylabel('Frequency (Hz)')
axes[1].grid(True)

# Slip
axes[2].plot(t, slip_array * 100, 'g-', linewidth=2)
axes[2].set_ylabel('Slip (%)')
axes[2].grid(True)

# Torque and Current
ax3a = axes[3]
ax3b = ax3a.twinx()
ax3a.plot(t, Tem_array, 'b-', linewidth=2, label='Torque')
ax3b.plot(t, Is_array, 'r-', linewidth=2, label='Current')
ax3a.set_xlabel('Time (s)')
ax3a.set_ylabel('Torque (pu)', color='b')
ax3b.set_ylabel('Current (pu)', color='r')
ax3a.grid(True)
ax3a.legend(loc='upper left')
ax3b.legend(loc='upper right')

plt.tight_layout()
plt.savefig('/home/rodo/Maquinas/C9/S1O_results.png', dpi=150)
print(f"Results saved to S1O_results.png")
plt.show()

print(f"Final speed: {wr_rpm[-1]:.1f} rpm")
print(f"Final slip: {slip_array[-1]*100:.2f}%")
print(f"Final torque: {Tem_array[-1]:.4f} pu")
