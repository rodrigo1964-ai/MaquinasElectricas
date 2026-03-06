"""
C8/S3A - DC Motor Braking Methods Simulation (Enhanced)
Implements plugging and dynamic braking equations
Based on m3a.py parameters and s3a.mdl structure
"""

import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt
import sys
from pathlib import Path

# Add C8 directory to path
sys.path.insert(0, str(Path(__file__).parent))

# Import parameters from m3a.py
Prated = 2 * 746  # 2 HP
Vrated = 125  # V
Iarated = 16  # A
wmrated = 1750 * (2 * np.pi) / 60  # rad/s
Trated = Prated / wmrated
Ra = 0.14  # ohm
Rf = 111  # ohm
Rrh = 25  # ext field rheostat resistance
Laq = 0.018  # H
Lf = 10  # H
Rload = 1e6
D = 0  # damping
J = 0.5  # rotor inertia kg·m²

# Back-EMF constant
Ka = (Vrated - Ra * Iarated) / wmrated

# Braking method parameters
# Plugging method
Rext_plugging = 6.054  # External resistance for plugging
Vbrake_plugging = -Vrated

# Dynamic braking method
Rext_dynamic = 2.929  # External resistance for dynamic braking
Vbrake_dynamic = 0

print("="*70)
print("C8/S3A - DC MOTOR BRAKING METHODS SIMULATION")
print("="*70)
print(f"Rated: {Prated/746:.0f} HP, {Vrated} V, {Iarated} A, {wmrated*60/(2*np.pi):.0f} RPM")
print(f"Parameters:")
print(f"  Ra = {Ra} Ω, Laq = {Laq} H, J = {J} kg·m²")
print(f"  Ka = {Ka:.4f} V·s/rad")
print("="*70)


def dc_motor_braking_equations(t, y, braking_method='plugging'):
    """
    DC Motor Braking Equations
    States: [Ia, wm]

    Braking methods:
    1. Plugging: Reverse supply voltage with added resistance
    2. Dynamic braking: Disconnect supply, connect braking resistor
    """
    Ia, wm = y

    # Back-EMF
    Ea = Ka * wm

    # Select braking method
    if braking_method == 'plugging':
        # Plugging: reverse voltage applied
        # Start in motoring mode, then reverse voltage
        if t < 0.5:  # Motoring
            Va = Vrated
            Rtotal = Ra
        else:  # Plugging (voltage reversed)
            Va = Vbrake_plugging  # Negative voltage
            Rtotal = Ra + Rext_plugging
    else:  # Dynamic braking
        # Start in motoring mode, then disconnect and short through resistor
        if t < 0.5:  # Motoring
            Va = Vrated
            Rtotal = Ra
        else:  # Dynamic braking
            Va = Vbrake_dynamic  # Zero applied voltage
            Rtotal = Ra + Rext_dynamic

    # Armature current derivative
    dIa_dt = (Va - Ea - Rtotal * Ia) / Laq

    # Developed torque
    Te = Ka * Ia

    # For plugging, when motor reverses, may want to stop at zero speed
    # Add event detection in simulation

    # Load torque (zero for free deceleration)
    Tload = 0

    # Speed derivative
    dwm_dt = (Te - Tload - D * wm) / J

    return [dIa_dt, dwm_dt]


def simulate_braking(braking_method, t_stop=2.0):
    """Simulate one braking method"""

    # Initial conditions (running at rated speed in motoring)
    # First, run up to steady state
    Ia_ss = Vrated / (Ra + Ka**2 / (Ra))  # Approximate
    Ia0 = Iarated
    wm0 = wmrated

    y0 = [Ia0, wm0]

    # Event to stop simulation at zero speed
    def zero_speed_event(t, y):
        return y[1]  # wm = 0

    zero_speed_event.terminal = True
    zero_speed_event.direction = -1  # Only trigger when decreasing

    print(f"\nSimulating {braking_method.upper()} method...")
    print(f"  Initial: Ia={Ia0:.2f}A, wm={wm0*60/(2*np.pi):.0f}RPM")

    # Solve
    sol = solve_ivp(
        lambda t, y: dc_motor_braking_equations(t, y, braking_method),
        [0, t_stop],
        y0,
        method='RK45',
        rtol=1e-6,
        atol=1e-8,
        dense_output=True,
        max_step=1e-4,
        events=zero_speed_event
    )

    if sol.status == 1:
        print(f"  Motor stopped at t={sol.t[-1]:.3f}s")
    elif sol.success:
        print(f"  Simulation completed: {len(sol.t)} time steps")

    return sol


# Simulate both methods
print("\n" + "="*70)
print("SIMULATING BRAKING METHODS")
print("="*70)

sol_plugging = simulate_braking('plugging', t_stop=0.5)
sol_dynamic = simulate_braking('dynamic', t_stop=2.0)

# Extract results - Plugging
t_plug = sol_plugging.t
Ia_plug = sol_plugging.y[0, :]
wm_plug = sol_plugging.y[1, :]
Ea_plug = Ka * wm_plug
Te_plug = Ka * Ia_plug
wm_rpm_plug = wm_plug * 60 / (2*np.pi)

# Extract results - Dynamic
t_dyn = sol_dynamic.t
Ia_dyn = sol_dynamic.y[0, :]
wm_dyn = sol_dynamic.y[1, :]
Ea_dyn = Ka * wm_dyn
Te_dyn = Ka * Ia_dyn
wm_rpm_dyn = wm_dyn * 60 / (2*np.pi)

# Calculate braking time
t_brake_plug = t_plug[-1]
t_brake_dyn = t_dyn[-1]

# Calculate energy dissipated
# For plugging
Rtotal_plug = Ra + Rext_plugging
energy_dissipated_plug = np.trapz(Rtotal_plug * Ia_plug**2, t_plug)

# For dynamic
Rtotal_dyn = Ra + Rext_dynamic
energy_dissipated_dyn = np.trapz(Rtotal_dyn * Ia_dyn**2, t_dyn)

# Initial kinetic energy
KE_initial = 0.5 * J * wmrated**2

# Plotting
fig = plt.figure(figsize=(16, 10))
fig.suptitle('C8/S3A - DC Motor Braking Methods Comparison', fontsize=14, fontweight='bold')

# Column 1: Plugging
ax1 = plt.subplot(3, 3, 1)
ax1.plot(t_plug, Ia_plug, 'r-', linewidth=2)
ax1.set_ylabel('Armature Current Ia (A)')
ax1.set_title('PLUGGING - Armature Current')
ax1.axhline(y=0, color='k', linestyle='-', linewidth=0.5)
ax1.axvline(x=0.5, color='g', linestyle='--', alpha=0.5, label='Brake Applied')
ax1.legend()
ax1.grid(True)

ax2 = plt.subplot(3, 3, 4)
ax2.plot(t_plug, wm_rpm_plug, 'b-', linewidth=2)
ax2.set_ylabel('Speed (RPM)')
ax2.set_title('PLUGGING - Rotor Speed')
ax2.axhline(y=0, color='k', linestyle='-', linewidth=0.5)
ax2.axvline(x=0.5, color='g', linestyle='--', alpha=0.5, label='Brake Applied')
ax2.legend()
ax2.grid(True)

ax3 = plt.subplot(3, 3, 7)
ax3.plot(t_plug, Te_plug, 'k-', linewidth=2)
ax3.set_ylabel('Torque Te (N·m)')
ax3.set_xlabel('Time (s)')
ax3.set_title('PLUGGING - Braking Torque')
ax3.axhline(y=0, color='k', linestyle='-', linewidth=0.5)
ax3.axvline(x=0.5, color='g', linestyle='--', alpha=0.5)
ax3.grid(True)

# Column 2: Dynamic Braking
ax4 = plt.subplot(3, 3, 2)
ax4.plot(t_dyn, Ia_dyn, 'r-', linewidth=2)
ax4.set_ylabel('Armature Current Ia (A)')
ax4.set_title('DYNAMIC BRAKING - Armature Current')
ax4.axhline(y=0, color='k', linestyle='-', linewidth=0.5)
ax4.axvline(x=0.5, color='g', linestyle='--', alpha=0.5, label='Brake Applied')
ax4.legend()
ax4.grid(True)

ax5 = plt.subplot(3, 3, 5)
ax5.plot(t_dyn, wm_rpm_dyn, 'b-', linewidth=2)
ax5.set_ylabel('Speed (RPM)')
ax5.set_title('DYNAMIC BRAKING - Rotor Speed')
ax5.axhline(y=0, color='k', linestyle='-', linewidth=0.5)
ax5.axvline(x=0.5, color='g', linestyle='--', alpha=0.5, label='Brake Applied')
ax5.legend()
ax5.grid(True)

ax6 = plt.subplot(3, 3, 8)
ax6.plot(t_dyn, Te_dyn, 'k-', linewidth=2)
ax6.set_ylabel('Torque Te (N·m)')
ax6.set_xlabel('Time (s)')
ax6.set_title('DYNAMIC BRAKING - Braking Torque')
ax6.axhline(y=0, color='k', linestyle='-', linewidth=0.5)
ax6.axvline(x=0.5, color='g', linestyle='--', alpha=0.5)
ax6.grid(True)

# Column 3: Comparisons
ax7 = plt.subplot(3, 3, 3)
ax7.plot(t_plug, wm_rpm_plug, 'b-', linewidth=2, label='Plugging')
ax7.plot(t_dyn, wm_rpm_dyn, 'r-', linewidth=2, label='Dynamic')
ax7.set_ylabel('Speed (RPM)')
ax7.set_title('Speed Comparison')
ax7.axhline(y=0, color='k', linestyle='-', linewidth=0.5)
ax7.legend()
ax7.grid(True)

ax8 = plt.subplot(3, 3, 6)
ax8.plot(t_plug, Ia_plug, 'b-', linewidth=2, label='Plugging')
ax8.plot(t_dyn, Ia_dyn, 'r-', linewidth=2, label='Dynamic')
ax8.set_ylabel('Current (A)')
ax8.set_title('Current Comparison')
ax8.axhline(y=0, color='k', linestyle='-', linewidth=0.5)
ax8.legend()
ax8.grid(True)

# Energy dissipation
ax9 = plt.subplot(3, 3, 9)
methods = ['Plugging', 'Dynamic']
energies = [energy_dissipated_plug, energy_dissipated_dyn]
times = [t_brake_plug - 0.5, t_brake_dyn - 0.5]  # Braking time only
colors = ['blue', 'red']
ax9.bar(methods, energies, color=colors, alpha=0.7)
ax9.set_ylabel('Energy Dissipated (J)')
ax9.set_title('Energy Comparison')
ax9.axhline(y=KE_initial, color='k', linestyle='--', label=f'Initial KE={KE_initial:.1f}J')
for i, (e, tim) in enumerate(zip(energies, times)):
    ax9.text(i, e + 20, f'{e:.1f}J\n{tim:.3f}s', ha='center')
ax9.legend()
ax9.grid(True, axis='y')

plt.tight_layout()
plt.savefig(str(Path(__file__).parent / 's3a_results.png'), dpi=300, bbox_inches='tight')
print(f"\nPlot saved as s3a_results.png")

# Print comparison
print("\n" + "="*70)
print("BRAKING METHODS COMPARISON")
print("="*70)
print(f"\nInitial Kinetic Energy: {KE_initial:.2f} J")
print(f"\nPLUGGING METHOD:")
print(f"  Braking Time: {t_brake_plug - 0.5:.3f} s")
print(f"  Peak Braking Current: {max(abs(Ia_plug)):.2f} A ({max(abs(Ia_plug))/Iarated:.1f}× rated)")
print(f"  Peak Braking Torque: {min(Te_plug):.2f} N·m")
print(f"  Energy Dissipated: {energy_dissipated_plug:.2f} J")
print(f"  External Resistance: {Rext_plugging} Ω")

print(f"\nDYNAMIC BRAKING METHOD:")
print(f"  Braking Time: {t_brake_dyn - 0.5:.3f} s")
print(f"  Peak Braking Current: {max(abs(Ia_dyn)):.2f} A ({max(abs(Ia_dyn))/Iarated:.1f}× rated)")
print(f"  Peak Braking Torque: {min(Te_dyn):.2f} N·m")
print(f"  Energy Dissipated: {energy_dissipated_dyn:.2f} J")
print(f"  External Resistance: {Rext_dynamic} Ω")

print(f"\nCOMPARISON:")
print(f"  Plugging is {(t_brake_dyn - 0.5)/(t_brake_plug - 0.5):.1f}× faster than dynamic braking")
print(f"  Plugging peak current is {max(abs(Ia_plug))/max(abs(Ia_dyn)):.1f}× higher")

plt.show()
