"""
Synchronous Machine Converter - Converts Simulink sync machine models to Python
Implements proper synchronous machine equations in dq0 reference frame:
- Stator voltage: vd = -rs*id - ωe*ψq + dψd/dt
                 vq = -rs*iq + ωe*ψd + dψq/dt
- Flux linkages: ψd, ψq, ψf, ψkd, ψkq (with field and damper windings)
- Mechanical: 2H*dωm/dt = Tm - Te - D*ωm
- Torque: Te = ψd*iq - ψq*id
"""

import numpy as np
from pathlib import Path
from mdl_parser import MDLParser

def convert_sync_machine_mdl(mdl_file: str, param_file: str, description: str) -> str:
    """
    Convert synchronous machine MDL file to Python simulation

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

    # Determine machine type
    is_pm = "PM" in description or "permanent magnet" in description.lower()
    is_2x3 = "2x3" in description

    # Generate Python code
    output_file = mdl_file.replace('.MDL', '_sim.py').replace('.mdl', '_sim.py')

    code = generate_sync_machine_code(
        model_name,
        solver_config,
        param_file,
        description,
        is_pm,
        is_2x3
    )

    with open(output_file, 'w') as f:
        f.write(code)

    return output_file

def generate_sync_machine_code(model_name, solver_config, param_file, description,
                                is_pm, is_2x3):
    """Generate complete Python simulation code for synchronous machine"""

    param_module = Path(param_file).stem
    t_stop = solver_config.get('StopTime', 'tstop')

    code = f'''"""
Synchronous Machine Simulation: {description}
Converted from Simulink model: {model_name}.mdl
Generated automatically by sync_machine_converter.py

Model: {description}
Reference Frame: Rotor dq0 (d-axis lags q-axis by 90°)
"""

import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt
import sys
from pathlib import Path

# Add C7 directory to path to import parameters
sys.path.insert(0, str(Path(__file__).parent))

# Import machine parameters and setup
from {param_module} import *

# Use parameters from m-file
# The parameter file should define:
# - Machine parameters: rs, xd, xq, xls, xmd, xmq, etc.
# - Derived parameters: xplf, xplkd, xplkq, rpf, rpkd, rpkq
# - Initial conditions: delto, Psiqo, Psido, Psifo, Psikqo, Psikdo
# - Operating point: Vqo, Vdo, Iqo, Ido, Efo, Tmech

# Simulation parameters
t_stop_val = {t_stop}
if isinstance(t_stop_val, str):
    t_stop_val = eval(t_stop_val) if t_stop_val in dir() else 5.0

rtol = {solver_config.get('RelTol', '5e-6')}
atol = {solver_config.get('AbsTol', '1e-6')}

'''

    if is_pm:
        # Permanent magnet synchronous motor
        code += '''
def sync_machine_equations(t, y):
    """
    Permanent Magnet Synchronous Motor Equations (dq0 frame)
    States: [id, iq, ωm, θe]

    Voltage equations:
    vd = rs*id + Ld*did/dt - ωe*Lq*iq
    vq = rs*iq + Lq*diq/dt + ωe*(Ld*id + λpm)

    Torque: Te = (3/2)*P/2*(λpm*iq + (Ld-Lq)*id*iq)
    Mechanical: J*dωm/dt = Te - TL - D*ωm
    """
    id, iq, wm, theta_e = y

    # Electrical angular velocity
    we = wm * (Poles / 2)

    # PM flux linkage (from parameters or rated conditions)
    lambda_pm = Efo / wb if 'Efo' in dir() else 1.0

    # Inductances
    Ld = xd / wb if 'xd' in dir() else 1.0
    Lq = xq / wb if 'xq' in dir() else 1.0

    # Applied voltages (from input functions or constants)
    # Vd, Vq should be defined based on control or grid connection
    if t < 0.2:
        vd = Vdo if 'Vdo' in dir() else 0
        vq = Vqo if 'Vqo' in dir() else 1.0
    else:
        vd = Vdo if 'Vdo' in dir() else 0
        vq = Vqo if 'Vqo' in dir() else 1.0

    # Current derivatives
    did_dt = (vd - rs * id + we * Lq * iq) / Ld
    diq_dt = (vq - rs * iq - we * (Ld * id + lambda_pm)) / Lq

    # Electromagnetic torque
    Te = (3/2) * (Poles/2) * (lambda_pm * iq + (Ld - Lq) * id * iq)

    # Mechanical load torque
    TL = Tmech if 'Tmech' in dir() else 0

    # Speed derivative
    dwm_dt = (Te - TL - Domega * wm) / (2 * H)

    # Angle derivative
    dtheta_dt = we

    return [did_dt, diq_dt, dwm_dt, dtheta_dt]

# Initial conditions for PM motor
id0 = Ido if 'Ido' in dir() else 0.0
iq0 = Iqo if 'Iqo' in dir() else 0.0
wm0 = 1.0  # Per unit speed
theta_e0 = delto if 'delto' in dir() else 0.0
y0 = [id0, iq0, wm0, theta_e0]

'''
    else:
        # Wound rotor synchronous generator with field and damper windings
        code += '''
def sync_machine_equations(t, y):
    """
    Synchronous Generator Equations in dq0 Reference Frame
    States: [δ, ψq, ψkq, ψd, ψf, ψkd, ωm]

    Where:
    - δ: rotor angle (electrical radians)
    - ψq, ψd: q-axis and d-axis stator flux linkages
    - ψkq, ψkd: q-axis and d-axis damper winding flux linkages
    - ψf: field winding flux linkage
    - ωm: rotor speed (per unit)

    The equations are:
    Stator voltage: vq = -rs*iq + wb*ψd + dψq/dt
                   vd = -rs*id - wb*ψq + dψd/dt
    Field voltage: vf = rpf*if + dψf/dt
    Damper voltages: 0 = rpkq*ikq + dψkq/dt
                     0 = rpkd*ikd + dψkd/dt
    Mechanical: 2H*dωm/dt = Tm - Te - D*ωm
    Rotor angle: dδ/dt = wb*(ωm - 1)
    """
    delta, Psiq, Psikq, Psid, Psif, Psikd, wm = y

    # Calculate currents from flux linkages using inductance matrix
    # Current-flux relationships:
    # iq = (Psiq - Psiaq) / xls, where Psiaq is air-gap flux
    # Similar for id, if, ikq, ikd

    # Air-gap flux linkages
    Psiaq = (Psiq/xls + Psikq/xplkq) / (1/xls + 1/xmq + 1/xplkq)
    Psiad = (Psid/xls + Psif/xplf + Psikd/xplkd) / (1/xls + 1/xmd + 1/xplf + 1/xplkd)

    # Or using the pre-calculated mutual inductances
    if 'xMQ' in dir():
        Psiaq = xMQ * (Psiq/xls + Psikq/xplkq)
    if 'xMD' in dir():
        Psiad = xMD * (Psid/xls + Psif/xplf + Psikd/xplkd)

    # Currents
    iq = (Psiq - Psiaq) / xls
    ikq = (Psikq - Psiaq) / xplkq
    id = (Psid - Psiad) / xls
    iif = (Psif - Psiad) / xplf
    ikd = (Psikd - Psiad) / xplkd

    # Terminal voltages from grid or inputs
    # These can be time-varying disturbances
    if 'Vm_time' in dir() and 'Vm_value' in dir():
        Vm_interp = np.interp(t, Vm_time, Vm_value)
    else:
        Vm_interp = Vm if 'Vm' in dir() else 1.0

    # Angle of bus voltage
    theta_e = thetaeo if 'thetaeo' in dir() else 0.0

    # dq voltages (rotating with rotor)
    vq = Vm_interp * np.cos(delta - theta_e)
    vd = -Vm_interp * np.sin(delta - theta_e)

    # Field voltage (excitation control)
    if 'Ex_time' in dir() and 'Ex_value' in dir():
        Ef_interp = np.interp(t, Ex_time, Ex_value)
    else:
        Ef_interp = Efo if 'Efo' in dir() else 1.0

    vf = Ef_interp

    # Mechanical torque
    if 'tmech_time' in dir() and 'tmech_value' in dir():
        Tm = np.interp(t, tmech_time, tmech_value)
    else:
        Tm = Tmech if 'Tmech' in dir() else 1.0

    # Electromagnetic torque
    Te = Psid * iq - Psiq * id

    # Derivatives
    dPsiq_dt = vq + rs * iq - wb * wm * Psid
    dPsid_dt = vd + rs * id + wb * wm * Psiq

    dPsif_dt = vf - rpf * iif
    dPsikd_dt = -rpkd * ikd
    dPsikq_dt = -rpkq * ikq

    dwm_dt = (Tm - Te - Domega * (wm - 1.0)) / (2 * H)

    ddelta_dt = wb * (wm - 1.0)

    return [ddelta_dt, dPsiq_dt, dPsikq_dt, dPsid_dt, dPsif_dt, dPsikd_dt, dwm_dt]

# Initial conditions from parameter file
# These should be calculated in the parameter file (e.g., m1.py)
delta0 = delto if 'delto' in dir() else 0.0
Psiq0 = Psiqo if 'Psiqo' in dir() else 0.0
Psikq0 = Psikqo if 'Psikqo' in dir() else 0.0
Psid0 = Psido if 'Psido' in dir() else 0.0
Psif0 = Psifo if 'Psifo' in dir() else 1.0
Psikd0 = Psikdo if 'Psikdo' in dir() else 0.0
wm0 = 1.0  # Synchronous speed in per unit

y0 = [delta0, Psiq0, Psikq0, Psid0, Psif0, Psikd0, wm0]

'''

    # Add solver code
    code += '''
# Event function to detect instability
def unstable_event(t, y):
    """Stop if angle difference becomes too large (loss of synchronism)"""
    delta = y[0]
    return np.abs(delta) - np.pi  # Stop if delta > 180 degrees

unstable_event.terminal = True
unstable_event.direction = 1

# Solve the differential equations
print(f"Simulating {description}...")
print(f"Time span: 0 to {t_stop_val} seconds")
print(f"Initial conditions: {y0}")

sol = solve_ivp(
    sync_machine_equations,
    [0, t_stop_val],
    y0,
    method='RK45',
    rtol=rtol,
    atol=atol,
    dense_output=True,
    max_step=5e-3,
    events=unstable_event
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

    if is_pm:
        code += '''
# Extract states
id = y[0, :]
iq = y[1, :]
wm = y[2, :]
theta_e = y[3, :]

# Calculate additional quantities
we = wm * (Poles / 2)
lambda_pm = Efo / wb if 'Efo' in dir() else 1.0
Ld = xd / wb if 'xd' in dir() else 1.0
Lq = xq / wb if 'xq' in dir() else 1.0

Te = (3/2) * (Poles/2) * (lambda_pm * iq + (Ld - Lq) * id * iq)
Pe = Te * wm

# Plotting
fig, axes = plt.subplots(2, 3, figsize=(15, 8))
fig.suptitle(f'{description} - Simulation Results', fontsize=14, fontweight='bold')

axes[0, 0].plot(t, id, 'b-', linewidth=2)
axes[0, 0].set_ylabel('d-axis Current (pu)')
axes[0, 0].set_title('d-axis Current')
axes[0, 0].grid(True)

axes[0, 1].plot(t, iq, 'r-', linewidth=2)
axes[0, 1].set_ylabel('q-axis Current (pu)')
axes[0, 1].set_title('q-axis Current')
axes[0, 1].grid(True)

axes[0, 2].plot(t, wm, 'g-', linewidth=2)
axes[0, 2].set_ylabel('Speed (pu)')
axes[0, 2].set_title('Rotor Speed')
axes[0, 2].axhline(y=1.0, color='k', linestyle='--', alpha=0.3)
axes[0, 2].grid(True)

axes[1, 0].plot(t, Te, 'k-', linewidth=2)
axes[1, 0].set_ylabel('Torque (pu)')
axes[1, 0].set_xlabel('Time (s)')
axes[1, 0].set_title('Electromagnetic Torque')
axes[1, 0].grid(True)

axes[1, 1].plot(t, Pe, 'm-', linewidth=2)
axes[1, 1].set_ylabel('Power (pu)')
axes[1, 1].set_xlabel('Time (s)')
axes[1, 1].set_title('Electrical Power')
axes[1, 1].grid(True)

axes[1, 2].plot(t, np.degrees(theta_e), 'c-', linewidth=2)
axes[1, 2].set_ylabel('Angle (degrees)')
axes[1, 2].set_xlabel('Time (s)')
axes[1, 2].set_title('Electrical Angle')
axes[1, 2].grid(True)

plt.tight_layout()
plt.savefig(f'{model_name}_results.png', dpi=300, bbox_inches='tight')
print(f"Plot saved as {model_name}_results.png")
plt.show()
'''
    else:
        code += '''
# Extract states
delta = y[0, :]
Psiq = y[1, :]
Psikq = y[2, :]
Psid = y[3, :]
Psif = y[4, :]
Psikd = y[5, :]
wm = y[6, :]

# Calculate currents and other quantities
Psiaq = np.zeros_like(delta)
Psiad = np.zeros_like(delta)
iq = np.zeros_like(delta)
id = np.zeros_like(delta)
iif = np.zeros_like(delta)
Te = np.zeros_like(delta)
Pe = np.zeros_like(delta)

for i in range(len(delta)):
    if 'xMQ' in dir():
        Psiaq[i] = xMQ * (Psiq[i]/xls + Psikq[i]/xplkq)
    else:
        Psiaq[i] = (Psiq[i]/xls + Psikq[i]/xplkq) / (1/xls + 1/xmq + 1/xplkq)

    if 'xMD' in dir():
        Psiad[i] = xMD * (Psid[i]/xls + Psif[i]/xplf + Psikd[i]/xplkd)
    else:
        Psiad[i] = (Psid[i]/xls + Psif[i]/xplf + Psikd[i]/xplkd) / (1/xls + 1/xmd + 1/xplf + 1/xplkd)

    iq[i] = (Psiq[i] - Psiaq[i]) / xls
    id[i] = (Psid[i] - Psiad[i]) / xls
    iif[i] = (Psif[i] - Psiad[i]) / xplf

    Te[i] = Psid[i] * iq[i] - Psiq[i] * id[i]
    Pe[i] = Te[i] * wm[i]

# Convert angles to degrees
delta_deg = np.degrees(delta)

# Plotting
fig, axes = plt.subplots(3, 3, figsize=(15, 10))
fig.suptitle(f'{description} - Simulation Results', fontsize=14, fontweight='bold')

axes[0, 0].plot(t, delta_deg, 'b-', linewidth=2)
axes[0, 0].set_ylabel('Rotor Angle δ (deg)')
axes[0, 0].set_title('Rotor Angle')
axes[0, 0].grid(True)

axes[0, 1].plot(t, wm, 'r-', linewidth=2)
axes[0, 1].set_ylabel('Speed ω (pu)')
axes[0, 1].set_title('Rotor Speed')
axes[0, 1].axhline(y=1.0, color='k', linestyle='--', alpha=0.3, label='Synchronous')
axes[0, 1].legend()
axes[0, 1].grid(True)

axes[0, 2].plot(t, iif, 'g-', linewidth=2)
axes[0, 2].set_ylabel('Field Current (pu)')
axes[0, 2].set_title('Field Current')
axes[0, 2].grid(True)

axes[1, 0].plot(t, iq, 'm-', linewidth=2, label='iq')
axes[1, 0].plot(t, id, 'c-', linewidth=2, label='id')
axes[1, 0].set_ylabel('Stator Currents (pu)')
axes[1, 0].set_title('Stator dq Currents')
axes[1, 0].legend()
axes[1, 0].grid(True)

axes[1, 1].plot(t, Te, 'k-', linewidth=2)
axes[1, 1].set_ylabel('Torque (pu)')
axes[1, 1].set_xlabel('Time (s)')
axes[1, 1].set_title('Electromagnetic Torque')
axes[1, 1].grid(True)

axes[1, 2].plot(t, Pe, 'orange', linewidth=2)
axes[1, 2].set_ylabel('Power (pu)')
axes[1, 2].set_xlabel('Time (s)')
axes[1, 2].set_title('Electrical Power')
axes[1, 2].grid(True)

axes[2, 0].plot(t, Psiq, 'b-', linewidth=2, label='ψq')
axes[2, 0].plot(t, Psid, 'r-', linewidth=2, label='ψd')
axes[2, 0].set_ylabel('Stator Flux (pu)')
axes[2, 0].set_xlabel('Time (s)')
axes[2, 0].set_title('Stator Flux Linkages')
axes[2, 0].legend()
axes[2, 0].grid(True)

axes[2, 1].plot(t, Psif, 'g-', linewidth=2)
axes[2, 1].set_ylabel('Field Flux (pu)')
axes[2, 1].set_xlabel('Time (s)')
axes[2, 1].set_title('Field Flux Linkage')
axes[2, 1].grid(True)

axes[2, 2].plot(t, Psikq, 'm-', linewidth=2, label='ψkq')
axes[2, 2].plot(t, Psikd, 'c-', linewidth=2, label='ψkd')
axes[2, 2].set_ylabel('Damper Flux (pu)')
axes[2, 2].set_xlabel('Time (s)')
axes[2, 2].set_title('Damper Flux Linkages')
axes[2, 2].legend()
axes[2, 2].grid(True)

plt.tight_layout()
plt.savefig(f'{model_name}_results.png', dpi=300, bbox_inches='tight')
print(f"Plot saved as {model_name}_results.png")
plt.show()

# Print final values
print("\\nFinal Values:")
print(f"Rotor Angle: {delta_deg[-1]:.2f} degrees")
print(f"Rotor Speed: {wm[-1]:.4f} pu")
print(f"Field Current: {iif[-1]:.4f} pu")
print(f"q-axis Current: {iq[-1]:.4f} pu")
print(f"d-axis Current: {id[-1]:.4f} pu")
print(f"Electromagnetic Torque: {Te[-1]:.4f} pu")
print(f"Electrical Power: {Pe[-1]:.4f} pu")
'''

    return code

if __name__ == "__main__":
    # Test conversion
    import sys
    if len(sys.argv) > 1:
        mdl_file = sys.argv[1]
        param_file = sys.argv[2] if len(sys.argv) > 2 else "m1.py"
        description = sys.argv[3] if len(sys.argv) > 3 else "Synchronous Machine"

        output = convert_sync_machine_mdl(mdl_file, param_file, description)
        print(f"Generated: {output}")
