"""
Power System Stabilizer (PSS) with Synchronous Generator
Implements PSS washout and lead-lag compensators
Based on s4.mdl - PSS study
"""
import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt
import sys
sys.path.append('/home/rodo/Maquinas/C10')
from set1 import *

# Simulation parameters
t_stop = 10.0
rtol = 1e-6
atol = 1e-6

# Generator parameters (from set1.py in per unit)
wb = 2 * np.pi * Frated

# PSS parameters
PSS_enabled = True  # Switch to enable/disable PSS
Kpss = 20.0  # PSS gain
Tw = 5.0  # Washout time constant
T1 = 0.05  # Lead time constant 1
T2 = 0.02  # Lag time constant 1
T3 = 3.0  # Lead time constant 2
T4 = 5.4  # Lag time constant 2
Vs_max = 0.1  # PSS output limit
Vs_min = -0.1

# Voltage reference
Vref = 1.0

# Infinite bus voltage
vqe = 0.0
vde = 1.0

# Mechanical torque disturbance
def Tmech_input(t):
    """Step change in mechanical torque"""
    Tm0 = 0.9  # initial torque
    if t < 1.0:
        return Tm0
    else:
        return Tm0 + 0.1  # 10% increase

def model_equations(t, y):
    """
    Generator with PSS and IEEE Type 1 Exciter
    States: [Edp, Eqp, delta, slip, Ef, VR, Vs, wash_out, comp1_x, comp2_x]
    """
    Edp, Eqp, delta, slip, Ef, VR, Vs_state, wash_out, comp1_x, comp2_x = y

    # Mechanical torque
    Tmech = Tmech_input(t)

    # Rotor speed
    wr = 1.0 + slip

    # Transform infinite bus voltage to rotor frame
    vqr = vqe * np.cos(delta) - vde * np.sin(delta)
    vdr = vqe * np.sin(delta) + vde * np.cos(delta)

    # Stator algebraic equations
    iq = (Eqp - vqr) / (rs + xpd)
    id = (Edp - vdr) / (rs + xpq)

    # Terminal voltage in rotor frame
    vqt = vqr + rs * iq
    vdt = vdr + rs * id

    # Terminal voltage magnitude
    Vt = np.sqrt(vqt**2 + vdt**2)

    # Electromagnetic torque
    Tem = Eqp * iq + Edp * id + (xpq - xpd) * id * iq

    # Rotor dynamics
    ddelta = slip * wb
    dslip = (Tmech - Tem - Domega * slip) / (2 * H)

    # Transient EMF dynamics
    dEdp = (-Edp + (xq - xpq) * iq) / Tpqo
    dEqp = (-Eqp + (xd - xpd) * id + Ef) / Tpdo

    # PSS: Washout filter (high-pass)
    dwash_out = (-wash_out + slip) / Tw

    # PSS: Lead-lag compensator 1
    comp1_in = Kpss * wash_out
    dcomp1_x = (-comp1_x + comp1_in) / T2
    comp1_out = (T1 / T2) * comp1_x + ((T1 - T2) / T2) * comp1_in

    # PSS: Lead-lag compensator 2
    dcomp2_x = (-comp2_x + comp1_out) / T4
    comp2_out = (T3 / T4) * comp2_x + ((T3 - T4) / T4) * comp1_out

    # PSS output with limiter
    if PSS_enabled:
        Vs_pss = np.clip(comp2_out, Vs_min, Vs_max)
    else:
        Vs_pss = 0.0

    # Exciter: IEEE Type 1
    # Voltage error
    Verr = Vref + Vs_pss - Vt

    # Saturation function
    Se = AEx * np.exp(BEx * abs(Ef))

    # Exciter states
    dVs = (-Vs_state + KF / TF * Ef) / TF
    dVR = (-VR + KA * (Verr - Vs_state)) / TA
    VR_sat = np.clip(VR, VRmin, VRmax)

    dEf = (-Ef * (1 + Se) + VR_sat) / TE

    return [dEdp, dEqp, ddelta, dslip, dEf, dVR, dVs, dwash_out, dcomp1_x, dcomp2_x]

# Initial conditions from steady state
# Assume steady state at t=0
Tmech0 = Tmech_input(0)
vqr0 = vqe
vdr0 = vde

# Initial guess for steady state
delta0 = 0.7  # rad
Eqp0 = 1.2
Edp0 = 0.0
slip0 = 0.0
Ef0 = 1.8

# Iterative calculation for better initial conditions
for _ in range(10):
    vqr0 = vqe * np.cos(delta0) - vde * np.sin(delta0)
    vdr0 = vqe * np.sin(delta0) + vde * np.cos(delta0)
    iq0 = (Eqp0 - vqr0) / (rs + xpd)
    id0 = (Edp0 - vdr0) / (rs + xpq)
    Tem0 = Eqp0 * iq0 + Edp0 * id0

    # Update
    delta0 = np.arcsin(Tmech0 / (Eqp0 * (vde / (rs + xpd))))
    Edp0 = (xq - xpq) * iq0
    Ef0 = Eqp0 - (xd - xpd) * id0

vqt0 = vqr0 + rs * iq0
vdt0 = vdr0 + rs * id0
Vt0 = np.sqrt(vqt0**2 + vdt0**2)

# Exciter initial conditions
Se0 = AEx * np.exp(BEx * abs(Ef0))
VR0 = Ef0 * (1 + Se0)
Vs0 = KF / TF * Ef0

# PSS initial conditions
wash_out0 = 0.0
comp1_x0 = 0.0
comp2_x0 = 0.0

y0 = [Edp0, Eqp0, delta0, slip0, Ef0, VR0, Vs0, wash_out0, comp1_x0, comp2_x0]

# Solve
print("Simulating generator with PSS...")
print(f"PSS {'ENABLED' if PSS_enabled else 'DISABLED'}")
sol = solve_ivp(model_equations, [0, t_stop], y0,
                method='RK45', rtol=rtol, atol=atol, max_step=0.01)

# Extract results
t = sol.t
Edp = sol.y[0, :]
Eqp = sol.y[1, :]
delta = sol.y[2, :]
slip = sol.y[3, :]
Ef = sol.y[4, :]

# Calculate additional quantities
wr = 1.0 + slip
delta_deg = delta * 180 / np.pi
freq = Frated * wr

# Calculate terminal voltage and power
Vt_array = []
Pgen_array = []
Tem_array = []

for i in range(len(t)):
    vqr = vqe * np.cos(delta[i]) - vde * np.sin(delta[i])
    vdr = vqe * np.sin(delta[i]) + vde * np.cos(delta[i])
    iq = (Eqp[i] - vqr) / (rs + xpd)
    id = (Edp[i] - vdr) / (rs + xpq)
    vqt = vqr + rs * iq
    vdt = vdr + rs * id
    Vt = np.sqrt(vqt**2 + vdt**2)
    Pgen = vqt * iq + vdt * id
    Tem = Eqp[i] * iq + Edp[i] * id

    Vt_array.append(Vt)
    Pgen_array.append(Pgen)
    Tem_array.append(Tem)

Vt_array = np.array(Vt_array)
Pgen_array = np.array(Pgen_array)
Tem_array = np.array(Tem_array)

# Plot results
fig, axes = plt.subplots(4, 1, figsize=(10, 12))

# Rotor angle
axes[0].plot(t, delta_deg, 'b-', linewidth=2)
axes[0].set_ylabel('Rotor Angle (deg)')
axes[0].set_title(f'Generator with PSS - {"Enabled" if PSS_enabled else "Disabled"}')
axes[0].grid(True)
axes[0].axvline(x=1.0, color='r', linestyle='--', alpha=0.5)

# Speed deviation
axes[1].plot(t, slip * 100, 'r-', linewidth=2)
axes[1].set_ylabel('Speed Deviation (%)')
axes[1].grid(True)
axes[1].axhline(y=0, color='k', linestyle='-', linewidth=0.5)
axes[1].axvline(x=1.0, color='r', linestyle='--', alpha=0.5)

# Terminal voltage
axes[2].plot(t, Vt_array, 'g-', linewidth=2)
axes[2].set_ylabel('Terminal Voltage (pu)')
axes[2].grid(True)
axes[2].axhline(y=1.0, color='k', linestyle='-', linewidth=0.5)
axes[2].axvline(x=1.0, color='r', linestyle='--', alpha=0.5)

# Active power
axes[3].plot(t, Pgen_array, 'b-', linewidth=2)
axes[3].set_xlabel('Time (s)')
axes[3].set_ylabel('Active Power (pu)')
axes[3].grid(True)
axes[3].axvline(x=1.0, color='r', linestyle='--', alpha=0.5, label='Torque step')
axes[3].legend()

plt.tight_layout()
filename = '/home/rodo/Maquinas/C10/S4_PSS_results.png'
plt.savefig(filename, dpi=150)
print(f"Results saved to {filename}")
plt.show()

print(f"\nInitial conditions:")
print(f"  Delta: {delta[0]*180/np.pi:.2f} deg")
print(f"  Vt: {Vt_array[0]:.4f} pu")
print(f"  Pgen: {Pgen_array[0]:.4f} pu")
print(f"\nFinal values:")
print(f"  Delta: {delta[-1]*180/np.pi:.2f} deg")
print(f"  Speed: {wr[-1]:.6f} pu")
print(f"  Vt: {Vt_array[-1]:.4f} pu")
