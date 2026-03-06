"""
C7/S1 - Synchronous Generator Simulation (Enhanced)
Implements complete dq0 synchronous machine equations with field and damper windings
Based on m1.py parameters and s1.mdl structure
"""

import numpy as np
from scipy.integrate import solve_ivp
from scipy.interpolate import interp1d
import matplotlib.pyplot as plt
import sys
from pathlib import Path

# Add C7 directory to path
sys.path.insert(0, str(Path(__file__).parent))

# Import parameters from m1.py
# User should run m1.py first to set up parameters
# For standalone operation, we'll use default set1 parameters
try:
    from set1 import *
except ImportError:
    print("Warning: set1.py not found, using default parameters")
    Frated = 60
    Poles = 4
    Pfrated = 0.9
    Vrated = 18e3
    Prated = 828315e3
    rs = 0.0048
    xd = 1.790
    xq = 1.660
    xls = 0.215
    xpd = 0.355
    xpq = 0.570
    xppd = 0.275
    xppq = 0.275
    Tpdo = 7.9
    Tpqo = 0.410
    Tppdo = 0.032
    Tppqo = 0.055
    H = 3.77
    Domega = 0

# Calculate base quantities
we = 2*np.pi*Frated
wbase = 2*np.pi*Frated
wbasem = wbase*(2/Poles)
Sbase = Prated/Pfrated
Vbase = Vrated*np.sqrt(2/3)
Ibase = np.sqrt(2)*(Sbase/(np.sqrt(3)*Vrated))
Zbase = Vbase/Ibase
Tbase = Sbase/wbasem

# Calculate dq0 equivalent circuit parameters
if xls == 0:
    xls = 0.215  # assume leakage reactance

xmq = xq - xls
xmd = xd - xls

xplf = xmd*(xpd - xls)/(xmd - (xpd-xls))
xplkd = xmd*xplf*(xppd-xls)/(xplf*xmd - (xppd-xls)*(xmd+xplf))
xplkq = xmq*(xppq - xls)/(xmq - (xppq-xls))

rpf = (xplf + xmd)/(wbase*Tpdo)
rpkd = (xplkd + xpd - xls)/(wbase*Tppdo)
rpkq = (xplkq + xmq)/(wbase*Tppqo)

# Compute settings for variables in simulation
wb = wbase
xMQ = (1/xls + 1/xmq + 1/xplkq)**(-1)
xMD = (1/xls + 1/xmd + 1/xplf + 1/xplkd)**(-1)

# Specify desired operating condition
P = 1.0  # per unit real power (negative for motoring)
Q = 0.0  # per unit reactive power
Vt = 1.0 + 0*1j  # terminal voltage
thetaeo = np.angle(Vt)
Vm = np.abs(Vt)
St = P + Q*1j

# Steady-state initialization
It = np.conj(St/Vt)
Eq = Vt + (rs + 1j*xq)*It
delt = np.angle(Eq)

# Compute q-d steady-state variables
Eqo = np.abs(Eq)
I = It*(np.cos(delt) - np.sin(delt)*1j)
Iqo = np.real(I)
Ido = -np.imag(I)
Efo = Eqo + (xd-xq)*Ido
Ifo = Efo/xmd

Psiado = xmd*(-Ido + Ifo)
Psiaqo = xmq*(-Iqo)

Psiqo = xls*(-Iqo) + Psiaqo
Psido = xls*(-Ido) + Psiado
Psifo = xplf*Ifo + Psiado
Psikqo = Psiaqo
Psikdo = Psiado

Vto = Vt*(np.cos(delt) - np.sin(delt)*1j)
Vqo = np.real(Vto)
Vdo = -np.imag(Vto)
Sto = Vto*np.conj(I)
Eqpo = Vqo + xpd*Ido + rs*Iqo
Edpo = Vdo - xpq*Iqo + rs*Ido

delto = delt
thetaro = delto + thetaeo
Pemo = np.real(Sto)
Qemo = np.imag(Sto)
Tmech = Pemo

# Setup disturbance sequences
# Default: step change in Ef at t=0.2
tstop = 5.0
Vm_time = np.array([0, tstop])
Vm_value = np.array([Vm, Vm])

tmech_time = np.array([0, tstop])
tmech_value = np.array([Tmech, Tmech])

Ex_time = np.array([0, 0.2, 0.2, tstop])
Ex_value = np.array([Efo, Efo, 1.1*Efo, 1.1*Efo])

print("="*70)
print("C7/S1 - SYNCHRONOUS GENERATOR SIMULATION")
print("="*70)
print(f"Initial Conditions:")
print(f"  Real Power P: {P:.3f} pu")
print(f"  Reactive Power Q: {Q:.3f} pu")
print(f"  Terminal Voltage: {Vm:.3f} pu")
print(f"  Rotor Angle: {np.degrees(delto):.2f} degrees")
print(f"  Field Current: {Ifo:.4f} pu")
print(f"Disturbance: Step change in Ef from {Efo:.3f} to {1.1*Efo:.3f} pu at t=0.2s")
print("="*70)


def sync_gen_equations(t, y):
    """
    Synchronous Generator dq0 Equations
    States: [delta, Psiq, Psikq, Psid, Psif, Psikd, wm]
    """
    delta, Psiq, Psikq, Psid, Psif, Psikd, wm = y

    # Air-gap flux linkages (mutual fluxes)
    Psiaq = xMQ * (Psiq/xls + Psikq/xplkq)
    Psiad = xMD * (Psid/xls + Psif/xplf + Psikd/xplkd)

    # Currents
    iq = (Psiq - Psiaq) / xls
    ikq = (Psikq - Psiaq) / xplkq
    id_val = (Psid - Psiad) / xls
    iif = (Psif - Psiad) / xplf
    ikd = (Psikd - Psiad) / xplkd

    # Terminal voltages from grid (with possible disturbances)
    Vm_t = np.interp(t, Vm_time, Vm_value)

    # dq voltages in rotor reference frame
    vq = Vm_t * np.cos(delta - thetaeo)
    vd = -Vm_t * np.sin(delta - thetaeo)

    # Field voltage (excitation control)
    Ef_t = np.interp(t, Ex_time, Ex_value)
    vf = Ef_t

    # Mechanical torque
    Tm = np.interp(t, tmech_time, tmech_value)

    # Electromagnetic torque
    Te = Psid * iq - Psiq * id_val

    # State derivatives
    dPsiq_dt = vq + rs * iq - wb * wm * Psid
    dPsid_dt = vd + rs * id_val + wb * wm * Psiq

    dPsif_dt = vf - rpf * iif
    dPsikd_dt = -rpkd * ikd
    dPsikq_dt = -rpkq * ikq

    dwm_dt = (Tm - Te - Domega * (wm - 1.0)) / (2 * H)

    ddelta_dt = wb * (wm - 1.0)

    return [ddelta_dt, dPsiq_dt, dPsikq_dt, dPsid_dt, dPsif_dt, dPsikd_dt, dwm_dt]


# Initial conditions
y0 = [delto, Psiqo, Psikqo, Psido, Psifo, Psikdo, 1.0]

# Event to detect instability
def unstable_event(t, y):
    delta = y[0]
    return np.abs(delta) - np.pi

unstable_event.terminal = True

# Solve
print("Solving differential equations...")
sol = solve_ivp(
    sync_gen_equations,
    [0, tstop],
    y0,
    method='RK45',
    rtol=5e-6,
    atol=1e-6,
    dense_output=True,
    max_step=5e-3,
    events=unstable_event
)

if sol.status == 1:
    print("Warning: Instability detected (loss of synchronism)")
elif sol.success:
    print(f"Simulation completed successfully! ({len(sol.t)} time steps)")

# Extract results
t = sol.t
delta = sol.y[0, :]
Psiq = sol.y[1, :]
Psikq = sol.y[2, :]
Psid = sol.y[3, :]
Psif = sol.y[4, :]
Psikd = sol.y[5, :]
wm = sol.y[6, :]

# Calculate additional quantities
n_points = len(t)
iq = np.zeros(n_points)
id_val = np.zeros(n_points)
iif = np.zeros(n_points)
Te = np.zeros(n_points)
Pe = np.zeros(n_points)
Qe = np.zeros(n_points)
Vt_mag = np.zeros(n_points)

for i in range(n_points):
    Psiaq = xMQ * (Psiq[i]/xls + Psikq[i]/xplkq)
    Psiad = xMD * (Psid[i]/xls + Psif[i]/xplf + Psikd[i]/xplkd)

    iq[i] = (Psiq[i] - Psiaq) / xls
    id_val[i] = (Psid[i] - Psiad) / xls
    iif[i] = (Psif[i] - Psiad) / xplf

    Te[i] = Psid[i] * iq[i] - Psiq[i] * id_val[i]

    # Terminal voltage magnitude
    vq_t = Vm * np.cos(delta[i] - thetaeo)
    vd_t = -Vm * np.sin(delta[i] - thetaeo)
    Vt_mag[i] = np.sqrt(vq_t**2 + vd_t**2)

    # Powers
    Pe[i] = vq_t * iq[i] + vd_t * id_val[i]
    Qe[i] = vq_t * id_val[i] - vd_t * iq[i]

# Convert angles to degrees
delta_deg = np.degrees(delta)

# Plotting
fig = plt.figure(figsize=(15, 10))
fig.suptitle('C7/S1 - Synchronous Generator Response', fontsize=14, fontweight='bold')

# Row 1
ax1 = plt.subplot(3, 3, 1)
ax1.plot(t, delta_deg, 'b-', linewidth=2)
ax1.set_ylabel('Rotor Angle δ (deg)')
ax1.set_title('Rotor Angle')
ax1.grid(True)
ax1.axhline(y=np.degrees(delto), color='k', linestyle='--', alpha=0.3)

ax2 = plt.subplot(3, 3, 2)
ax2.plot(t, wm, 'r-', linewidth=2)
ax2.set_ylabel('Speed ω (pu)')
ax2.set_title('Rotor Speed')
ax2.axhline(y=1.0, color='k', linestyle='--', alpha=0.3, label='Synchronous')
ax2.legend()
ax2.grid(True)

ax3 = plt.subplot(3, 3, 3)
ax3.plot(t, iif, 'g-', linewidth=2)
ax3.set_ylabel('Field Current (pu)')
ax3.set_title('Field Current')
ax3.grid(True)

# Row 2
ax4 = plt.subplot(3, 3, 4)
ax4.plot(t, iq, 'm-', linewidth=2, label='iq')
ax4.plot(t, id_val, 'c-', linewidth=2, label='id')
ax4.set_ylabel('Stator Currents (pu)')
ax4.set_title('Stator dq Currents')
ax4.legend()
ax4.grid(True)

ax5 = plt.subplot(3, 3, 5)
ax5.plot(t, Te, 'k-', linewidth=2)
ax5.set_ylabel('Torque (pu)')
ax5.set_title('Electromagnetic Torque')
ax5.grid(True)

ax6 = plt.subplot(3, 3, 6)
ax6.plot(t, Pe, 'orange', linewidth=2, label='P')
ax6.plot(t, Qe, 'purple', linewidth=2, label='Q')
ax6.set_ylabel('Power (pu)')
ax6.set_title('Electrical Power')
ax6.legend()
ax6.grid(True)

# Row 3
ax7 = plt.subplot(3, 3, 7)
ax7.plot(t, Psiq, 'b-', linewidth=2, label='ψq')
ax7.plot(t, Psid, 'r-', linewidth=2, label='ψd')
ax7.set_ylabel('Stator Flux (pu)')
ax7.set_xlabel('Time (s)')
ax7.set_title('Stator Flux Linkages')
ax7.legend()
ax7.grid(True)

ax8 = plt.subplot(3, 3, 8)
ax8.plot(t, Psif, 'g-', linewidth=2)
ax8.set_ylabel('Field Flux (pu)')
ax8.set_xlabel('Time (s)')
ax8.set_title('Field Flux Linkage')
ax8.grid(True)

ax9 = plt.subplot(3, 3, 9)
ax9.plot(t, Psikq, 'm-', linewidth=2, label='ψkq')
ax9.plot(t, Psikd, 'c-', linewidth=2, label='ψkd')
ax9.set_ylabel('Damper Flux (pu)')
ax9.set_xlabel('Time (s)')
ax9.set_title('Damper Flux Linkages')
ax9.legend()
ax9.grid(True)

plt.tight_layout()
plt.savefig(str(Path(__file__).parent / 's1_results.png'), dpi=300, bbox_inches='tight')
print(f"Plot saved as s1_results.png")

# Print final values
print("\nFinal Values:")
print(f"  Rotor Angle: {delta_deg[-1]:.2f} degrees")
print(f"  Rotor Speed: {wm[-1]:.6f} pu")
print(f"  Field Current: {iif[-1]:.4f} pu")
print(f"  q-axis Current: {iq[-1]:.4f} pu")
print(f"  d-axis Current: {id_val[-1]:.4f} pu")
print(f"  Electromagnetic Torque: {Te[-1]:.4f} pu")
print(f"  Electrical Power P: {Pe[-1]:.4f} pu")
print(f"  Reactive Power Q: {Qe[-1]:.4f} pu")

plt.show()
