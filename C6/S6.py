#!/usr/bin/env python3
"""
S6.py - Single-phase induction motor with capacitor start/run
Models single-phase motor with auxiliary winding and capacitor switching
Includes capacitor start and capacitor run configurations
"""
import numpy as np
from scipy.integrate import solve_ivp
from scipy.interpolate import interp1d
import matplotlib.pyplot as plt

def simulate_single_phase_motor(params, tstop=2.0, plot=True):
    """
    Simulate single-phase induction motor with starting and running capacitors.

    Single-phase motors use an auxiliary winding with a capacitor to create
    a rotating field for starting. The model includes:
    - Main winding (d-axis aligned)
    - Auxiliary winding (q-axis, with capacitor)
    - Automatic switching between start and run capacitors
    - Asymmetric machine parameters (different d and q axis reactances)

    Parameters:
    -----------
    params : dict
        Motor parameters including capacitor values and switching logic
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
    xplds = params.get('xplds', params['xls'])  # d-axis leakage (main winding)
    xls = params['xls']  # q-axis leakage (auxiliary winding)
    xplr = params['xplr']
    xMd = params.get('xMd', params['xM'])  # d-axis magnetizing
    xM = params['xM']  # q-axis magnetizing (used for auxiliary)
    wb = params['wb']
    Vm = params['Vm']
    H = params['H']
    Domega = params['Domega']
    Tfactor = params['Tfactor']

    # Mechanical load interpolation
    tmech_time = params['tmech_time']
    tmech_value = params['tmech_value']
    Tmech_interp = interp1d(tmech_time, tmech_value, kind='linear',
                            bounds_error=False, fill_value=tmech_value[-1])

    # Capacitor parameters
    Cstart = params.get('Cstart', 100e-6)  # Starting capacitor (Farads)
    Crun = params.get('Crun', 10e-6)  # Running capacitor (Farads)
    switch_speed = params.get('switch_speed', 0.75)  # Switch at 75% of sync speed
    start_cutoff_speed = params.get('start_cutoff_speed', 0.1)  # Disconnect start cap

    # Capacitor resistance (ESR)
    Rcstart = params.get('Rcstart', 0.1)
    Rcrun = params.get('Rcrun', 0.1)

    def model_equations(t, x):
        """
        State vector x = [psiqs, psiqr, psipds, psidr, wr_wb, Vcap]
        Note: psipds = psi'ds (primed d-axis for asymmetric machine)
        """
        psiqs = x[0]
        psiqr = x[1]
        psipds = x[2]  # Main winding flux
        psidr = x[3]
        wr_wb = x[4]
        Vcap = x[5]  # Capacitor voltage

        # Single-phase voltage (only on main winding, d-axis)
        omega_t = 2 * np.pi * 60 * t
        vqs_supply = Vm * np.sin(omega_t)  # Auxiliary winding voltage source

        # Capacitor switching logic
        # Start capacitor: active at low speeds
        # Run capacitor: active above threshold
        if abs(wr_wb) < start_cutoff_speed:
            # Below cutoff: only starting capacitor
            use_start_cap = 1.0
            use_run_cap = 0.0
        elif abs(wr_wb) < switch_speed:
            # Between cutoff and switch: both capacitors
            use_start_cap = 1.0
            use_run_cap = 1.0
        else:
            # Above switch speed: only run capacitor
            use_start_cap = 0.0
            use_run_cap = 1.0

        # Equivalent capacitance (parallel combination when both active)
        Ctotal = use_start_cap * Cstart + use_run_cap * Crun
        Rtotal = (use_start_cap * Rcstart * use_run_cap * Rcrun) / (use_start_cap * Rcstart + use_run_cap * Rcrun + 1e-12)
        if use_start_cap + use_run_cap < 0.5:
            Rtotal = 1e6  # Very high resistance when no cap

        # Q-axis voltage (auxiliary winding) includes capacitor
        # Auxiliary winding current flows through capacitor
        psiqm = xM * (psiqs/xls + psiqr/xplr)
        iqs = (psiqs - psiqm) / xls

        # Capacitor voltage provides voltage to auxiliary winding
        vqs = vqs_supply - Vcap - Rtotal * iqs

        # D-axis voltage (main winding, direct connection)
        vpds = 0.0  # Main winding grounded or connected differently

        # D-axis magnetizing flux (asymmetric)
        psidm = xMd * (psipds/xplds + psidr/xplr)

        # Currents
        ipds = (psipds - psidm) / xplds
        iqr = (psiqr - psiqm) / xplr
        idr = (psidr - psidm) / xplr

        # Stator equations (Q-axis, auxiliary winding)
        dpsiqs_dt = wb * (vqs + (rs/xls) * (psiqs - psiqm))
        dpsiqr_dt = wb * (wr_wb * psidr + (rpr/xplr) * (psiqr - psiqm))

        # Stator equations (D-axis, main winding)
        # Modified fcn: wb*(u[2]+(rs/xplds)*(u[1]-u[3]))
        dpsipds_dt = wb * (vpds + (rs/xplds) * (psipds - psidm))
        dpsidr_dt = wb * (-wr_wb * psiqr + (rpr/xplr) * (psidr - psidm))

        # Electromagnetic torque (modified for single-phase)
        # Te = Tfactor * (psi'ds * iqs - psiqs * i'ds)
        Tem = Tfactor * (psipds * iqs - psiqs * ipds)

        # Mechanical torque from load
        Tmech = Tmech_interp(t)

        # Rotor dynamics
        dwr_dt = (1/(2*H)) * (Tem - Tmech - Domega * wr_wb)

        # Capacitor dynamics
        # dVcap/dt = (1/C) * icap = (1/C) * iqs
        if Ctotal > 1e-9:
            dVcap_dt = iqs / Ctotal
        else:
            dVcap_dt = 0.0

        return [dpsiqs_dt, dpsiqr_dt, dpsipds_dt, dpsidr_dt, dwr_dt, dVcap_dt]

    # Initial conditions
    y0 = [params['Psiqso'], params['Psipqro'], params['Psidso'],
          params['Psipdro'], params['wrbywbo'], 0.0]

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
        psipds = sol.y[2]
        psidr = sol.y[3]
        wr_wb = sol.y[4]
        Vcap = sol.y[5]

        # Calculate currents and torque
        iqs_arr = np.zeros_like(t)
        ipds_arr = np.zeros_like(t)
        Tem_arr = np.zeros_like(t)
        vqs_arr = np.zeros_like(t)
        cap_state = np.zeros_like(t)  # Capacitor state (start/run)

        for i, ti in enumerate(t):
            psiqm = xM * (psiqs[i]/xls + psiqr[i]/xplr)
            psidm = xMd * (psipds[i]/xplds + psidr[i]/xplr)

            iqs_arr[i] = (psiqs[i] - psiqm) / xls
            ipds_arr[i] = (psipds[i] - psidm) / xplds

            Tem_arr[i] = Tfactor * (psipds[i] * iqs_arr[i] - psiqs[i] * ipds_arr[i])

            omega_t = 2 * np.pi * 60 * ti
            vqs_arr[i] = Vm * np.sin(omega_t)

            # Capacitor state
            if abs(wr_wb[i]) < start_cutoff_speed:
                cap_state[i] = 1  # Start only
            elif abs(wr_wb[i]) < switch_speed:
                cap_state[i] = 2  # Both
            else:
                cap_state[i] = 3  # Run only

        # Plot results
        fig, axs = plt.subplots(5, 1, figsize=(10, 12))

        axs[0].plot(t, vqs_arr, label='Supply voltage')
        axs[0].plot(t, Vcap, label='Capacitor voltage', alpha=0.7)
        axs[0].set_ylabel('Voltage (V)')
        axs[0].set_title('Single-Phase Supply and Capacitor Voltages')
        axs[0].legend()
        axs[0].grid(True)

        axs[1].plot(t, iqs_arr, label='iqs (auxiliary)')
        axs[1].plot(t, ipds_arr, label='ipds (main)', alpha=0.7)
        axs[1].set_ylabel('Current (A)')
        axs[1].set_title('Main and Auxiliary Winding Currents')
        axs[1].legend()
        axs[1].grid(True)

        axs[2].plot(t, cap_state)
        axs[2].set_ylabel('Cap State')
        axs[2].set_title('Capacitor Configuration (1=Start, 2=Both, 3=Run)')
        axs[2].set_yticks([1, 2, 3])
        axs[2].set_yticklabels(['Start', 'Both', 'Run'])
        axs[2].grid(True)

        axs[3].plot(t, Tem_arr)
        axs[3].set_ylabel('Tem (Nm)')
        axs[3].set_title('Electromagnetic Torque')
        axs[3].grid(True)

        axs[4].plot(t, wr_wb)
        axs[4].axhline(y=switch_speed, color='r', linestyle='--',
                      label=f'Switch speed ({switch_speed})')
        axs[4].axhline(y=start_cutoff_speed, color='g', linestyle='--',
                      label=f'Cutoff speed ({start_cutoff_speed})')
        axs[4].set_ylabel('wr/wb')
        axs[4].set_xlabel('Time (s)')
        axs[4].set_title('Per-Unit Rotor Speed')
        axs[4].legend()
        axs[4].grid(True)

        plt.tight_layout()
        plt.show()

    return sol


if __name__ == "__main__":
    # Load parameters from p20hp (or specialized single-phase motor parameters)
    from p20hp import *

    # Initial conditions (start from rest)
    Psiqso = 0.0
    Psipqro = 0.0
    Psidso = 0.0
    Psipdro = 0.0
    wrbywbo = 0.0
    tstop = 3.0

    # Mechanical torque profile
    tmech_time = np.array([0, 0.5, 0.5, 1.5, 1.5, tstop])
    tmech_value = np.array([0, 0, -0.3, -0.3, -0.6, -0.6]) * Tb

    # Single-phase motor specific parameters
    # For asymmetric machine, d and q axis reactances differ
    xplds = xls * 1.2  # Main winding leakage slightly higher
    xMd = xM * 0.9  # d-axis magnetizing reactance

    # Capacitor values (typical for single-phase motor)
    # Starting capacitor: 100-300 µF for fractional HP motors
    # Running capacitor: 10-50 µF
    Cstart = 200e-6  # 200 µF starting capacitor
    Crun = 20e-6  # 20 µF running capacitor
    Rcstart = 0.5  # ESR of start capacitor
    Rcrun = 0.2  # ESR of run capacitor

    # Switching speeds (as fraction of synchronous speed)
    switch_speed = 0.75  # Disconnect start cap at 75% speed
    start_cutoff_speed = 0.10  # Minimum speed to engage start cap

    # Package parameters
    params = {
        'rs': rs, 'rpr': rpr,
        'xls': xls, 'xplds': xplds,
        'xplr': xplr, 'xM': xM, 'xMd': xMd,
        'wb': wb, 'Vm': Vm, 'H': H, 'Domega': Domega,
        'Tfactor': Tfactor,
        'tmech_time': tmech_time, 'tmech_value': tmech_value,
        'Psiqso': Psiqso, 'Psipqro': Psipqro,
        'Psidso': Psidso, 'Psipdro': Psipdro, 'wrbywbo': wrbywbo,
        'Cstart': Cstart, 'Crun': Crun,
        'Rcstart': Rcstart, 'Rcrun': Rcrun,
        'switch_speed': switch_speed,
        'start_cutoff_speed': start_cutoff_speed
    }

    # Run simulation
    print("Running S6 - Single-Phase Induction Motor with Capacitor Start/Run")
    print(f"Starting capacitor: {Cstart*1e6:.0f} µF")
    print(f"Running capacitor: {Crun*1e6:.0f} µF")
    print(f"Start capacitor disconnects at {switch_speed*100:.0f}% of sync speed")
    print(f"Simulation time: 0 to {tstop} seconds")
    print("\nNote: Single-phase motors require capacitors to create rotating field")
    print("      Start capacitor provides high starting torque")
    print("      Run capacitor improves efficiency at running speed")

    sol = simulate_single_phase_motor(params, tstop=tstop, plot=True)
