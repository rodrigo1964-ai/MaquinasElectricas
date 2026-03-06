"""
C8/S2 - DC Motor Starting Simulation (Enhanced)
Implements DC separately-excited motor starting equations
Based on m2.py parameters and s2.mdl structure
"""

import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt
import sys
from pathlib import Path

# Add C8 directory to path
sys.path.insert(0, str(Path(__file__).parent))

# Import parameters from m2.py
Prated = 10 * 746  # 10 HP
Vrated = 220  # V
Iarated = Prated / Vrated
wmrated = 1490 * (2 * np.pi) / 60  # rad/s
Trated = Prated / wmrated
Ra = 0.3  # ohm
Laq = 0.012  # H
J = 2.5  # rotor inertia kg·m²
D = 0.0  # damping factor

# Back-EMF constant (from rated values)
# At rated: Vrated = Ea + Ra*Iarated
# Ea = Ka * wm, so Ka = (Vrated - Ra*Iarated) / wmrated
Ka = (Vrated - Ra * Iarated) / wmrated

print("="*70)
print("C8/S2 - DC MOTOR STARTING SIMULATION")
print("="*70)
print(f"Rated: {Prated/746:.0f} HP, {Vrated} V, {Iarated:.1f} A, {wmrated*60/(2*np.pi):.0f} RPM")
print(f"Parameters:")
print(f"  Ra = {Ra} Ω, Laq = {Laq} H")
print(f"  J = {J} kg·m², D = {D}")
print(f"  Ka (back-EMF constant) = {Ka:.4f} V·s/rad")
print(f"  Trated = {Trated:.2f} N·m")
print("="*70)


def dc_motor_starting_equations(t, y):
    """
    DC Motor Starting Equations
    States: [Ia, wm]

    Armature circuit: Laq * dIa/dt = Va - Ea - Ra*Ia
    Mechanical: J * dwm/dt = Te - Tload - D*wm

    Where:
    - Ea = Ka * wm (back-EMF proportional to speed)
    - Te = Ka * Ia (torque proportional to current)
    - Va = supply voltage (may include starting resistance)
    """
    Ia, wm = y

    # Back-EMF
    Ea = Ka * wm

    # Applied voltage
    # For direct-on-line starting, Va = Vrated throughout
    # For starting with external resistance, reduce Va initially
    # Option 1: Direct start
    Va = Vrated

    # Option 2: Starting with resistor (reduce inrush current)
    # Uncomment to use:
    # if t < 0.5:  # First 0.5s with starting resistor
    #     Rstart = 2.0  # Additional starting resistance
    #     Va_eff = Vrated * Ra / (Ra + Rstart)
    # else:
    #     Va_eff = Vrated
    # Va = Va_eff

    # Armature current derivative
    dIa_dt = (Va - Ea - Ra * Ia) / Laq

    # Developed torque
    Te = Ka * Ia

    # Mechanical load torque
    # Option 1: No load start
    Tload = 0

    # Option 2: Constant load
    # Tload = 0.5 * Trated

    # Option 3: Speed-dependent load (fan/pump)
    # Tload = 0.3 * Trated * (wm / wmrated)**2

    # Speed derivative
    dwm_dt = (Te - Tload - D * wm) / J

    return [dIa_dt, dwm_dt]


# Initial conditions (starting from rest)
Ia0 = 0.0  # No current initially
wm0 = 0.0  # Starting from standstill
y0 = [Ia0, wm0]

# Simulation parameters
t_stop = 0.5  # seconds (motor starting is typically quick)

print(f"Initial Conditions:")
print(f"  Armature Current: {Ia0} A")
print(f"  Speed: {wm0} RPM")
print(f"  Starting method: Direct-on-line")
print(f"\nSimulating motor starting...")
print("="*70)

# Solve
sol = solve_ivp(
    dc_motor_starting_equations,
    [0, t_stop],
    y0,
    method='RK45',
    rtol=1e-6,
    atol=1e-8,
    dense_output=True,
    max_step=1e-4
)

if sol.success:
    print(f"Simulation completed successfully! ({len(sol.t)} time steps)")
else:
    print(f"Warning: {sol.message}")

# Extract results
t = sol.t
Ia = sol.y[0, :]
wm = sol.y[1, :]

# Calculate additional quantities
Ea = Ka * wm
Te = Ka * Ia
wm_rpm = wm * 60 / (2*np.pi)
Pe = Ea * Ia  # Electrical power to mechanical
Pmech = Te * wm  # Mechanical power output
Ploss = Ra * Ia**2  # Copper losses

# Calculate energy
energy_input = np.trapz(Vrated * Ia, t)
energy_kinetic = 0.5 * J * wm[-1]**2

# Plotting
fig = plt.figure(figsize=(14, 10))
fig.suptitle('C8/S2 - DC Motor Starting Transient', fontsize=14, fontweight='bold')

# Row 1
ax1 = plt.subplot(3, 3, 1)
ax1.plot(t, Ia, 'r-', linewidth=2)
ax1.set_ylabel('Armature Current Ia (A)')
ax1.set_title('Armature Current')
ax1.axhline(y=Iarated, color='k', linestyle='--', alpha=0.3, label=f'Rated {Iarated:.1f}A')
ax1.axhline(y=max(Ia), color='r', linestyle=':', alpha=0.5, label=f'Peak {max(Ia):.1f}A')
ax1.legend()
ax1.grid(True)

ax2 = plt.subplot(3, 3, 2)
ax2.plot(t, wm_rpm, 'b-', linewidth=2)
ax2.set_ylabel('Speed (RPM)')
ax2.set_title('Rotor Speed')
ax2.axhline(y=wmrated*60/(2*np.pi), color='k', linestyle='--', alpha=0.3,
           label=f'Rated {wmrated*60/(2*np.pi):.0f} RPM')
ax2.legend()
ax2.grid(True)

ax3 = plt.subplot(3, 3, 3)
ax3.plot(t, Ea, 'g-', linewidth=2)
ax3.set_ylabel('Back-EMF Ea (V)')
ax3.set_title('Back-EMF')
ax3.axhline(y=Vrated, color='k', linestyle='--', alpha=0.3, label=f'{Vrated}V')
ax3.legend()
ax3.grid(True)

# Row 2
ax4 = plt.subplot(3, 3, 4)
ax4.plot(t, Te, 'k-', linewidth=2)
ax4.set_ylabel('Torque Te (N·m)')
ax4.set_title('Electromagnetic Torque')
ax4.axhline(y=Trated, color='r', linestyle='--', alpha=0.3, label=f'Rated {Trated:.1f} N·m')
ax4.axhline(y=max(Te), color='k', linestyle=':', alpha=0.5, label=f'Peak {max(Te):.1f} N·m')
ax4.legend()
ax4.grid(True)

ax5 = plt.subplot(3, 3, 5)
ax5.plot(t, Pe/1000, 'orange', linewidth=2, label='Electrical')
ax5.plot(t, Pmech/1000, 'purple', linewidth=2, label='Mechanical')
ax5.set_ylabel('Power (kW)')
ax5.set_title('Power Flow')
ax5.legend()
ax5.grid(True)

ax6 = plt.subplot(3, 3, 6)
ax6.plot(t, Ploss/1000, 'r-', linewidth=2)
ax6.set_ylabel('Copper Loss (kW)')
ax6.set_title('I²R Losses in Armature')
ax6.grid(True)

# Row 3 - Torque-speed and current-speed characteristics
ax7 = plt.subplot(3, 3, 7)
ax7.plot(wm_rpm, Te, 'k-', linewidth=2)
ax7.set_xlabel('Speed (RPM)')
ax7.set_ylabel('Torque (N·m)')
ax7.set_title('Torque vs Speed')
ax7.axhline(y=Trated, color='r', linestyle='--', alpha=0.3)
ax7.axvline(x=wmrated*60/(2*np.pi), color='b', linestyle='--', alpha=0.3)
ax7.grid(True)

ax8 = plt.subplot(3, 3, 8)
ax8.plot(wm_rpm, Ia, 'r-', linewidth=2)
ax8.set_xlabel('Speed (RPM)')
ax8.set_ylabel('Current (A)')
ax8.set_title('Current vs Speed')
ax8.axhline(y=Iarated, color='k', linestyle='--', alpha=0.3)
ax8.grid(True)

# Phase plane
ax9 = plt.subplot(3, 3, 9)
ax9.plot(Ia, wm_rpm, 'b-', linewidth=2)
ax9.plot(Ia[0], wm_rpm[0], 'go', markersize=10, label='Start')
ax9.plot(Ia[-1], wm_rpm[-1], 'ro', markersize=10, label='End')
ax9.set_xlabel('Armature Current (A)')
ax9.set_ylabel('Speed (RPM)')
ax9.set_title('Phase Plane Trajectory')
ax9.legend()
ax9.grid(True)

plt.tight_layout()
plt.savefig(str(Path(__file__).parent / 's2_results.png'), dpi=300, bbox_inches='tight')
print(f"Plot saved as s2_results.png")

# Calculate starting time (time to reach 95% of final speed)
wm_final = wm[-1]
idx_95 = np.where(wm >= 0.95 * wm_final)[0]
if len(idx_95) > 0:
    t_start = t[idx_95[0]]
else:
    t_start = t[-1]

# Print final values and statistics
print("\nStarting Statistics:")
print(f"  Peak Starting Current: {max(Ia):.2f} A ({max(Ia)/Iarated:.1f}× rated)")
print(f"  Peak Starting Torque: {max(Te):.2f} N·m ({max(Te)/Trated:.1f}× rated)")
print(f"  Starting Time (to 95%): {t_start:.3f} s")
print(f"\nFinal Values (at {t[-1]:.3f} s):")
print(f"  Armature Current: {Ia[-1]:.2f} A")
print(f"  Speed: {wm_rpm[-1]:.0f} RPM ({wm[-1]/wmrated*100:.1f}% of rated)")
print(f"  Back-EMF: {Ea[-1]:.2f} V")
print(f"  Torque: {Te[-1]:.2f} N·m")
print(f"  Mechanical Power: {Pmech[-1]/1000:.2f} kW ({Pmech[-1]/746:.2f} HP)")
print(f"\nEnergy:")
print(f"  Total Input Energy: {energy_input:.2f} J")
print(f"  Final Kinetic Energy: {energy_kinetic:.2f} J")
print(f"  Energy Efficiency: {energy_kinetic/energy_input*100:.1f}%")

plt.show()
