"""
C7/S4 - Permanent Magnet Synchronous Motor Simulation (Enhanced)
Implements complete PM motor equations in dq0 frame with damper windings
Based on m4.py parameters and s4.mdl structure
"""

import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt
import sys
from pathlib import Path

# Add C7 directory to path
sys.path.insert(0, str(Path(__file__).parent))

# PM Motor parameters from m4.py
Frated = 60  # 60 Hz source
Poles = 2    # 2 pole machine
Vrated = 230  # 230 V rms line to line
we = 2*np.pi*Frated
wbase = 2*np.pi*Frated
wbasem = wbase*(2/Poles)

# QD0 equivalent circuit parameters in per unit
Domega = 0  # rotor damping coefficient
H = 0.3
rs = 0.017
xls = 0.065
x0 = xls
xd = 0.543
xq = 1.086
xmq = xq - xls
xmd = xd - xls
rpkd = 0.054
rpkq = 0.108
xplkd = 0.132
xplkq = 0.132

# Compute mutual inductances
wb = wbase
xMQ = (1/xls + 1/xmq + 1/xplkq)**(-1)
xMD = (1/xls + 1/xmd + 1/xplkd)**(-1)

print("="*70)
print("C7/S4 - PERMANENT MAGNET SYNCHRONOUS MOTOR SIMULATION")
print("="*70)
print(f"Rated: 230V, 4hp, 2-pole, 60Hz, 3-phase")
print(f"Parameters (per unit):")
print(f"  H = {H}")
print(f"  rs = {rs}")
print(f"  xd = {xd}, xq = {xq}")
print(f"  xmd = {xmd}, xmq = {xmq}")
print("="*70)

# Operating condition setup
# Initialize with steady-state condition at rated load
Vt = 1.0 + 0*1j  # terminal voltage
Vm = np.abs(Vt)

# For PM motor starting from standstill
# Option 1: Start from rest
opt_initial = 2  # 1=steady-state, 2=from rest

# PM excitation (equivalent magnetizing current)
Ipm = 1.8  # per unit magnetizing current of permanent magnet

if opt_initial == 1:  # steady-state initialization
    # Example: running at rated condition
    Sm = -1.0 + 0*1j  # complex power into motor (negative for motoring)
    It = np.conj(Sm/Vt)
    Eq = Vt - (rs + 1j*xq)*It
    delt = np.angle(Eq)

    Eqo = np.abs(Eq)
    I = It*(np.cos(delt) - np.sin(delt)*1j)
    Iqo = np.real(I)
    Ido = -np.imag(I)
    Emo = Eqo - (xd-xq)*Ido

    # Initial flux linkages
    Psiado = xmd*(Ido + Ipm)
    Psiaqo = xmq*Iqo
    Psiqo = xls*Iqo + Psiaqo
    Psido = xls*Ido + Psiado
    Psikqo = Psiaqo
    Psikdo = Psiado
    wrslipo = 0  # synchronous speed
    delto = delt
    temo = (xd - xq)*Ido*Iqo + xmd*Ipm*Iqo

else:  # initialize from rest
    Psiado = xmd*Ipm  # PM field always present
    Psiaqo = 0
    Psiqo = Psiaqo
    Psido = Psiado
    Psikqo = Psiaqo
    Psikdo = Psiado
    wrslipo = -1  # at standstill
    delto = 0
    temo = 0
    Iqo = 0
    Ido = 0

print(f"Initial Condition: {'Steady-state' if opt_initial == 1 else 'Starting from rest'}")
print(f"  PM excitation Ipm: {Ipm:.3f} pu")
print(f"  Initial torque: {temo:.3f} pu")
print("="*70)

# Simulation parameters
tstop = 1.5
tmech_time = np.array([0, tstop])
tmech_value = np.array([-0.8, -0.8])  # Negative for motoring load


def pm_motor_equations(t, y):
    """
    PM Synchronous Motor Equations in dq0 Reference Frame
    States: [delta, Psiq, Psikq, Psid, Psikd, wr_slip]

    Where wr_slip = (wr - we)/we
    """
    delta, Psiq, Psikq, Psid, Psikd, wr_slip = y

    # Rotor speed
    wr = we * (1 + wr_slip)
    wm = wr / (Poles/2)  # mechanical speed

    # Air-gap flux linkages
    Psiaq = xMQ * (Psiq/xls + Psikq/xplkq)
    Psiad = xMD * (Psid/xls + (Psikd + xmd*Ipm)/xplkd)  # PM contribution

    # Currents
    iq = (Psiq - Psiaq) / xls
    ikq = (Psikq - Psiaq) / xplkq
    id_val = (Psid - Psiad) / xls
    ikd = (Psikd - Psiad + xmd*Ipm) / xplkd

    # Terminal voltages (constant voltage source)
    vq = Vm * np.cos(delta)
    vd = -Vm * np.sin(delta)

    # Mechanical torque (load)
    Tm = np.interp(t, tmech_time, tmech_value)

    # Electromagnetic torque
    Te = Psid * iq - Psiq * id_val

    # State derivatives
    # Stator flux derivatives
    dPsiq_dt = vq + rs * iq - wb * (1 + wr_slip) * Psid
    dPsid_dt = vd + rs * id_val + wb * (1 + wr_slip) * Psiq

    # Damper winding flux derivatives
    dPsikq_dt = -rpkq * ikq
    dPsikd_dt = -rpkd * ikd

    # Speed derivative (slip)
    dwr_slip_dt = (Te - Tm - Domega * wr_slip) / (2 * H)

    # Angle derivative
    ddelta_dt = wb * wr_slip

    return [ddelta_dt, dPsiq_dt, dPsikq_dt, dPsid_dt, dPsikd_dt, dwr_slip_dt]


# Initial conditions
y0 = [delto, Psiqo, Psikqo, Psido, Psikdo, wrslipo]

# Solve
print("Solving differential equations...")
sol = solve_ivp(
    pm_motor_equations,
    [0, tstop],
    y0,
    method='RK45',
    rtol=1e-5,
    atol=1e-6,
    dense_output=True,
    max_step=1e-3
)

if sol.success:
    print(f"Simulation completed successfully! ({len(sol.t)} time steps)")
else:
    print(f"Warning: {sol.message}")

# Extract results
t = sol.t
delta = sol.y[0, :]
Psiq = sol.y[1, :]
Psikq = sol.y[2, :]
Psid = sol.y[3, :]
Psikd = sol.y[4, :]
wr_slip = sol.y[5, :]

# Calculate additional quantities
n_points = len(t)
iq = np.zeros(n_points)
id_val = np.zeros(n_points)
Te = np.zeros(n_points)
Pe = np.zeros(n_points)
wr = np.zeros(n_points)
wm = np.zeros(n_points)

for i in range(n_points):
    Psiaq = xMQ * (Psiq[i]/xls + Psikq[i]/xplkq)
    Psiad = xMD * (Psid[i]/xls + (Psikd[i] + xmd*Ipm)/xplkd)

    iq[i] = (Psiq[i] - Psiaq) / xls
    id_val[i] = (Psid[i] - Psiad) / xls

    Te[i] = Psid[i] * iq[i] - Psiq[i] * id_val[i]

    wr[i] = we * (1 + wr_slip[i])
    wm[i] = wr[i] / (Poles/2)

    vq_t = Vm * np.cos(delta[i])
    vd_t = -Vm * np.sin(delta[i])
    Pe[i] = vq_t * iq[i] + vd_t * id_val[i]

# Convert to more common units
delta_deg = np.degrees(delta)
wm_pu = wm / wbasem
speed_rpm = wm * 60 / (2*np.pi)

# Plotting
fig = plt.figure(figsize=(14, 10))
fig.suptitle('C7/S4 - PM Synchronous Motor Starting', fontsize=14, fontweight='bold')

# Row 1
ax1 = plt.subplot(3, 3, 1)
ax1.plot(t, speed_rpm, 'b-', linewidth=2)
ax1.set_ylabel('Speed (RPM)')
ax1.set_title('Rotor Speed')
ax1.axhline(y=wbasem*60/(2*np.pi), color='k', linestyle='--', alpha=0.3, label='Sync')
ax1.legend()
ax1.grid(True)

ax2 = plt.subplot(3, 3, 2)
ax2.plot(t, wm_pu, 'r-', linewidth=2)
ax2.set_ylabel('Speed (pu)')
ax2.set_title('Per Unit Speed')
ax2.axhline(y=1.0, color='k', linestyle='--', alpha=0.3)
ax2.grid(True)

ax3 = plt.subplot(3, 3, 3)
ax3.plot(t, delta_deg, 'g-', linewidth=2)
ax3.set_ylabel('Load Angle δ (deg)')
ax3.set_title('Load Angle')
ax3.grid(True)

# Row 2
ax4 = plt.subplot(3, 3, 4)
ax4.plot(t, iq, 'm-', linewidth=2, label='iq')
ax4.plot(t, id_val, 'c-', linewidth=2, label='id')
ax4.set_ylabel('Stator Currents (pu)')
ax4.set_title('dq Stator Currents')
ax4.legend()
ax4.grid(True)

ax5 = plt.subplot(3, 3, 5)
ax5.plot(t, Te, 'k-', linewidth=2)
ax5.set_ylabel('Torque (pu)')
ax5.set_title('Electromagnetic Torque')
ax5.axhline(y=-0.8, color='r', linestyle='--', alpha=0.3, label='Load')
ax5.legend()
ax5.grid(True)

ax6 = plt.subplot(3, 3, 6)
ax6.plot(t, Pe, 'orange', linewidth=2)
ax6.set_ylabel('Power (pu)')
ax6.set_title('Electrical Power')
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
ax8.plot(t, Psikq, 'm-', linewidth=2, label='ψkq')
ax8.plot(t, Psikd, 'c-', linewidth=2, label='ψkd')
ax8.set_ylabel('Damper Flux (pu)')
ax8.set_xlabel('Time (s)')
ax8.set_title('Damper Flux Linkages')
ax8.legend()
ax8.grid(True)

ax9 = plt.subplot(3, 3, 9)
ax9.plot(t, wr_slip, 'purple', linewidth=2)
ax9.set_ylabel('Slip (pu)')
ax9.set_xlabel('Time (s)')
ax9.set_title('Slip (wr-we)/we')
ax9.axhline(y=0, color='k', linestyle='--', alpha=0.3)
ax9.grid(True)

plt.tight_layout()
plt.savefig(str(Path(__file__).parent / 's4_results.png'), dpi=300, bbox_inches='tight')
print(f"Plot saved as s4_results.png")

# Print final values
print("\nFinal Values:")
print(f"  Speed: {speed_rpm[-1]:.1f} RPM ({wm_pu[-1]:.4f} pu)")
print(f"  Load Angle: {delta_deg[-1]:.2f} degrees")
print(f"  Slip: {wr_slip[-1]:.6f}")
print(f"  q-axis Current: {iq[-1]:.4f} pu")
print(f"  d-axis Current: {id_val[-1]:.4f} pu")
print(f"  Electromagnetic Torque: {Te[-1]:.4f} pu")
print(f"  Electrical Power: {Pe[-1]:.4f} pu")

plt.show()
