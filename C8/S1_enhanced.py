"""
C8/S1 - DC Shunt Generator Simulation (Enhanced)
Implements complete DC shunt generator equations with magnetization curve
Based on m1.py parameters and s1.mdl structure
"""

import numpy as np
from scipy.integrate import solve_ivp
from scipy.interpolate import interp1d
import matplotlib.pyplot as plt
import sys
from pathlib import Path

# Add C8 directory to path
sys.path.insert(0, str(Path(__file__).parent))

# Import parameters from m1.py
Prated = 2 * 746  # 2 HP
Vrated = 125  # V
Iarated = 16  # A
wmrated = 1750 * (2 * np.pi) / 60  # rad/s
Trated = Prated / wmrated
Ra = 0.24  # ohm
Rf = 111  # ohm
Rrh = 25  # ext field rheostat resistance
Laq = 0.018  # H
Lf = 10  # H
Rload = 1e6  # load resistance (open circuit initially)
J = 0.8  # rotor inertia kgm2
D = 0.0  # damping

# Magnetization curve data
wmo = 2000 * (2 * np.pi) / 60  # speed at which mag curve was taken

# Voltage values of mag. curve
SHVP1 = np.array([7.5, 12, 20, 24, 32, 40, 48, 59, 66, 74, 86, 97, 102.5,
                  107.5, 112, 117, 121, 125, 130, 135, 140, 143, 146, 152,
                  158, 164, 168, 172, 175])

# Main field current values of mag. curve
SHIP1 = np.array([0, 0.05, 0.1, 0.13, 0.18, 0.22, 0.26, 0.32, 0.36, 0.4,
                  0.47, 0.54, 0.575, 0.61, 0.64, 0.68, 0.71, 0.74, 0.78,
                  0.82, 0.86, 0.9, 0.93, 1.0, 1.1, 1.2, 1.3, 1.4, 1.5])

# Create magnetization curve interpolator
mag_curve = interp1d(SHIP1, SHVP1, kind='cubic', fill_value='extrapolate')

print("="*70)
print("C8/S1 - DC SHUNT GENERATOR SIMULATION")
print("="*70)
print(f"Rated: {Prated/746:.1f} HP, {Vrated} V, {Iarated} A, {wmrated*60/(2*np.pi):.0f} RPM")
print(f"Parameters:")
print(f"  Ra = {Ra} Ω, Rf = {Rf} Ω, Rrh = {Rrh} Ω")
print(f"  Laq = {Laq} H, Lf = {Lf} H")
print(f"  J = {J} kg·m²")
print(f"Magnetization curve: {len(SHIP1)} points")
print("="*70)


def get_Ea(If_val, wm):
    """Calculate back-EMF from magnetization curve scaled by speed"""
    if If_val < 0:
        If_val = 0  # no negative field current
    Ea_at_wmo = mag_curve(If_val)
    Ea = Ea_at_wmo * (wm / wmo)
    return Ea


# Armature reaction effect (simplified)
def armature_reaction(Ia):
    """Demagnetizing effect of armature current"""
    # Simple approximation: Iar = k1*atan(Ia) + k2*Ia^2
    Iar = 0.04 * np.abs(np.arctan(Ia)) + 0.0001 * Ia**2
    return Iar


def shunt_generator_equations(t, y):
    """
    DC Shunt Generator Equations
    States: [If, Ia, wm]

    Field circuit: Lf * dIf/dt = Vf - (Rf + Rrh)*If
    Armature circuit: Laq * dIa/dt = Ea - Ra*Ia - Va
    Mechanical: J * dwm/dt = Tmech - Te - D*wm

    Where:
    - Ea from magnetization curve scaled by speed
    - Va = terminal voltage across load
    - Vf = Va (self-excited, field across armature)
    - For self-excitation to build up, need small initial If
    """
    If_val, Ia, wm = y

    # Include armature reaction (demagnetizing effect)
    If_effective = If_val - armature_reaction(Ia)
    if If_effective < 0:
        If_effective = 0.001

    # Back-EMF from magnetization curve
    Ea = get_Ea(If_effective, wm)

    # Terminal voltage (voltage across load)
    Va = Ea - Ra * Ia

    # For self-excited shunt generator, field is across armature
    Vf = Va

    # Field current derivative
    dIf_dt = (Vf - (Rf + Rrh) * If_val) / Lf

    # Load current
    Il = Va / Rload if Rload > 0 else 0

    # Armature current is field current plus load current
    # Actually: Ia = If + Il for generator, but Ia flows out
    # For the circuit: Ea generates current Ia that splits into If and Il
    # Armature equation: Ea = Va + Ra*Ia
    # So: dIa/dt based on armature circuit

    # Armature current derivative
    dIa_dt = (Ea - Ra * Ia - Va) / Laq

    # Electromagnetic torque (from power balance)
    # Pe = Ea * Ia = Te * wm
    Te = Ea * Ia / wm if wm > 0.1 else 0

    # Mechanical torque (prime mover - assume constant speed drive)
    # For generator, typically driven at constant speed
    # We'll model as trying to maintain rated speed
    Tmech = Te + D * wm + J * 0  # Constant speed assumption

    # For more realistic model with speed variation:
    # Tmech = constant (prime mover torque)
    # dwm_dt = (Tmech - Te - D*wm) / J

    # Assuming constant speed operation for generator
    dwm_dt = 0

    return [dIf_dt, dIa_dt, dwm_dt]


# Initial conditions
# Small initial field current for self-excitation (residual magnetism)
If0 = 0.001  # Small residual field to start build-up
Ia0 = 0.0
wm0 = wmrated  # Start at rated speed

y0 = [If0, Ia0, wm0]

# Simulation parameters
t_stop = 3.0  # seconds

# Load resistance changes (can simulate loading)
# Start with high resistance (no load), then apply load
load_change_time = 1.5

print(f"Initial Conditions:")
print(f"  Field Current: {If0} A (residual)")
print(f"  Armature Current: {Ia0} A")
print(f"  Speed: {wm0*60/(2*np.pi):.0f} RPM")
print(f"  Load: {Rload:.0e} Ω (no load)")
print(f"\nSimulating self-excitation and voltage build-up...")
print("="*70)

# Solve
sol = solve_ivp(
    shunt_generator_equations,
    [0, t_stop],
    y0,
    method='RK45',
    rtol=1e-6,
    atol=1e-8,
    dense_output=True,
    max_step=1e-3
)

if sol.success:
    print(f"Simulation completed successfully! ({len(sol.t)} time steps)")
else:
    print(f"Warning: {sol.message}")

# Extract results
t = sol.t
If_result = sol.y[0, :]
Ia_result = sol.y[1, :]
wm_result = sol.y[2, :]

# Calculate additional quantities
n_points = len(t)
Ea_result = np.zeros(n_points)
Va_result = np.zeros(n_points)
Te_result = np.zeros(n_points)
Pout_result = np.zeros(n_points)
Il_result = np.zeros(n_points)

for i in range(n_points):
    If_eff = If_result[i] - armature_reaction(Ia_result[i])
    if If_eff < 0:
        If_eff = 0.001
    Ea_result[i] = get_Ea(If_eff, wm_result[i])
    Va_result[i] = Ea_result[i] - Ra * Ia_result[i]
    Te_result[i] = Ea_result[i] * Ia_result[i] / wm_result[i] if wm_result[i] > 0.1 else 0
    Il_result[i] = Va_result[i] / Rload if Rload > 0 else 0
    Pout_result[i] = Va_result[i] * Il_result[i]

speed_rpm = wm_result * 60 / (2*np.pi)

# Plotting
fig = plt.figure(figsize=(14, 10))
fig.suptitle('C8/S1 - DC Shunt Generator Self-Excitation', fontsize=14, fontweight='bold')

# Row 1
ax1 = plt.subplot(3, 3, 1)
ax1.plot(t, If_result, 'b-', linewidth=2)
ax1.set_ylabel('Field Current If (A)')
ax1.set_title('Field Current')
ax1.grid(True)

ax2 = plt.subplot(3, 3, 2)
ax2.plot(t, Ea_result, 'g-', linewidth=2)
ax2.set_ylabel('Back-EMF Ea (V)')
ax2.set_title('Internal Voltage (Back-EMF)')
ax2.axhline(y=Vrated, color='r', linestyle='--', alpha=0.3, label=f'Rated {Vrated}V')
ax2.legend()
ax2.grid(True)

ax3 = plt.subplot(3, 3, 3)
ax3.plot(t, Va_result, 'm-', linewidth=2)
ax3.set_ylabel('Terminal Voltage Va (V)')
ax3.set_title('Terminal Voltage')
ax3.axhline(y=Vrated, color='r', linestyle='--', alpha=0.3, label=f'Rated {Vrated}V')
ax3.legend()
ax3.grid(True)

# Row 2
ax4 = plt.subplot(3, 3, 4)
ax4.plot(t, Ia_result, 'r-', linewidth=2)
ax4.set_ylabel('Armature Current Ia (A)')
ax4.set_title('Armature Current')
ax4.axhline(y=Iarated, color='k', linestyle='--', alpha=0.3, label=f'Rated {Iarated}A')
ax4.legend()
ax4.grid(True)

ax5 = plt.subplot(3, 3, 5)
ax5.plot(t, Te_result, 'k-', linewidth=2)
ax5.set_ylabel('Torque Te (N·m)')
ax5.set_title('Electromagnetic Torque')
ax5.axhline(y=Trated, color='r', linestyle='--', alpha=0.3, label=f'Rated {Trated:.1f}N·m')
ax5.legend()
ax5.grid(True)

ax6 = plt.subplot(3, 3, 6)
ax6.plot(t, Pout_result, 'orange', linewidth=2)
ax6.set_ylabel('Output Power (W)')
ax6.set_title('Output Power')
ax6.axhline(y=Prated, color='r', linestyle='--', alpha=0.3, label=f'Rated {Prated:.0f}W')
ax6.legend()
ax6.grid(True)

# Row 3
ax7 = plt.subplot(3, 3, 7)
ax7.plot(t, speed_rpm, 'purple', linewidth=2)
ax7.set_ylabel('Speed (RPM)')
ax7.set_xlabel('Time (s)')
ax7.set_title('Rotor Speed')
ax7.axhline(y=wmrated*60/(2*np.pi), color='k', linestyle='--', alpha=0.3)
ax7.grid(True)

ax8 = plt.subplot(3, 3, 8)
ax8.plot(t, Ea_result * Ia_result, 'c-', linewidth=2, label='Generated')
ax8.plot(t, Va_result * Ia_result, 'orange', linewidth=2, label='Output')
ax8.set_ylabel('Power (W)')
ax8.set_xlabel('Time (s)')
ax8.set_title('Power Comparison')
ax8.legend()
ax8.grid(True)

# Magnetization curve with operating point
ax9 = plt.subplot(3, 3, 9)
ax9.plot(SHIP1, SHVP1, 'b-', linewidth=2, label='Mag Curve')
ax9.plot(If_result[-1], Ea_result[-1], 'ro', markersize=10, label='Operating Point')
ax9.set_ylabel('Ea (V)')
ax9.set_xlabel('If (A)')
ax9.set_title('Magnetization Curve')
ax9.legend()
ax9.grid(True)

plt.tight_layout()
plt.savefig(str(Path(__file__).parent / 's1_results.png'), dpi=300, bbox_inches='tight')
print(f"Plot saved as s1_results.png")

# Print final values
print("\nFinal Values:")
print(f"  Field Current: {If_result[-1]:.4f} A")
print(f"  Armature Current: {Ia_result[-1]:.4f} A")
print(f"  Terminal Voltage: {Va_result[-1]:.2f} V")
print(f"  Back-EMF: {Ea_result[-1]:.2f} V")
print(f"  Speed: {speed_rpm[-1]:.0f} RPM")
print(f"  Developed Torque: {Te_result[-1]:.4f} N·m")
print(f"  Output Power: {Pout_result[-1]:.2f} W ({Pout_result[-1]/746:.3f} HP)")
print(f"  Efficiency: {100*Pout_result[-1]/(Ea_result[-1]*Ia_result[-1]):.1f}%")

plt.show()
