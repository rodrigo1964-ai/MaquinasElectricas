"""
C8/S5 - DC Series Motor Hoist Simulation (Enhanced)
Implements DC series motor equations with magnetization curve
Based on m5.py parameters and s5.mdl structure
Application: Elevator/hoist with regenerative braking
"""

import numpy as np
from scipy.integrate import solve_ivp
from scipy.interpolate import interp1d
import matplotlib.pyplot as plt
import sys
from pathlib import Path

# Add C8 directory to path
sys.path.insert(0, str(Path(__file__).parent))

# Import parameters from m5.py
Prated = 1500  # W
Vrated = 125  # V
Iarated = 13.2  # A
wmrated = 1425 * (2 * np.pi) / 60  # rad/s
Trated = Prated / wmrated
Ra = 0.24  # ohm
Rse = 0.2  # series field resistance
Laq = 0.018  # H
Lse = 0.044  # H series field inductance
J = 0.5  # rotor inertia kg·m²

# Magnetization curve data
wmo = 1200 * (2 * np.pi) / 60  # speed at which mag curve was taken

# Voltage values of mag. curve
SEVP5 = np.array([-160, -155, -150, -145, -140, -135, -130, -125, -120,
                  -115, -110, -105, -100, -90, -80, -70, -60, -50, -40,
                  -30, -20, -10, 0, 10, 20, 30, 40, 50, 60, 70, 80, 90,
                  100, 105, 110, 115, 120, 125, 130, 135, 140, 145, 150,
                  155, 160])

# Main field current values of mag. curve
SEIP5 = np.array([-27.224, -23.547, -20.624, -18.739, -17.560, -16.617,
                  -15.627, -14.826, -13.977, -13.317, -12.643, -11.969,
                  -11.290, -10.041, -8.886, -7.613, -6.576, -5.647, -4.643,
                  -3.582, -2.521, -1.423, -0.400, 0.623, 1.721, 2.782,
                  3.843, 4.847, 5.776, 6.813, 8.086, 9.241, 10.490, 11.169,
                  11.843, 12.517, 13.177, 14.026, 14.827, 15.817, 16.760,
                  17.939, 19.824, 22.747, 26.424])

# Create interpolator for positive half (motoring)
hseriesV = SEVP5[23:]  # positive half
hseriesI = SEIP5[23:]

# k*phi = Ea/wm as function of Ia
kaphi_interp = interp1d(hseriesI, hseriesV/wmo, kind='cubic', fill_value='extrapolate')

# Also create full curve interpolator for both directions
Ea_from_Ia = interp1d(SEIP5, SEVP5, kind='cubic', fill_value='extrapolate')

print("="*70)
print("C8/S5 - DC SERIES MOTOR HOIST SIMULATION")
print("="*70)
print(f"Rated: {Prated} W, {Vrated} V, {Iarated} A, {wmrated*60/(2*np.pi):.0f} RPM")
print(f"Parameters:")
print(f"  Ra = {Ra} Ω, Rse = {Rse} Ω")
print(f"  Laq = {Laq} H, Lse = {Lse} H")
print(f"  J = {J} kg·m²")
print(f"  Trated = {Trated:.2f} N·m")
print("="*70)

# Calculate braking resistor for controlled descent
wbrake = -400 * 2 * np.pi / 60  # braking speed (lowering)
Vbrake_case1 = Vrated - 2  # case 1: with applied voltage
Vbrake_case2 = 0  # case 2: zero applied voltage

# Find required current for rated torque
# From mag curve, find Ia that gives Trated
tem_curve = np.array([kaphi_interp(Ia) * Ia for Ia in hseriesI if Ia > 0.5])
ia_for_tem = hseriesI[hseriesI > 0.5]
Iabrake = np.interp(Trated, tem_curve, ia_for_tem)
kaphibrake = kaphi_interp(Iabrake)

# Calculate braking resistors
Rbrake_case1 = (Vbrake_case1 - kaphibrake * wbrake) / Iabrake - Ra - Rse
Rbrake_case2 = (Vbrake_case2 - kaphibrake * wbrake) / Iabrake - Ra - Rse

print(f"\nBraking Resistor Calculations (for {wbrake*60/(2*np.pi):.0f} RPM descent):")
print(f"  Required Ia for Trated: {Iabrake:.2f} A")
print(f"  Case 1 (Va={Vbrake_case1:.0f}V): Rbrake = {Rbrake_case1:.3f} Ω")
print(f"  Case 2 (Va=0V): Rbrake = {Rbrake_case2:.3f} Ω")
print("="*70)


def series_motor_equations(t, y, Va, Rext, Tload):
    """
    DC Series Motor Equations
    States: [Ia, wm]

    In series motor: If = Ia (field in series with armature)

    Circuit: (Laq + Lse) * dIa/dt = Va - Ea - (Ra + Rse + Rext)*Ia
    Mechanical: J * dwm/dt = Te - Tload

    Where:
    - Ea = k(Ia) * wm (from magnetization curve)
    - Te = k(Ia) * Ia
    """
    Ia, wm = y

    # Get k*phi from magnetization curve
    # Handle both positive and negative currents
    if abs(Ia) < 0.1:
        Ia_safe = 0.1 * np.sign(Ia) if Ia != 0 else 0.1
    else:
        Ia_safe = Ia

    # Interpolate from full curve
    Ea_at_wmo = Ea_from_Ia(Ia_safe)
    kaphi = Ea_at_wmo / wmo

    # Back-EMF
    Ea = kaphi * wm

    # Total inductance and resistance
    Ltotal = Laq + Lse
    Rtotal = Ra + Rse + Rext

    # Armature/field current derivative
    dIa_dt = (Va - Ea - Rtotal * Ia) / Ltotal

    # Developed torque
    Te = kaphi * Ia

    # Speed derivative
    dwm_dt = (Te - Tload) / J

    return [dIa_dt, dwm_dt]


def simulate_series_motor(scenario='motoring'):
    """Simulate different operating scenarios"""

    if scenario == 'motoring':
        # Motoring: lifting load
        Va = Vrated - 2  # account for brush drop
        Rext = 0
        Tload = 0.8 * Trated  # Load torque
        Ia0 = 0.1
        wm0 = 0.01
        t_stop = 1.0
        title = "Motoring (Lifting)"

    elif scenario == 'braking_va_rated':
        # Braking with applied voltage (regenerative)
        Va = Vrated - 2
        Rext = Rbrake_case1
        Tload = -Trated  # Negative for lowering (load assists motion)
        # Start from rated motoring condition
        Ia0 = Iarated
        wm0 = wmrated
        t_stop = 2.0
        title = "Braking Va=Vrated (Controlled Lowering)"

    elif scenario == 'braking_va_zero':
        # Braking with zero voltage (dynamic braking)
        Va = 0
        Rext = Rbrake_case2
        Tload = -Trated
        Ia0 = Iarated
        wm0 = wmrated
        t_stop = 2.0
        title = "Braking Va=0 (Dynamic)"

    print(f"\nSimulating: {title}")
    print(f"  Va={Va:.1f}V, Rext={Rext:.3f}Ω, Tload={Tload:.1f}N·m")

    y0 = [Ia0, wm0]

    # Event to stop at zero speed for braking
    def zero_speed(t, y):
        return y[1]
    zero_speed.terminal = True
    zero_speed.direction = -1

    sol = solve_ivp(
        lambda t, y: series_motor_equations(t, y, Va, Rext, Tload),
        [0, t_stop],
        y0,
        method='RK45',
        rtol=1e-6,
        atol=1e-8,
        dense_output=True,
        max_step=1e-3,
        events=zero_speed if 'braking' in scenario else None
    )

    if sol.success:
        print(f"  Completed: {len(sol.t)} steps, t_final={sol.t[-1]:.3f}s")

    return sol, title


# Run all scenarios
scenarios = ['motoring', 'braking_va_rated', 'braking_va_zero']
solutions = []

print("\n" + "="*70)
print("RUNNING SIMULATIONS")
print("="*70)

for scenario in scenarios:
    sol, title = simulate_series_motor(scenario)
    solutions.append((sol, title, scenario))

# Plotting
fig = plt.figure(figsize=(16, 10))
fig.suptitle('C8/S5 - DC Series Motor Hoist Operation', fontsize=14, fontweight='bold')

colors = ['blue', 'red', 'green']

# Speed vs time
ax1 = plt.subplot(2, 3, 1)
for (sol, title, _), color in zip(solutions, colors):
    t = sol.t
    wm = sol.y[1, :]
    wm_rpm = wm * 60 / (2*np.pi)
    ax1.plot(t, wm_rpm, color=color, linewidth=2, label=title)
ax1.set_ylabel('Speed (RPM)')
ax1.set_xlabel('Time (s)')
ax1.set_title('Rotor Speed')
ax1.axhline(y=0, color='k', linestyle='-', linewidth=0.5)
ax1.legend()
ax1.grid(True)

# Current vs time
ax2 = plt.subplot(2, 3, 2)
for (sol, title, _), color in zip(solutions, colors):
    t = sol.t
    Ia = sol.y[0, :]
    ax2.plot(t, Ia, color=color, linewidth=2, label=title)
ax2.set_ylabel('Armature Current Ia (A)')
ax2.set_xlabel('Time (s)')
ax2.set_title('Armature Current')
ax2.axhline(y=0, color='k', linestyle='-', linewidth=0.5)
ax2.axhline(y=Iarated, color='k', linestyle='--', alpha=0.3)
ax2.legend()
ax2.grid(True)

# Torque vs time
ax3 = plt.subplot(2, 3, 3)
for (sol, title, _), color in zip(solutions, colors):
    t = sol.t
    Ia = sol.y[0, :]
    wm = sol.y[1, :]
    Te = np.array([kaphi_interp(abs(ia))*ia if abs(ia) > 0.1 else 0 for ia in Ia])
    ax3.plot(t, Te, color=color, linewidth=2, label=title)
ax3.set_ylabel('Torque Te (N·m)')
ax3.set_xlabel('Time (s)')
ax3.set_title('Electromagnetic Torque')
ax3.axhline(y=0, color='k', linestyle='-', linewidth=0.5)
ax3.axhline(y=Trated, color='k', linestyle='--', alpha=0.3, label='Rated')
ax3.legend()
ax3.grid(True)

# Back-EMF vs time
ax4 = plt.subplot(2, 3, 4)
for (sol, title, _), color in zip(solutions, colors):
    t = sol.t
    Ia = sol.y[0, :]
    wm = sol.y[1, :]
    Ea = np.array([Ea_from_Ia(ia) * wm[i] / wmo if abs(ia) > 0.1
                   else 0 for i, ia in enumerate(Ia)])
    ax4.plot(t, Ea, color=color, linewidth=2, label=title)
ax4.set_ylabel('Back-EMF Ea (V)')
ax4.set_xlabel('Time (s)')
ax4.set_title('Internal Voltage')
ax4.axhline(y=0, color='k', linestyle='-', linewidth=0.5)
ax4.legend()
ax4.grid(True)

# Torque-speed characteristics
ax5 = plt.subplot(2, 3, 5)
for (sol, title, scenario), color in zip(solutions, colors):
    Ia = sol.y[0, :]
    wm = sol.y[1, :]
    Te = np.array([kaphi_interp(abs(ia))*ia if abs(ia) > 0.1 else 0 for ia in Ia])
    wm_rpm = wm * 60 / (2*np.pi)
    ax5.plot(Te, wm_rpm, color=color, linewidth=2, label=title, marker='o',
             markevery=max(1, len(Te)//10))
ax5.set_xlabel('Torque (N·m)')
ax5.set_ylabel('Speed (RPM)')
ax5.set_title('Torque-Speed Characteristic')
ax5.axhline(y=0, color='k', linestyle='-', linewidth=0.5)
ax5.axvline(x=0, color='k', linestyle='-', linewidth=0.5)
ax5.legend()
ax5.grid(True)

# Magnetization curve with operating points
ax6 = plt.subplot(2, 3, 6)
ax6.plot(SEIP5, SEVP5, 'k-', linewidth=2, label='Mag Curve')
for (sol, title, _), color in zip(solutions, colors):
    Ia_final = sol.y[0, -1]
    Ea_final = Ea_from_Ia(Ia_final)
    ax6.plot(Ia_final, Ea_final, 'o', color=color, markersize=10, label=f'{title} (final)')
ax6.set_xlabel('Armature Current Ia (A)')
ax6.set_ylabel('Ea at wmo (V)')
ax6.set_title('Magnetization Curve')
ax6.axhline(y=0, color='k', linestyle='-', linewidth=0.5)
ax6.axvline(x=0, color='k', linestyle='-', linewidth=0.5)
ax6.legend(fontsize=8)
ax6.grid(True)

plt.tight_layout()
plt.savefig(str(Path(__file__).parent / 's5_results.png'), dpi=300, bbox_inches='tight')
print(f"\nPlot saved as s5_results.png")

# Print final values
print("\n" + "="*70)
print("FINAL VALUES")
print("="*70)
for (sol, title, scenario), color in zip(solutions, colors):
    t_final = sol.t[-1]
    Ia_final = sol.y[0, -1]
    wm_final = sol.y[1, -1]
    wm_rpm_final = wm_final * 60 / (2*np.pi)
    Ea_final = Ea_from_Ia(Ia_final) * wm_final / wmo if abs(Ia_final) > 0.1 else 0
    Te_final = kaphi_interp(abs(Ia_final)) * Ia_final if abs(Ia_final) > 0.1 else 0

    print(f"\n{title}:")
    print(f"  Time: {t_final:.3f} s")
    print(f"  Current: {Ia_final:.2f} A")
    print(f"  Speed: {wm_rpm_final:.0f} RPM")
    print(f"  Back-EMF: {Ea_final:.2f} V")
    print(f"  Torque: {Te_final:.2f} N·m")

plt.show()
