#!/usr/bin/env python3
"""
S5B.py - Induction machine with unbalanced load and neutral voltage
Studies machine performance under unbalanced voltage/load conditions
Includes variable frequency drive and neutral voltage effects
"""
import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt

def simulate_unbalanced_load(params, tstop=2.0, plot=True):
    """
    Simulate induction machine with unbalanced voltage supply.

    This model demonstrates machine behavior under:
    - Unbalanced voltage supply
    - Variable frequency operation
    - Neutral voltage development
    - Zero-sequence effects

    Parameters:
    -----------
    params : dict
        Machine parameters including unbalance parameters
    tstop : float
        Simulation time
    plot : bool
        Whether to plot results

    Returns:
    --------
    sol : OdeResult
        Solution object
    """

    # Extract parameters
    rs = params['rs']
    rpr = params['rpr']
    xls = params['xls']
    xplr = params['xplr']
    xM = params['xM']
    wb = params['wb']
    Vm = params['Vm']
    H = params['H']
    Domega = params['Domega']
    Tfactor = params['Tfactor']
    Zb = params['Zb']
    Tmech_val = params['Tmech']

    # Unbalance parameters
    unbalance_factor = params.get('unbalance_factor', 0.1)  # 10% voltage unbalance
    frequency_ramp = params.get('frequency_ramp', False)

    # Capacitor to ground
    Csg = 50 * Zb * wb

    def model_equations(t, x):
        """
        State vector x = [psiqs, psiqr, psids, psidr, wr_wb, vsg, i0s, theta]
        theta: integrator for variable frequency
        """
        psiqs = x[0]
        psiqr = x[1]
        psids = x[2]
        psidr = x[3]
        wr_wb = x[4]
        vsg = x[5]
        i0s = x[6]

        if len(x) > 7:
            theta = x[7]
        else:
            theta = 0.0

        # Variable frequency (V/Hz control with ramp)
        if frequency_ramp and t < 1.0:
            # Ramp up frequency from 0 to 60 Hz in 1 second
            freq = 60 * t
        else:
            freq = 60.0

        omega_e = 2 * np.pi * freq

        # Three-phase unbalanced voltages
        # Phase A: nominal
        # Phase B: reduced by unbalance_factor
        # Phase C: nominal
        vag = Vm * np.cos(omega_e * t)
        vbg = (1 - unbalance_factor) * Vm * np.cos(omega_e * t - 2*np.pi/3)
        vcg = Vm * np.cos(omega_e * t + 2*np.pi/3)

        # Voltage unbalance also affects form factor (optional)
        # V/Hz control to maintain flux
        voltage_scale = freq / 60.0 if freq < 60.0 else 1.0
        vag *= voltage_scale
        vbg *= voltage_scale
        vcg *= voltage_scale

        # abc to qds transformation
        vqs = (2/3) * (vag - (vbg + vcg)/2)
        vds = (vbg - vcg) / np.sqrt(3)
        v0s_supply = (vag + vbg + vcg) / 3

        # Zero-sequence voltage
        v0s = v0s_supply - vsg

        # Magnetizing flux
        psiqm = xM * (psiqs/xls + psiqr/xplr)
        psidm = xM * (psids/xls + psidr/xplr)

        # Stator currents
        iqs = (psiqs - psiqm) / xls
        ids = (psids - psidm) / xls

        # Rotor currents
        iqr = (psiqr - psiqm) / xplr
        idr = (psidr - psidm) / xplr

        # Q-axis equations
        dpsiqs_dt = wb * (vqs + (rs/xls) * (psiqs - psiqm))
        dpsiqr_dt = wb * (wr_wb * psidr + (rpr/xplr) * (psiqr - psiqm))

        # D-axis equations
        dpsids_dt = wb * (vds + (rs/xls) * (psids - psidm))
        dpsidr_dt = wb * (-wr_wb * psiqr + (rpr/xplr) * (psidr - psidm))

        # Electromagnetic torque
        Tem = Tfactor * (psids * iqs - psiqs * ids)

        # Rotor dynamics
        dwr_dt = (1/(2*H)) * (Tem - Tmech_val - Domega * wr_wb)

        # Zero sequence circuit
        ias_ibs_ics_sum = 3 * i0s

        # Neutral voltage dynamics
        dvsg_dt = Csg * ias_ibs_ics_sum

        # Zero-sequence current dynamics
        di0s_dt = (wb/xls) * (v0s - rs * i0s)

        # Frequency integrator (for variable freq operation)
        dtheta_dt = omega_e

        if len(x) > 7:
            return [dpsiqs_dt, dpsiqr_dt, dpsids_dt, dpsidr_dt, dwr_dt, dvsg_dt, di0s_dt, dtheta_dt]
        else:
            return [dpsiqs_dt, dpsiqr_dt, dpsids_dt, dpsidr_dt, dwr_dt, dvsg_dt, di0s_dt]

    # Initial conditions
    if frequency_ramp:
        y0 = [params['Psiqso'], params['Psipqro'], params['Psidso'],
              params['Psipdro'], params['wrbywbo'], 0.0, 0.0, 0.0]
    else:
        y0 = [params['Psiqso'], params['Psipqro'], params['Psidso'],
              params['Psipdro'], params['wrbywbo'], 0.0, 0.0]

    # Solve ODE
    t_span = [0, tstop]
    t_eval = np.linspace(0, tstop, 3000)

    sol = solve_ivp(model_equations, t_span, y0, method='RK45',
                    t_eval=t_eval, rtol=5e-6, atol=1e-6,
                    dense_output=True)

    if not sol.success:
        print(f"Warning: Integration failed: {sol.message}")

    # Calculate output quantities and plot
    if plot and sol.success:
        t = sol.t
        psiqs = sol.y[0]
        psiqr = sol.y[1]
        psids = sol.y[2]
        psidr = sol.y[3]
        wr_wb = sol.y[4]
        vsg = sol.y[5]
        i0s = sol.y[6]

        # Calculate currents and voltages
        iqs_arr = np.zeros_like(t)
        ids_arr = np.zeros_like(t)
        ias_arr = np.zeros_like(t)
        ibs_arr = np.zeros_like(t)
        ics_arr = np.zeros_like(t)
        Tem_arr = np.zeros_like(t)
        vag_arr = np.zeros_like(t)
        vbg_arr = np.zeros_like(t)
        vcg_arr = np.zeros_like(t)

        for i, ti in enumerate(t):
            # Recalculate voltages
            if frequency_ramp and ti < 1.0:
                freq = 60 * ti
            else:
                freq = 60.0

            omega_e = 2 * np.pi * freq
            voltage_scale = freq / 60.0 if freq < 60.0 else 1.0

            vag_arr[i] = voltage_scale * Vm * np.cos(omega_e * ti)
            vbg_arr[i] = voltage_scale * (1 - unbalance_factor) * Vm * np.cos(omega_e * ti - 2*np.pi/3)
            vcg_arr[i] = voltage_scale * Vm * np.cos(omega_e * ti + 2*np.pi/3)

            psiqm = xM * (psiqs[i]/xls + psiqr[i]/xplr)
            psidm = xM * (psids[i]/xls + psidr[i]/xplr)
            iqs_arr[i] = (psiqs[i] - psiqm) / xls
            ids_arr[i] = (psids[i] - psidm) / xls

            # qds to abc transformation
            ias_arr[i] = iqs_arr[i] + i0s[i]
            ibs_arr[i] = -(iqs_arr[i] + np.sqrt(3)*ids_arr[i])/2 + i0s[i]
            ics_arr[i] = -(iqs_arr[i] - np.sqrt(3)*ids_arr[i])/2 + i0s[i]

            Tem_arr[i] = Tfactor * (psids[i] * iqs_arr[i] - psiqs[i] * ids_arr[i])

        # Plot results
        fig, axs = plt.subplots(5, 1, figsize=(10, 12))

        axs[0].plot(t, vag_arr, label='vag', alpha=0.8)
        axs[0].plot(t, vbg_arr, label='vbg (unbalanced)', alpha=0.8)
        axs[0].plot(t, vcg_arr, label='vcg', alpha=0.8)
        axs[0].set_ylabel('Voltage (V)')
        axs[0].set_title(f'Unbalanced Three-Phase Voltages ({unbalance_factor*100:.0f}% unbalance)')
        axs[0].legend()
        axs[0].grid(True)

        axs[1].plot(t, ias_arr, label='ias')
        axs[1].plot(t, ibs_arr, label='ibs', alpha=0.7)
        axs[1].plot(t, ics_arr, label='ics', alpha=0.7)
        axs[1].set_ylabel('Current (A)')
        axs[1].set_title('Three-Phase Stator Currents')
        axs[1].legend()
        axs[1].grid(True)

        axs[2].plot(t, vsg, label='vsg (neutral)')
        axs[2].plot(t, i0s * 10, label='i0s × 10')
        axs[2].set_ylabel('V / (A×10)')
        axs[2].set_title('Neutral Voltage and Zero-Sequence Current')
        axs[2].legend()
        axs[2].grid(True)

        axs[3].plot(t, Tem_arr)
        axs[3].set_ylabel('Tem (Nm)')
        axs[3].set_title('Electromagnetic Torque (with pulsations from unbalance)')
        axs[3].grid(True)

        axs[4].plot(t, wr_wb)
        axs[4].set_ylabel('wr/wb')
        axs[4].set_xlabel('Time (s)')
        axs[4].set_title('Per-Unit Rotor Speed')
        axs[4].grid(True)

        plt.tight_layout()
        plt.show()

    return sol


if __name__ == "__main__":
    # Load parameters from p20hp
    from p20hp import *

    # Initial conditions (start from standstill)
    Psiqso = 0.0
    Psipqro = 0.0
    Psidso = 0.0
    Psipdro = 0.0
    wrbywbo = 0.0
    tstop = 2.0

    # Mechanical torque (constant load)
    Tmech_val = -0.5 * Tb

    # Unbalance factor (10% voltage reduction in phase B)
    unbalance_factor = 0.10

    # Package parameters
    params = {
        'rs': rs, 'rpr': rpr,
        'xls': xls, 'xplr': xplr, 'xM': xM,
        'wb': wb, 'Vm': Vm, 'H': H, 'Domega': Domega,
        'Tfactor': Tfactor, 'Zb': Zb, 'Tmech': Tmech_val,
        'Psiqso': Psiqso, 'Psipqro': Psipqro,
        'Psidso': Psidso, 'Psipdro': Psipdro, 'wrbywbo': wrbywbo,
        'unbalance_factor': unbalance_factor,
        'frequency_ramp': False  # Set True for V/Hz control
    }

    # Run simulation
    print("Running S5B - Induction Machine with Unbalanced Load")
    print(f"Voltage unbalance: {unbalance_factor*100:.0f}% in phase B")
    print(f"Mechanical torque: {Tmech_val:.2f} Nm")
    print(f"Simulation time: 0 to {tstop} seconds")
    print("\nNote: Unbalanced voltages cause:")
    print("  - Torque pulsations at twice line frequency")
    print("  - Increased losses and heating")
    print("  - Zero-sequence currents")

    sol = simulate_unbalanced_load(params, tstop=tstop, plot=True)
    # Clock: Clock
    # Integrator: Integrator
    # SubSystem: m5
    # Mux: Mux
    # Product: Product
    # Product: Product1
    # Product: Product2
    # Scope: Scope
    # SubSystem: Sign
    # Constant: Constant
    # RelationalOperator: Relational\nOperator
    # RelationalOperator: Relational\nOperator1
    # Sum: Sum
    # Outport: out_1
    # SubSystem: Sign1
    # Constant: Constant
    # RelationalOperator: Relational\nOperator
    # RelationalOperator: Relational\nOperator1
    # Sum: Sum
    # Outport: out_1
    # SubSystem: Sign2
    # Constant: Constant
    # RelationalOperator: Relational\nOperator
    # RelationalOperator: Relational\nOperator1
    # Sum: Sum
    # Outport: out_1
    # Constant: Tmech
    # ToWorkspace: To Workspace
    # Fcn: V/Hz & form factor
    # SubSystem: induction machine\nin stationary qd0
    # Inport: in_vbg
    # Inport: in_vcg
    # Inport: in_Tmech
    # SubSystem: Daxis
    # Inport: in_(wr/wb)*psiqr'
    # Fcn: Fcn
    # Fcn: Fcn2
    # Fcn: Fcn3
    # Fcn: Fcn4
    # Fcn: Fcn5
    # Mux: Mux
    # Mux: Mux1
    # Mux: Mux2
    # Mux: Mux3
    # Mux: Mux4
    # Integrator: psidr'_
    # Integrator: psids_
    # Outport: out_psids
    # Outport: out_ids
    # Outport: out_idr'
    # Outport: out_psidr'
    # Product: Product
    # Product: Product1
    # SubSystem: Qaxis
    # Inport: in_(wr/wb)*psidr'
    # Fcn: Fcn
    # Fcn: Fcn2
    # Fcn: Fcn3
    # Fcn: Fcn4
    # Fcn: Fcn5
    # Mux: Mux
    # Mux: Mux1
    # Mux: Mux2
    # Mux: Mux3
    # Mux: Mux4
    # Integrator: psiqr'_
    # Integrator: psiqs_
    # Outport: out_psiqs
    # Outport: out_iqs
    # Outport: out_iqr'
    # Outport: out_psiqr'
    # SubSystem: Rotor
    # Inport: in_iqs
    # Inport: in_psiqs
    # Inport: in_ids
    # Inport: in_Tmech
    # Gain: 1/2H
    # Integrator: 1/s
    # Gain: Damping\ncoefficient
    # Mux: Mux
    # Sum: Taccl
    # Fcn: Tem_
    # Outport: out_Tem
    # Outport: out_wr/wb
    # Sum: Sum
    # Terminator: T
    # Terminator: T1
    # SubSystem: Zero_seq
    # Integrator: Integrator
    # Sum: Sum
    # Gain: rs
    # Gain: wb/xls
    # Outport: out_i0s
    # SubSystem: abc2qds
    # Inport: in_vbg
    # Inport: in_vcg
    # Inport: ias+ibs+ics
    # Gain: 1/Csg
    # Fcn: Fcn
    # Fcn: Fcn1
    # Fcn: Fcn2
    # Mux: Mux
    # Sum: Sum
    # Sum: Sum1
    # Outport: out_vqs
    # Outport: out_vds
    # Outport: out_v0s
    # Outport: out_vsg
    # SubSystem: qds2abc
    # Inport: in_ids
    # Inport: in_i0s
    # Fcn: Fcn
    # Fcn: Fcn1
    # Fcn: Fcn2
    # Mux: Mux
    # Outport: out_ias
    # Outport: out_ibs
    # Outport: out_ics
    # Outport: out_ias
    # Outport: out_wr/wb
    # Outport: out_Tem
    # Outport: out_vsg
    # Fcn: vag
    # Fcn: vbg
    # Fcn: vcg
    # Constant: we

    dydt = []  # Implementar derivadas
    return dydt

# Condiciones iniciales
y0 = []  # Definir según bloques Integrator

# Resolver
sol = solve_ivp(model_equations, [0, t_stop], y0,
                method='RK45', rtol=rtol, atol=atol)

# Graficar
plt.figure()
plt.plot(sol.t, sol.y.T)
plt.xlabel('Time (s)')
plt.ylabel('States')
plt.title(f'{self.model_name} - Simulation Results')
plt.grid(True)
plt.show()
