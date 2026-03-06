"""
DC Machine Converter - Converts Simulink DC machine models to Python
Implements proper DC machine equations:
- Armature circuit: Va = Ea + Ra*Ia + La*dIa/dt
- Field circuit: Vf = Rf*If + Lf*dIf/dt
- Back-EMF: Ea = Kf*If*wm (or from magnetization curve)
- Torque: Tem = Kf*If*Ia
- Mechanical: J*dwm/dt = Tem - Tload - D*wm
"""

import numpy as np
import re
from pathlib import Path
from mdl_parser import MDLParser

def convert_dc_machine_mdl(mdl_file: str, param_file: str, description: str) -> str:
    """
    Convert DC machine MDL file to Python simulation

    Args:
        mdl_file: Path to .MDL file
        param_file: Path to parameter file
        description: Description of the model

    Returns:
        Path to generated Python file
    """
    # Parse MDL file
    parser = MDLParser(mdl_file)
    model_info = parser.parse()

    model_name = model_info['model_name']
    solver_config = model_info['solver']

    # Determine machine type from description
    is_shunt = "shunt" in description.lower()
    is_series = "series" in description.lower()
    is_starting = "starting" in description.lower()
    is_braking = "braking" in description.lower()
    is_universal = "universal" in description.lower()
    is_generator = "generator" in description.lower()

    # Generate Python code
    output_file = mdl_file.replace('.MDL', '_sim.py').replace('.mdl', '_sim.py')

    code = generate_dc_machine_code(
        model_name,
        solver_config,
        param_file,
        description,
        is_shunt,
        is_series,
        is_starting,
        is_braking,
        is_universal,
        is_generator
    )

    with open(output_file, 'w') as f:
        f.write(code)

    return output_file

def generate_dc_machine_code(model_name, solver_config, param_file, description,
                             is_shunt, is_series, is_starting, is_braking,
                             is_universal, is_generator):
    """Generate complete Python simulation code for DC machine"""

    param_module = Path(param_file).stem
    t_stop = solver_config.get('StopTime', '2')

    code = f'''"""
DC Machine Simulation: {description}
Converted from Simulink model: {model_name}.mdl
Generated automatically by dc_machine_converter.py

Model: {description}
Type: {'Shunt' if is_shunt else 'Series' if is_series else 'Separately excited'} {'Generator' if is_generator else 'Motor'}
"""

import numpy as np
from scipy.integrate import solve_ivp
from scipy.interpolate import interp1d
import matplotlib.pyplot as plt
import sys
from pathlib import Path

# Add C8 directory to path to import parameters
sys.path.insert(0, str(Path(__file__).parent))

# Import machine parameters
from {param_module} import *

# Simulation parameters
t_stop = {t_stop}
rtol = {solver_config.get('RelTol', '1e-6')}
atol = {solver_config.get('AbsTol', '1e-6')}

'''

    # Add magnetization curve interpolation if it's a shunt generator
    if is_shunt and is_generator:
        code += '''
# Create magnetization curve interpolator
# Ea = f(If) at rated speed wmo
mag_curve = interp1d(SHIP1, SHVP1, kind='cubic', fill_value='extrapolate')

def get_Ea(If, wm):
    """Calculate back-EMF from magnetization curve scaled by speed"""
    Ea_at_wmo = mag_curve(If)
    Ea = Ea_at_wmo * (wm / wmo)
    return Ea

'''
    else:
        code += '''
# For motors without magnetization curve, use linear approximation
# or constant field excitation
def get_Ea(If_or_flux, wm):
    """Calculate back-EMF: Ea = Kf * flux * wm"""
    # For separately excited: flux proportional to If
    # For series: If = Ia
    return If_or_flux * wm

'''

    # Generate differential equations based on machine type
    if is_shunt and is_generator:
        code += '''
def dc_machine_equations(t, y):
    """
    DC Shunt Generator Equations
    States: [If, Ia]

    Field circuit: Lf * dIf/dt = Vf - Rf*If
    Armature circuit: Laq * dIa/dt = Ea - Ra*Ia - Va

    Where:
    - Ea from magnetization curve scaled by speed
    - Va = terminal voltage across load
    - Vf = Ea - (Rf + Rrh)*If (self-excited)
    """
    If, Ia = y

    # Assume constant speed for generator
    wm = wmrated

    # Get back-EMF from magnetization curve
    Ea = get_Ea(If, wm)

    # Terminal voltage (voltage across load)
    Va = Ea - Ra * Ia

    # Field voltage (self-excited: field connected across armature)
    Vf = Va

    # Field current derivative
    dIf_dt = (Vf - (Rf + Rrh) * If) / Lf

    # Armature current derivative
    # Load current: Il = Va / Rload
    dIa_dt = (Ea - Ra * Ia - Va) / Laq

    # Developed torque
    Tem = Ea * Ia / wm  # Power balance: Tem*wm = Ea*Ia

    return [dIf_dt, dIa_dt]

# Initial conditions
If0 = 0.001  # Small initial field current to start self-excitation
Ia0 = 0.0
y0 = [If0, Ia0]

'''
    elif is_starting:
        code += '''
def dc_machine_equations(t, y):
    """
    DC Motor Starting Equations
    States: [Ia, wm]

    Armature circuit: Laq * dIa/dt = Va - Ea - Ra*Ia
    Mechanical: J * dwm/dt = Tem - Tload - D*wm

    Where:
    - Ea = Ka * wm (back-EMF proportional to speed)
    - Tem = Ka * Ia (torque proportional to current)
    - Va = supply voltage (may include starting resistance)
    """
    Ia, wm = y

    # Back-EMF constant (approximate from rated values)
    Ka = Vrated / wmrated

    # Back-EMF
    Ea = Ka * wm

    # Applied voltage (can add starting resistance here)
    Va = Vrated

    # Armature current derivative
    dIa_dt = (Va - Ea - Ra * Ia) / Laq

    # Developed torque
    Tem = Ka * Ia

    # Mechanical load (can be speed-dependent)
    Tload = 0  # No load or constant load

    # Speed derivative
    dwm_dt = (Tem - Tload - D * wm) / J

    return [dIa_dt, dwm_dt]

# Initial conditions
Ia0 = 0.0
wm0 = 0.0  # Starting from rest
y0 = [Ia0, wm0]

'''
    elif is_braking:
        brake_type = "dynamic" if "dynamic" in description.lower() else "regenerative"
        code += f'''
def dc_machine_equations(t, y):
    """
    DC Motor {brake_type.capitalize()} Braking Equations
    States: [Ia, wm]

    During braking:
    - Dynamic: Armature disconnected from supply, connected to resistance
    - Regenerative: Armature remains connected, acts as generator
    """
    Ia, wm = y

    # Back-EMF constant
    Ka = Vrated / wmrated

    # Back-EMF
    Ea = Ka * wm

    # Applied voltage during braking
    if t < 0.5:  # Motor operation
        Va = Vrated
    else:  # Braking
        if "{brake_type}" == "dynamic":
            Va = 0  # Disconnected from supply
        else:  # regenerative
            Va = Vrated  # Still connected

    # Armature current derivative
    dIa_dt = (Va - Ea - Ra * Ia) / Laq

    # Developed torque (negative during braking)
    Tem = Ka * Ia

    # Mechanical load
    Tload = 0

    # Speed derivative
    dwm_dt = (Tem - Tload - D * wm) / J

    return [dIa_dt, dwm_dt]

# Initial conditions (start at rated speed)
Ia0 = Iarated
wm0 = wmrated
y0 = [Ia0, wm0]

'''
    elif is_series:
        code += '''
def dc_machine_equations(t, y):
    """
    DC Series Motor Equations
    States: [Ia, wm]

    In series motor: If = Ia (field in series with armature)

    Armature circuit: (Laq + Lf) * dIa/dt = Va - Ea - (Ra + Rf)*Ia
    Mechanical: J * dwm/dt = Tem - Tload - D*wm

    Where:
    - Ea = Ka * Ia * wm (flux proportional to Ia)
    - Tem = Ka * Ia^2 (torque proportional to Ia^2)
    """
    Ia, wm = y

    # For series motor, flux proportional to Ia
    # Torque constant approximation
    Ka = Vrated / (Iarated * wmrated)

    # Back-EMF (proportional to Ia*wm for series motor)
    Ea = Ka * Ia * wm

    # Applied voltage
    Va = Vrated

    # Total inductance (armature + field in series)
    Ltotal = Laq + Lf if 'Lf' in dir() else Laq

    # Total resistance
    Rtotal = Ra + Rf if 'Rf' in dir() else Ra

    # Armature/field current derivative
    dIa_dt = (Va - Ea - Rtotal * Ia) / Ltotal

    # Developed torque (proportional to Ia^2)
    Tem = Ka * Ia * Ia

    # Mechanical load
    Tload = 0  # No load or constant load

    # Speed derivative
    dwm_dt = (Tem - Tload - D * wm) / J

    return [dIa_dt, dwm_dt]

# Initial conditions
Ia0 = 0.0
wm0 = 0.01  # Small initial speed to avoid division issues
y0 = [Ia0, wm0]

'''
    else:
        # Generic separately excited motor
        code += '''
def dc_machine_equations(t, y):
    """
    DC Separately Excited Motor Equations
    States: [Ia, wm]

    Armature circuit: Laq * dIa/dt = Va - Ea - Ra*Ia
    Mechanical: J * dwm/dt = Tem - Tload - D*wm
    """
    Ia, wm = y

    # Constant field excitation
    Ka = Vrated / wmrated

    # Back-EMF
    Ea = Ka * wm

    # Applied voltage
    Va = Vrated

    # Armature current derivative
    dIa_dt = (Va - Ea - Ra * Ia) / Laq

    # Developed torque
    Tem = Ka * Ia

    # Mechanical load
    Tload = 0

    # Speed derivative
    dwm_dt = (Tem - Tload - D * wm) / J

    return [dIa_dt, dwm_dt]

# Initial conditions
Ia0 = 0.0
wm0 = 0.0
y0 = [Ia0, wm0]

'''

    # Add solver and plotting code
    code += '''
# Solve the differential equations
print(f"Simulating {description}...")
print(f"Time span: 0 to {t_stop} seconds")
print(f"Initial conditions: {y0}")

sol = solve_ivp(
    dc_machine_equations,
    [0, t_stop],
    y0,
    method='RK45',
    rtol=rtol,
    atol=atol,
    dense_output=True,
    max_step=1e-3
)

if not sol.success:
    print(f"Warning: Solver finished with status: {sol.message}")
else:
    print(f"Simulation completed successfully!")
    print(f"Number of time steps: {len(sol.t)}")

# Extract results
t = sol.t
y = sol.y

'''

    # Add appropriate plotting based on machine type
    if is_shunt and is_generator:
        code += '''
# Calculate additional variables for plotting
If = y[0, :]
Ia = y[1, :]
Ea = np.array([get_Ea(If[i], wmrated) for i in range(len(If))])
Va = Ea - Ra * Ia
Tem = Ea * Ia / wmrated

# Plotting
fig, axes = plt.subplots(3, 2, figsize=(12, 10))
fig.suptitle(f'{description} - Simulation Results', fontsize=14, fontweight='bold')

axes[0, 0].plot(t, If, 'b-', linewidth=2)
axes[0, 0].set_ylabel('Field Current If (A)')
axes[0, 0].set_title('Field Current')
axes[0, 0].grid(True)

axes[0, 1].plot(t, Ea, 'g-', linewidth=2)
axes[0, 1].set_ylabel('Back-EMF Ea (V)')
axes[0, 1].set_title('Internal Voltage')
axes[0, 1].grid(True)

axes[1, 0].plot(t, Ia, 'r-', linewidth=2)
axes[1, 0].set_ylabel('Armature Current Ia (A)')
axes[1, 0].set_title('Armature Current')
axes[1, 0].grid(True)

axes[1, 1].plot(t, Va, 'm-', linewidth=2)
axes[1, 1].set_ylabel('Terminal Voltage Va (V)')
axes[1, 1].set_title('Terminal Voltage')
axes[1, 1].grid(True)

axes[2, 0].plot(t, Tem, 'k-', linewidth=2)
axes[2, 0].set_ylabel('Torque Tem (Nm)')
axes[2, 0].set_xlabel('Time (s)')
axes[2, 0].set_title('Developed Torque')
axes[2, 0].grid(True)

axes[2, 1].plot(t, Ea * Ia, 'c-', linewidth=2)
axes[2, 1].set_ylabel('Power (W)')
axes[2, 1].set_xlabel('Time (s)')
axes[2, 1].set_title('Developed Power')
axes[2, 1].grid(True)

plt.tight_layout()
plt.savefig(f'{model_name}_results.png', dpi=300, bbox_inches='tight')
print(f"Plot saved as {model_name}_results.png")
plt.show()

# Print final values
print("\\nFinal Values:")
print(f"Field Current: {If[-1]:.4f} A")
print(f"Armature Current: {Ia[-1]:.4f} A")
print(f"Terminal Voltage: {Va[-1]:.4f} V")
print(f"Back-EMF: {Ea[-1]:.4f} V")
print(f"Developed Torque: {Tem[-1]:.4f} Nm")
print(f"Output Power: {(Va[-1] * Ia[-1]):.2f} W")
'''
    else:
        # Motor plots
        code += '''
# Calculate additional variables for plotting
Ia = y[0, :]
wm = y[1, :]
wm_rpm = wm * 60 / (2 * np.pi)

# Back-EMF and torque calculation
Ka = Vrated / wmrated
'''
        if is_series:
            code += '''
Ea = Ka * Ia * wm
Tem = Ka * Ia * Ia
'''
        else:
            code += '''
Ea = Ka * wm
Tem = Ka * Ia
'''

        code += '''
# Plotting
fig, axes = plt.subplots(2, 2, figsize=(12, 8))
fig.suptitle(f'{description} - Simulation Results', fontsize=14, fontweight='bold')

axes[0, 0].plot(t, Ia, 'r-', linewidth=2)
axes[0, 0].set_ylabel('Armature Current Ia (A)')
axes[0, 0].set_title('Armature Current')
axes[0, 0].grid(True)
axes[0, 0].axhline(y=Iarated, color='r', linestyle='--', label=f'Rated: {Iarated:.1f}A')
axes[0, 0].legend()

axes[0, 1].plot(t, wm_rpm, 'b-', linewidth=2)
axes[0, 1].set_ylabel('Speed (RPM)')
axes[0, 1].set_title('Rotor Speed')
axes[0, 1].grid(True)
if 'wmrated' in dir():
    axes[0, 1].axhline(y=wmrated*60/(2*np.pi), color='b', linestyle='--',
                       label=f'Rated: {wmrated*60/(2*np.pi):.0f} RPM')
    axes[0, 1].legend()

axes[1, 0].plot(t, Ea, 'g-', linewidth=2)
axes[1, 0].set_ylabel('Back-EMF Ea (V)')
axes[1, 0].set_xlabel('Time (s)')
axes[1, 0].set_title('Back-EMF')
axes[1, 0].grid(True)

axes[1, 1].plot(t, Tem, 'k-', linewidth=2)
axes[1, 1].set_ylabel('Torque Tem (Nm)')
axes[1, 1].set_xlabel('Time (s)')
axes[1, 1].set_title('Developed Torque')
axes[1, 1].grid(True)
if 'Trated' in dir():
    axes[1, 1].axhline(y=Trated, color='k', linestyle='--',
                       label=f'Rated: {Trated:.1f} Nm')
    axes[1, 1].legend()

plt.tight_layout()
plt.savefig(f'{model_name}_results.png', dpi=300, bbox_inches='tight')
print(f"Plot saved as {model_name}_results.png")
plt.show()

# Print final values
print("\\nFinal Values:")
print(f"Armature Current: {Ia[-1]:.4f} A")
print(f"Speed: {wm_rpm[-1]:.2f} RPM ({wm[-1]:.4f} rad/s)")
print(f"Back-EMF: {Ea[-1]:.4f} V")
print(f"Developed Torque: {Tem[-1]:.4f} Nm")
print(f"Mechanical Power: {(Tem[-1] * wm[-1]):.2f} W")
'''

    return code

if __name__ == "__main__":
    # Test conversion
    import sys
    if len(sys.argv) > 1:
        mdl_file = sys.argv[1]
        param_file = sys.argv[2] if len(sys.argv) > 2 else "m1.py"
        description = sys.argv[3] if len(sys.argv) > 3 else "DC Machine"

        output = convert_dc_machine_mdl(mdl_file, param_file, description)
        print(f"Generated: {output}")
