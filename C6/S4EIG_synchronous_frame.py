"""
Induction Machine Simulation in Synchronous Reference Frame (dq at we)
Converted from S4EIG.MDL - For Eigenvalue Analysis
"""
import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt
import sys
sys.path.append('/home/rodo/Maquinas/C6')
from p20hp import *

# Simulation parameters
tstop = 10.0  # Long simulation for eigenvalue visualization

# Synchronous frame frequency (we = wb for this case)
# we = wb already defined in p20hp.py

# Initial conditions - perturbed slightly from steady state for eigenvalue observation
# Assuming steady state at rated conditions
wrbywbo = srated  # Initial slip = rated slip

# Steady-state flux linkages computation
# In synchronous frame, steady state values are DC
theta_e = 0  # Initial electrical angle

# Approximate steady-state values
slip_ss = srated
Rr_eff = rpr / slip_ss
Z_eq = complex(rs, xls) + (complex(0, xm) * complex(Rr_eff, xplr)) / (complex(Rr_eff, xplr) + complex(0, xm))

# Current magnitude
I_mag = Vm / np.abs(Z_eq)

# In synchronous frame, align d-axis with voltage for simplicity
# This puts voltage on d-axis: vds = Vm, vqs = 0
Psidso = Vm / wb * 0.95  # Approximate
Psiqso = 0.1  # Small perturbation
Psipdro = Psidso * 0.9  # Approximate rotor flux
Psipqro = Psiqso * 0.9

# States: [psi_qs^e, psi_ds^e, psi_qr'^e, psi_dr'^e, wr/wb]
y0 = np.array([Psiqso, Psidso, Psipqro, Psipdro, wrbywbo])


def induction_machine_synchronous(t, y):
    """
    Induction machine model in synchronous reference frame (rotating at we)

    States:
        y[0] = psi_qs^e  : q-axis stator flux linkage (synchronous frame)
        y[1] = psi_ds^e  : d-axis stator flux linkage (synchronous frame)
        y[2] = psi_qr'^e : q-axis rotor flux linkage (synchronous frame, referred)
        y[3] = psi_dr'^e : d-axis rotor flux linkage (synchronous frame, referred)
        y[4] = wr/wb     : normalized rotor speed
    """
    psi_qse, psi_dse, psi_qre, psi_dre, wr_wb = y

    # Applied voltages in synchronous frame
    # For eigenvalue analysis: constant voltages (DC in synchronous frame)
    vqse = 0.0  # q-axis voltage
    vdse = Vm   # d-axis voltage (align with d-axis)

    # Magnetizing flux linkages
    psi_mqe = xM * (psi_qse / xls + psi_qre / xplr)
    psi_mde = xM * (psi_dse / xls + psi_dre / xplr)

    # Stator currents
    iqse = (psi_qse - psi_mqe) / xls
    idse = (psi_dse - psi_mde) / xls

    # Rotor currents (referred to stator)
    iqre = (psi_qre - psi_mqe) / xplr
    idre = (psi_dre - psi_mde) / xplr

    # Slip frequency (wr relative to synchronous speed)
    wr_slip = we / wb - wr_wb * wbm / wb  # Slip in electrical rad/s normalized

    # Flux linkage derivatives - Q-axis stator
    # From S4EIG.MDL: wb*(u[2]+(we/wb)*u[4]+(rs/xls)*(u[1]-u[3]))
    # u[1]=vqse, u[2]=psi_mqe, u[3]=psi_qse, u[4]=psi_dse
    dpsi_qse_dt = wb * (psi_mqe + (we / wb) * psi_dse + (rs / xls) * (vqse - psi_qse))

    # Flux linkage derivatives - D-axis stator
    # From S4EIG.MDL: wb*(u[2]-(we/wb)*u[4]+(rs/xls)*(u[1]-u[3]))
    # u[1]=vdse, u[2]=psi_mde, u[3]=psi_dse, u[4]=psi_qse
    dpsi_dse_dt = wb * (psi_mde - (we / wb) * psi_qse + (rs / xls) * (vdse - psi_dse))

    # Flux linkage derivatives - Q-axis rotor
    # From S4EIG.MDL: wb*(u[2] +(rpr/xplr)*(u[3]-u[1]))
    # Note: u[2] is the speed coupling term = (wr/wb - we/wb) * psi_dr'
    speed_coupling_q = (wr_wb * wbm / wb - we / wb) * psi_dre
    dpsi_qre_dt = wb * (speed_coupling_q + (rpr / xplr) * (psi_mqe - psi_qre))

    # Flux linkage derivatives - D-axis rotor
    # Similar structure with negative speed coupling
    speed_coupling_d = -(wr_wb * wbm / wb - we / wb) * psi_qre
    dpsi_dre_dt = wb * (speed_coupling_d + (rpr / xplr) * (psi_mde - psi_dre))

    # Electromagnetic torque
    # From S4EIG.MDL: Tfactor*(u[1]*u[2] - u[3]*u[4])
    # u[1]=psi_qse, u[2]=idse, u[3]=psi_dse, u[4]=iqse
    Te = Tfactor * (psi_qse * idse - psi_dse * iqse)

    # Mechanical load torque
    if t < 2.0:
        Tmech = 0.0  # No load
    else:
        Tmech = -Trated * 0.5  # 50% load at t=2s

    # Rotor speed derivative
    dwr_wb_dt = (Te - Tmech) / (2 * H * wb)

    return [dpsi_qse_dt, dpsi_dse_dt, dpsi_qre_dt, dpsi_dre_dt, dwr_wb_dt]


# Solve the differential equations
print("Starting simulation - Synchronous Reference Frame (S4EIG)...")
print(f"Initial conditions: psi_qse={y0[0]:.4f}, psi_dse={y0[1]:.4f}, wr/wb={y0[4]:.4f}")
print(f"Synchronous frequency we = {we:.2f} rad/s")

sol = solve_ivp(
    induction_machine_synchronous,
    [0, tstop],
    y0,
    method='RK45',
    rtol=1e-3,
    atol=1e-6,
    max_step=10,
    dense_output=True
)

print(f"Simulation completed. Time points: {len(sol.t)}")

# Extract results
t = sol.t
psi_qse = sol.y[0, :]
psi_dse = sol.y[1, :]
psi_qre = sol.y[2, :]
psi_dre = sol.y[3, :]
wr_wb = sol.y[4, :]

# Calculate currents and other quantities
iqse = np.zeros_like(t)
idse = np.zeros_like(t)
iqre = np.zeros_like(t)
idre = np.zeros_like(t)
Te = np.zeros_like(t)
wr_rpm = np.zeros_like(t)
slip = np.zeros_like(t)

for i in range(len(t)):
    psi_mqe = xM * (psi_qse[i] / xls + psi_qre[i] / xplr)
    psi_mde = xM * (psi_dse[i] / xls + psi_dre[i] / xplr)

    iqse[i] = (psi_qse[i] - psi_mqe) / xls
    idse[i] = (psi_dse[i] - psi_mde) / xls
    iqre[i] = (psi_qre[i] - psi_mqe) / xplr
    idre[i] = (psi_dre[i] - psi_mde) / xplr

    Te[i] = Tfactor * (psi_qse[i] * idse[i] - psi_dse[i] * iqse[i])

    # Speed in RPM (mechanical)
    wr_mech = wr_wb[i] * wbm
    wr_rpm[i] = wr_mech * 60 / (2 * np.pi)

    # Slip calculation
    ws = we * 2 / P  # Synchronous mechanical speed
    slip[i] = (ws - wr_mech) / ws

# Plotting
fig, axes = plt.subplots(3, 2, figsize=(12, 10))
fig.suptitle('Induction Machine - Synchronous Reference Frame (S4EIG)', fontsize=14)

# Flux linkages - Stator
axes[0, 0].plot(t, psi_qse, 'b', label='ψ_qs^e')
axes[0, 0].plot(t, psi_dse, 'r', label='ψ_ds^e')
axes[0, 0].set_ylabel('Stator Flux (Wb)')
axes[0, 0].set_xlabel('Time (s)')
axes[0, 0].legend()
axes[0, 0].grid(True)
axes[0, 0].set_title('Stator Flux Linkages (Synchronous Frame)')

# Flux linkages - Rotor
axes[0, 1].plot(t, psi_qre, 'b', label="ψ_qr'^e")
axes[0, 1].plot(t, psi_dre, 'r', label="ψ_dr'^e")
axes[0, 1].set_ylabel("Rotor Flux (Wb)")
axes[0, 1].set_xlabel('Time (s)')
axes[0, 1].legend()
axes[0, 1].grid(True)
axes[0, 1].set_title('Rotor Flux Linkages (Synchronous Frame)')

# Currents in synchronous frame
axes[1, 0].plot(t, iqse, 'b', label='i_qs^e')
axes[1, 0].plot(t, idse, 'r', label='i_ds^e')
axes[1, 0].set_ylabel('Stator Current (A)')
axes[1, 0].set_xlabel('Time (s)')
axes[1, 0].legend()
axes[1, 0].grid(True)
axes[1, 0].set_title('Stator Currents (Synchronous Frame)')

# Rotor currents
axes[1, 1].plot(t, iqre, 'b', label="i_qr'^e")
axes[1, 1].plot(t, idre, 'r', label="i_dr'^e")
axes[1, 1].set_ylabel('Rotor Current (A)')
axes[1, 1].set_xlabel('Time (s)')
axes[1, 1].legend()
axes[1, 1].grid(True)
axes[1, 1].set_title('Rotor Currents (Synchronous Frame)')

# Electromagnetic torque
axes[2, 0].plot(t, Te / Tb, 'b', linewidth=1.5)
axes[2, 0].set_ylabel('Torque (pu)')
axes[2, 0].set_xlabel('Time (s)')
axes[2, 0].axhline(y=0, color='k', linestyle='--', linewidth=0.5)
axes[2, 0].grid(True)
axes[2, 0].set_title('Electromagnetic Torque')

# Rotor speed and slip
ax1 = axes[2, 1]
ax1.plot(t, wr_rpm, 'b', linewidth=1.5, label='Speed')
ax1.set_ylabel('Speed (RPM)', color='b')
ax1.tick_params(axis='y', labelcolor='b')
ax1.axhline(y=Nrated, color='b', linestyle='--', linewidth=0.5, alpha=0.5)
ax1.grid(True)

ax2 = ax1.twinx()
ax2.plot(t, slip * 100, 'r', linewidth=1.5, label='Slip')
ax2.set_ylabel('Slip (%)', color='r')
ax2.tick_params(axis='y', labelcolor='r')
ax2.axhline(y=srated * 100, color='r', linestyle='--', linewidth=0.5, alpha=0.5)

axes[2, 1].set_xlabel('Time (s)')
axes[2, 1].set_title('Rotor Speed and Slip')

plt.tight_layout()
plt.savefig('/home/rodo/Maquinas/C6/S4EIG_results.png', dpi=150)
print("Plot saved to /home/rodo/Maquinas/C6/S4EIG_results.png")
plt.show()

# Print final values
print("\n" + "="*60)
print("Final Steady-State Values (Synchronous Frame):")
print("="*60)
print(f"Rotor speed: {wr_rpm[-1]:.2f} RPM (rated: {Nrated:.2f} RPM)")
print(f"Slip: {slip[-1]*100:.4f} % (rated: {srated*100:.2f} %)")
print(f"Electromagnetic torque: {Te[-1]/Tb:.4f} pu")
print(f"Stator current (q-axis): {iqse[-1]:.2f} A")
print(f"Stator current (d-axis): {idse[-1]:.2f} A")
print(f"Stator current magnitude: {np.sqrt(iqse[-1]**2 + idse[-1]**2):.2f} A")
print(f"Flux linkage psi_ds^e: {psi_dse[-1]:.4f} Wb")
print(f"Flux linkage psi_qs^e: {psi_qse[-1]:.4f} Wb")
