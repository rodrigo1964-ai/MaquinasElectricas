#!/usr/bin/env python3
"""
S4EIG.py - Induction machine in synchronous reference frame for eigenvalue analysis
Implements machine model in synchronously rotating reference frame (we = constant)
"""
import numpy as np
from scipy.integrate import solve_ivp
from scipy.linalg import eig
import matplotlib.pyplot as plt

def simulate_synchronous_frame(params, vqse, vdse, Tmech, tstop=1.0, plot=True):
    """
    Simulate induction machine in synchronous reference frame.

    In this frame, the reference frame rotates at synchronous speed we.
    This is useful for eigenvalue analysis and steady-state studies.

    Parameters:
    -----------
    params : dict
        Machine parameters
    vqse : float
        Q-axis synchronous frame voltage (constant)
    vdse : float
        D-axis synchronous frame voltage (constant)
    Tmech : float
        Mechanical torque (constant)
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
    we = params['we']  # synchronous frequency
    H = params['H']
    Domega = params['Domega']
    Tfactor = params['Tfactor']

    # Normalized synchronous frequency
    we_wb = we / wb

    def model_equations(t, x):
        """
        State vector x = [psiqs, psiqr, psids, psidr, wr_wb]
        All quantities in synchronous reference frame
        """
        psiqs = x[0]
        psiqr = x[1]
        psids = x[2]
        psidr = x[3]
        wr_wb = x[4]

        # Magnetizing flux
        psiqm = xM * (psiqs/xls + psiqr/xplr)
        psidm = xM * (psids/xls + psidr/xplr)

        # Stator currents in synchronous frame
        iqse = (psiqs - psiqm) / xls
        idse = (psids - psidm) / xls

        # Rotor currents
        iqr = (psiqr - psiqm) / xplr
        idr = (psidr - psidm) / xplr

        # Slip speed term
        wr_we_wb = wr_wb - we_wb

        # Q-axis equations (synchronous frame)
        dpsiqs_dt = wb * (vqse - we_wb * psids + (rs/xls) * (psiqs - psiqm))
        dpsiqr_dt = wb * (wr_we_wb * psidr + (rpr/xplr) * (psiqr - psiqm))

        # D-axis equations (synchronous frame)
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
    t_eval = np.linspace(0, tstop, 2000)

    sol = solve_ivp(model_equations, t_span, y0, method='RK45',
                    t_eval=t_eval, rtol=1e-3, atol=1e-6,
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

        # Calculate currents
        iqse_arr = np.zeros_like(t)
        idse_arr = np.zeros_like(t)
        Tem_arr = np.zeros_like(t)

        for i in range(len(t)):
            psiqm = xM * (psiqs[i]/xls + psiqr[i]/xplr)
            psidm = xM * (psids[i]/xls + psidr[i]/xplr)
            iqse_arr[i] = (psiqs[i] - psiqm) / xls
            idse_arr[i] = (psids[i] - psidm) / xls
            Tem_arr[i] = Tfactor * (psids[i] * iqse_arr[i] - psiqs[i] * idse_arr[i])

        # Plot results
        fig, axs = plt.subplots(4, 1, figsize=(10, 10))

        axs[0].plot(t, iqse_arr, label='iqse')
        axs[0].plot(t, idse_arr, label='idse')
        axs[0].set_ylabel('Current (A)')
        axs[0].set_title('Synchronous Frame Stator Currents')
        axs[0].legend()
        axs[0].grid(True)

        axs[1].plot(t, psiqs, label='psiqs')
        axs[1].plot(t, psids, label='psids')
        axs[1].set_ylabel('Flux (Wb)')
        axs[1].set_title('Synchronous Frame Stator Flux Linkages')
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


def compute_eigenvalues(params, vqse, vdse, Tmech, operating_point=None):
    """
    Compute eigenvalues of the linearized system at an operating point.

    Parameters:
    -----------
    params : dict
        Machine parameters
    vqse, vdse : float
        Synchronous frame voltages
    Tmech : float
        Mechanical torque
    operating_point : array-like, optional
        Operating point [psiqs, psiqr, psids, psidr, wr_wb]
        If None, compute steady-state numerically

    Returns:
    --------
    eigenvalues : array
        System eigenvalues
    """
    print("\n=== Eigenvalue Analysis ===")
    print("Computing linearized system eigenvalues...")

    # For simplicity, run to steady state if no operating point given
    if operating_point is None:
        print("Computing steady-state operating point...")
        sol = simulate_synchronous_frame(params, vqse, vdse, Tmech,
                                        tstop=5.0, plot=False)
        operating_point = sol.y[:, -1]
        print(f"Steady-state point: psiqs={operating_point[0]:.4f}, "
              f"psids={operating_point[2]:.4f}, wr/wb={operating_point[4]:.4f}")

    # Numerical Jacobian computation
    def model_func(x):
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
        we_wb = we / wb

        psiqs, psiqr, psids, psidr, wr_wb = x

        psiqm = xM * (psiqs/xls + psiqr/xplr)
        psidm = xM * (psids/xls + psidr/xplr)
        iqse = (psiqs - psiqm) / xls
        idse = (psids - psidm) / xls
        wr_we_wb = wr_wb - we_wb

        dpsiqs_dt = wb * (vqse - we_wb * psids + (rs/xls) * (psiqs - psiqm))
        dpsiqr_dt = wb * (wr_we_wb * psidr + (rpr/xplr) * (psiqr - psiqm))
        dpsids_dt = wb * (vdse + we_wb * psiqs + (rs/xls) * (psids - psidm))
        dpsidr_dt = wb * (-wr_we_wb * psiqr + (rpr/xplr) * (psidr - psidm))
        Tem = Tfactor * (psids * iqse - psiqs * idse)
        dwr_dt = (1/(2*H)) * (Tem - Tmech - Domega * wr_wb)

        return np.array([dpsiqs_dt, dpsiqr_dt, dpsids_dt, dpsidr_dt, dwr_dt])

    # Compute Jacobian numerically
    n = len(operating_point)
    J = np.zeros((n, n))
    eps = 1e-7
    f0 = model_func(operating_point)

    for i in range(n):
        x_pert = operating_point.copy()
        x_pert[i] += eps
        f_pert = model_func(x_pert)
        J[:, i] = (f_pert - f0) / eps

    # Compute eigenvalues
    eigenvalues, eigenvectors = eig(J)

    print("\nEigenvalues:")
    for i, lam in enumerate(eigenvalues):
        print(f"  λ{i+1} = {lam.real:+.4e} {lam.imag:+.4e}j")

    return eigenvalues, J


if __name__ == "__main__":
    # Load parameters from p20hp
    from p20hp import *

    # Initial conditions (typical steady-state near synchronous speed)
    Psiqso = 0.0
    Psipqro = 0.0
    Psidso = 0.0
    Psipdro = 0.0
    wrbywbo = 0.98  # Start near synchronous speed

    # Synchronous frame voltages (rated voltage)
    vqse = Vm  # Q-axis voltage
    vdse = 0.0  # D-axis voltage (aligned with voltage)

    # Mechanical torque (rated)
    Tmech_val = -Tb

    # Package parameters
    params = {
        'rs': rs, 'rpr': rpr,
        'xls': xls, 'xplr': xplr, 'xM': xM,
        'wb': wb, 'we': we, 'H': H, 'Domega': Domega,
        'Tfactor': Tfactor,
        'Psiqso': Psiqso, 'Psipqro': Psipqro,
        'Psidso': Psidso, 'Psipdro': Psipdro, 'wrbywbo': wrbywbo
    }

    # Run simulation
    print("Running S4EIG - Induction Machine in Synchronous Reference Frame")
    print(f"Synchronous frequency: we = {we:.2f} rad/s")
    print(f"Applied voltages: vqse = {vqse:.2f} V, vdse = {vdse:.2f} V")
    print(f"Mechanical torque: Tmech = {Tmech_val:.2f} Nm")

    sol = simulate_synchronous_frame(params, vqse, vdse, Tmech_val,
                                     tstop=1.0, plot=True)

    # Eigenvalue analysis
    eigenvalues, J = compute_eigenvalues(params, vqse, vdse, Tmech_val)
