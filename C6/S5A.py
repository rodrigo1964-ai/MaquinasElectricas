#!/usr/bin/env python3
"""
S5A.py - Induction machine with neutral voltage (grounded wye connection)
Studies effect of neutral-to-ground voltage on machine performance
Includes zero-sequence circuit with capacitor to ground
"""
import numpy as np
from scipy.integrate import solve_ivp
from scipy.interpolate import interp1d
import matplotlib.pyplot as plt

def simulate_with_neutral(params, tstop=2.0, plot=True):
    """
    Simulate induction machine with neutral voltage in stationary frame.

    This model includes the zero-sequence circuit which allows for
    neutral-to-ground voltage to develop when the sum of phase currents
    is non-zero (e.g., due to unbalanced conditions or capacitance to ground).

    Parameters:
    -----------
    params : dict
        Machine and circuit parameters
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
    Tmech_val = params['Tmech']  # Constant mechanical load

    # Capacitor to ground (for neutral voltage simulation)
    Csg = 50 * Zb * wb  # Capacitance gain

    def model_equations(t, x):
        """
        State vector x = [psiqs, psiqr, psids, psidr, wr_wb, vsg, i0s]
        Additional states for neutral voltage modeling:
        - vsg: neutral-to-ground voltage
        - i0s: zero-sequence current
        """
        psiqs = x[0]
        psiqr = x[1]
        psids = x[2]
        psidr = x[3]
        wr_wb = x[4]
        vsg = x[5]
        i0s = x[6]

        # Three-phase voltages (balanced supply)
        omega_t = 2 * np.pi * 60 * t
        vag = Vm * np.cos(omega_t)
        vbg = Vm * np.cos(omega_t - 2*np.pi/3)
        vcg = Vm * np.cos(omega_t + 2*np.pi/3)

        # abc to qds transformation
        vqs = (2/3) * (vag - (vbg + vcg)/2)
        vds = (vbg - vcg) / np.sqrt(3)
        v0s_supply = (vag + vbg + vcg) / 3

        # Zero-sequence voltage (accounting for neutral shift)
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
        # Sum of phase currents (should be zero for balanced, but can be non-zero)
        ias_ibs_ics_sum = 3 * i0s  # In qds, sum = 3*i0s when balanced

        # Neutral voltage dynamics (capacitor charging)
        dvsg_dt = Csg * ias_ibs_ics_sum

        # Zero-sequence current dynamics
        di0s_dt = (wb/xls) * (v0s - rs * i0s)

        return [dpsiqs_dt, dpsiqr_dt, dpsids_dt, dpsidr_dt, dwr_dt, dvsg_dt, di0s_dt]

    # Initial conditions
    y0 = [params['Psiqso'], params['Psipqro'], params['Psidso'],
          params['Psipdro'], params['wrbywbo'], 0.0, 0.0]

    # Solve ODE
    t_span = [0, tstop]
    t_eval = np.linspace(0, tstop, 2000)

    sol = solve_ivp(model_equations, t_span, y0, method='RK45',
                    t_eval=t_eval, rtol=1e-6, atol=1e-5,
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

        # Calculate currents
        iqs_arr = np.zeros_like(t)
        ids_arr = np.zeros_like(t)
        ias_arr = np.zeros_like(t)
        ibs_arr = np.zeros_like(t)
        ics_arr = np.zeros_like(t)
        Tem_arr = np.zeros_like(t)
        vag_arr = np.zeros_like(t)

        for i, ti in enumerate(t):
            psiqm = xM * (psiqs[i]/xls + psiqr[i]/xplr)
            psidm = xM * (psids[i]/xls + psidr[i]/xplr)
            iqs_arr[i] = (psiqs[i] - psiqm) / xls
            ids_arr[i] = (psids[i] - psidm) / xls

            # qds to abc transformation
            ias_arr[i] = iqs_arr[i] + i0s[i]
            ibs_arr[i] = -(iqs_arr[i] + np.sqrt(3)*ids_arr[i])/2 + i0s[i]
            ics_arr[i] = -(iqs_arr[i] - np.sqrt(3)*ids_arr[i])/2 + i0s[i]

            Tem_arr[i] = Tfactor * (psids[i] * iqs_arr[i] - psiqs[i] * ids_arr[i])

            omega_t = 2 * np.pi * 60 * ti
            vag_arr[i] = Vm * np.cos(omega_t)

        # Plot results
        fig, axs = plt.subplots(5, 1, figsize=(10, 12))

        axs[0].plot(t, vag_arr, label='vag')
        axs[0].plot(t, vsg, label='vsg (neutral)')
        axs[0].set_ylabel('Voltage (V)')
        axs[0].set_title('Phase and Neutral-to-Ground Voltages')
        axs[0].legend()
        axs[0].grid(True)

        axs[1].plot(t, ias_arr, label='ias')
        axs[1].plot(t, ibs_arr, label='ibs', alpha=0.7)
        axs[1].plot(t, ics_arr, label='ics', alpha=0.7)
        axs[1].set_ylabel('Current (A)')
        axs[1].set_title('Three-Phase Stator Currents')
        axs[1].legend()
        axs[1].grid(True)

        axs[2].plot(t, i0s)
        axs[2].set_ylabel('i0s (A)')
        axs[2].set_title('Zero-Sequence Current')
        axs[2].grid(True)

        axs[3].plot(t, Tem_arr)
        axs[3].set_ylabel('Tem (Nm)')
        axs[3].set_title('Electromagnetic Torque')
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

    # Package parameters
    params = {
        'rs': rs, 'rpr': rpr,
        'xls': xls, 'xplr': xplr, 'xM': xM,
        'wb': wb, 'Vm': Vm, 'H': H, 'Domega': Domega,
        'Tfactor': Tfactor, 'Zb': Zb, 'Tmech': Tmech_val,
        'Psiqso': Psiqso, 'Psipqro': Psipqro,
        'Psidso': Psidso, 'Psipdro': Psipdro, 'wrbywbo': wrbywbo
    }

    # Run simulation
    print("Running S5A - Induction Machine with Neutral Voltage")
    print("This model includes zero-sequence circuit and neutral-to-ground voltage")
    print(f"Mechanical torque: {Tmech_val:.2f} Nm")
    print(f"Simulation time: 0 to {tstop} seconds")

    sol = simulate_with_neutral(params, tstop=tstop, plot=True)
