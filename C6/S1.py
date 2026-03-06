#!/usr/bin/env python3
"""
S1.py - Three-phase induction machine simulation in stationary reference frame
Implements complete induction machine model with voltage supply and mechanical load
"""
import numpy as np
from scipy.integrate import solve_ivp
from scipy.interpolate import interp1d
import matplotlib.pyplot as plt

def simulate_induction_machine(params, tstop=2.0, plot=True):
    """
    Simulate three-phase induction machine in stationary qd0 reference frame.

    Parameters:
    -----------
    params : dict with keys:
        - rs, rpr: stator and rotor resistances
        - xls, xplr, xM: leakage and magnetizing reactances
        - wb: base electrical frequency
        - Vm: peak phase voltage
        - H: inertia constant
        - Domega: damping coefficient
        - Tfactor: torque factor
        - Zb: base impedance
        - tmech_time, tmech_value: mechanical torque profile
        - Psiqso, Psipqro, Psidso, Psipdro, wrbywbo: initial conditions
    tstop : float
        Simulation stop time
    plot : bool
        Whether to plot results

    Returns:
    --------
    sol : OdeResult
        Solution from solve_ivp
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

    # Mechanical torque interpolation
    tmech_time = params['tmech_time']
    tmech_value = params['tmech_value']
    Tmech_interp = interp1d(tmech_time, tmech_value, kind='linear',
                            bounds_error=False, fill_value=tmech_value[-1])

    def model_equations(t, x):
        """
        State vector x = [psiqs, psiqr, psids, psidr, wr_wb, vsg, i0s]
        States: 0-psiqs, 1-psiqr, 2-psids, 3-psidr, 4-wr/wb, 5-vsg, 6-i0s
        """
        psiqs = x[0]
        psiqr = x[1]
        psids = x[2]
        psidr = x[3]
        wr_wb = x[4]
        vsg = x[5]
        i0s = x[6]

        # Three-phase voltages (balanced supply)
        omega_t = 2 * np.pi * 60 * t  # 60 Hz supply
        vag = Vm * np.cos(omega_t)
        vbg = Vm * np.cos(omega_t - 2*np.pi/3)
        vcg = Vm * np.cos(omega_t + 2*np.pi/3)

        # abc to qds transformation
        vqs = (2/3) * (vag - (vbg + vcg)/2)
        vds = (vbg - vcg) / np.sqrt(3)
        v0s = (vag + vbg + vcg) / 3

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

        # Mechanical torque from load
        Tmech = Tmech_interp(t)

        # Rotor dynamics
        dwr_dt = (1/(2*H)) * (Tem - Tmech - Domega * wr_wb)

        # Zero sequence (capacitor to ground model)
        ias_ibs_ics = iqs + ids + i0s  # sum of phase currents
        dvsg_dt = (50 * Zb * wb) * ias_ibs_ics

        # Zero sequence current
        di0s_dt = (wb/xls) * (v0s - vsg - rs * i0s)

        return [dpsiqs_dt, dpsiqr_dt, dpsids_dt, dpsidr_dt, dwr_dt, dvsg_dt, di0s_dt]

    # Initial conditions
    y0 = [params['Psiqso'], params['Psipqro'], params['Psidso'],
          params['Psipdro'], params['wrbywbo'], 0.0, 0.0]

    # Solve ODE
    t_span = [0, tstop]
    t_eval = np.linspace(0, tstop, 2000)

    sol = solve_ivp(model_equations, t_span, y0, method='RK45',
                    t_eval=t_eval, rtol=1e-6, atol=1e-8,
                    dense_output=True)

    if not sol.success:
        print(f"Warning: Integration failed: {sol.message}")

    # Calculate output quantities
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
        fig, axs = plt.subplots(4, 1, figsize=(10, 10))

        axs[0].plot(t, vag_arr)
        axs[0].set_ylabel('vag (V)')
        axs[0].set_title('Stator Phase-to-Neutral Voltage')
        axs[0].grid(True)

        axs[1].plot(t, ias_arr)
        axs[1].set_ylabel('ias (A)')
        axs[1].set_title('Stator Phase Current')
        axs[1].grid(True)

        axs[2].plot(t, Tem_arr)
        axs[2].set_ylabel('Tem (Nm)')
        axs[2].set_title('Electromagnetic Torque')
        axs[2].grid(True)

        axs[3].plot(t, wr_wb)
        axs[3].set_ylabel('wr/wb')
        axs[3].set_xlabel('Time (s)')
        axs[3].set_title('Per-Unit Rotor Speed')
        axs[3].grid(True)

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

    # Mechanical torque profile
    tmech_time = np.array([0, 0.8, 0.8, 1.2, 1.2, 1.6, 1.6, tstop])
    tmech_value = np.array([0, 0, -0.5, -0.5, -1.0, -1.0, -0.5, -0.5]) * Tb

    # Package parameters
    params = {
        'rs': rs, 'rpr': rpr,
        'xls': xls, 'xplr': xplr, 'xM': xM,
        'wb': wb, 'Vm': Vm, 'H': H, 'Domega': Domega,
        'Tfactor': Tfactor, 'Zb': Zb,
        'tmech_time': tmech_time, 'tmech_value': tmech_value,
        'Psiqso': Psiqso, 'Psipqro': Psipqro,
        'Psidso': Psidso, 'Psipdro': Psipdro, 'wrbywbo': wrbywbo
    }

    # Run simulation
    print("Running S1 - Induction Machine in Stationary Reference Frame")
    print(f"Simulation time: 0 to {tstop} seconds")
    sol = simulate_induction_machine(params, tstop=tstop, plot=True)
