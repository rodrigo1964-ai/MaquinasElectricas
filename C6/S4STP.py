#!/usr/bin/env python3
"""
S4STP.py - Step response of induction machine in synchronous reference frame
Studies transient response to voltage step changes
"""
import numpy as np
from scipy.integrate import solve_ivp
from scipy.interpolate import interp1d
import matplotlib.pyplot as plt

def simulate_step_response(params, vqse_profile, tstop=1.2, plot=True):
    """
    Simulate induction machine step response in synchronous reference frame.

    Parameters:
    -----------
    params : dict
        Machine parameters
    vqse_profile : tuple (time_array, voltage_array)
        Time-varying Q-axis voltage profile
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
    we = params['we']
    H = params['H']
    Domega = params['Domega']
    Tfactor = params['Tfactor']
    Tmech = params['Tmech']  # Constant mechanical load

    # Create interpolation for vqse
    vqse_time, vqse_values = vqse_profile
    vqse_interp = interp1d(vqse_time, vqse_values, kind='linear',
                          bounds_error=False, fill_value=vqse_values[-1])

    # D-axis voltage (kept at zero)
    vdse = 0.0

    # Normalized synchronous frequency
    we_wb = we / wb

    def model_equations(t, x):
        """
        State vector x = [psiqs, psiqr, psids, psidr, wr_wb]
        """
        psiqs = x[0]
        psiqr = x[1]
        psids = x[2]
        psidr = x[3]
        wr_wb = x[4]

        # Get time-varying voltage
        vqse = float(vqse_interp(t))

        # Magnetizing flux
        psiqm = xM * (psiqs/xls + psiqr/xplr)
        psidm = xM * (psids/xls + psidr/xplr)

        # Stator currents
        iqse = (psiqs - psiqm) / xls
        idse = (psids - psidm) / xls

        # Rotor currents
        iqr = (psiqr - psiqm) / xplr
        idr = (psidr - psidm) / xplr

        # Slip speed term
        wr_we_wb = wr_wb - we_wb

        # Q-axis equations
        dpsiqs_dt = wb * (vqse - we_wb * psids + (rs/xls) * (psiqs - psiqm))
        dpsiqr_dt = wb * (wr_we_wb * psidr + (rpr/xplr) * (psiqr - psiqm))

        # D-axis equations
        dpsids_dt = wb * (vdse + we_wb * psiqs + (rs/xls) * (psids - psidm))
        dpsidr_dt = wb * (-wr_we_wb * psiqr + (rpr/xplr) * (psidr - psidm))

        # Electromagnetic torque
        Tem = Tfactor * (psids * iqse - psiqs * idse)

        # Rotor dynamics
        dwr_dt = (1/(2*H)) * (Tem - Tmech - Domega * wr_wb)

        return [dpsiqs_dt, dpsiqr_dt, dpsids_dt, dpsidr_dt, dwr_dt]

    # Initial conditions
    y0 = [params['Psiqso'], params['Psipqro'], params['Psidso'],
          params['Psipdro'], params['wrbywbo']]

    # Solve ODE
    t_span = [0, tstop]
    t_eval = np.linspace(0, tstop, 3000)

    sol = solve_ivp(model_equations, t_span, y0, method='RK45',
                    t_eval=t_eval, rtol=1e-6, atol=1e-6,
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

        # Calculate currents and torque
        iqse_arr = np.zeros_like(t)
        idse_arr = np.zeros_like(t)
        Tem_arr = np.zeros_like(t)
        vqse_arr = np.zeros_like(t)

        for i in range(len(t)):
            psiqm = xM * (psiqs[i]/xls + psiqr[i]/xplr)
            psidm = xM * (psids[i]/xls + psidr[i]/xplr)
            iqse_arr[i] = (psiqs[i] - psiqm) / xls
            idse_arr[i] = (psids[i] - psidm) / xls
            Tem_arr[i] = Tfactor * (psids[i] * iqse_arr[i] - psiqs[i] * idse_arr[i])
            vqse_arr[i] = vqse_interp(t[i])

        # Plot results
        fig, axs = plt.subplots(4, 1, figsize=(10, 10))

        axs[0].plot(t, vqse_arr)
        axs[0].set_ylabel('vqse (V)')
        axs[0].set_title('Q-Axis Voltage Step Input')
        axs[0].grid(True)

        axs[1].plot(t, iqse_arr, label='iqse')
        axs[1].plot(t, idse_arr, label='idse')
        axs[1].set_ylabel('Current (A)')
        axs[1].set_title('Synchronous Frame Stator Currents')
        axs[1].legend()
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

    # Initial conditions (start from standstill or steady state)
    Psiqso = 0.0
    Psipqro = 0.0
    Psidso = 0.0
    Psipdro = 0.0
    wrbywbo = 0.0  # Start from rest

    # Mechanical torque (constant load)
    Tmech_val = -Tb  # Full load

    # Voltage step profile (step increase at t=1s)
    # Start at rated voltage, step up at 1 second
    vqse_time = np.array([0, 1.0, 1.0, 1.2])
    vqse_values = np.array([Vm, Vm, Vm+1, Vm+1])
    vqse_profile = (vqse_time, vqse_values)

    # Simulation time
    tstop = 1.2

    # Package parameters
    params = {
        'rs': rs, 'rpr': rpr,
        'xls': xls, 'xplr': xplr, 'xM': xM,
        'wb': wb, 'we': we, 'H': H, 'Domega': Domega,
        'Tfactor': Tfactor, 'Tmech': Tmech_val,
        'Psiqso': Psiqso, 'Psipqro': Psipqro,
        'Psidso': Psidso, 'Psipdro': Psipdro, 'wrbywbo': wrbywbo
    }

    # Run simulation
    print("Running S4STP - Step Response in Synchronous Reference Frame")
    print(f"Voltage step: {Vm:.2f}V -> {Vm+1:.2f}V at t=1.0s")
    print(f"Mechanical torque: {Tmech_val:.2f} Nm")
    print(f"Simulation time: 0 to {tstop} seconds")

    sol = simulate_step_response(params, vqse_profile, tstop=tstop, plot=True)
