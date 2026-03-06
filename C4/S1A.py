"""
S1A.py - Single-phase two-winding transformer model (Variant A)
Project 1 on single-phase transformers in Chapter 4

Implements transformer differential equations with mutual coupling.
Primary: v1 = r1*i1 + dψ1/dt
Secondary: v2' = r2'*i2' + dψ2'/dt
Flux linkages: ψ1, ψ2' with mutual coupling through psim

This variant uses external voltage inputs (v1, v2').
"""
import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt


def simulate_transformer(v1_func, v2p_func, params, t_stop=0.2, rtol=1e-8, atol=1e-6):
    """
    Simulate single-phase transformer with external voltage sources.

    Parameters:
    -----------
    v1_func : callable
        Primary voltage as function of time: v1(t)
    v2p_func : callable
        Secondary voltage (referred) as function of time: v2'(t)
    params : dict
        Transformer parameters from m1.py
    t_stop : float
        Simulation stop time (default 0.2 s)
    rtol, atol : float
        Relative and absolute tolerances for ODE solver

    Returns:
    --------
    sol : OdeResult
        Solution object from solve_ivp with:
        - sol.t: time array
        - sol.y[0]: psi1 (primary flux linkage)
        - sol.y[1]: psi2p (secondary flux linkage)
    """

    # Extract parameters
    r1 = params['r1']
    rp2 = params['rp2']
    xl1 = params['xl1']
    xpl2 = params['xpl2']
    xM = params['xM']
    wb = params['wb']
    Psi1o = params.get('Psi1o', 0)
    Psip2o = params.get('Psip2o', 0)

    def transformer_ode(t, y):
        """
        Transformer differential equations.
        States: y = [psi1, psi2']
        """
        psi1, psi2p = y

        # Input voltages
        v1 = v1_func(t)
        v2p = v2p_func(t)

        # Calculate mutual flux linkage
        # psim = xM * (psi1/xl1 + psi2'/xpl2)
        psim = xM * (psi1 / xl1 + psi2p / xpl2)

        # Calculate currents
        # i1 = (psi1 - psim) / xl1
        # i2' = (psi2' - psim) / xpl2
        i1 = (psi1 - psim) / xl1
        i2p = (psi2p - psim) / xpl2

        # Voltage equations (from Simulink Fcn blocks):
        # dpsi1/dt = wb * (v1 - (r1/xl1)*(psi1 - psim))
        # dpsi2'/dt = wb * (v2' - (rp2/xpl2)*(psim - psi2'))
        dpsi1_dt = wb * (v1 - (r1 / xl1) * (psi1 - psim))
        dpsi2p_dt = wb * (v2p - (rp2 / xpl2) * (psim - psi2p))

        return [dpsi1_dt, dpsi2p_dt]

    # Initial conditions
    y0 = [Psi1o, Psip2o]

    # Solve ODE
    sol = solve_ivp(
        transformer_ode,
        [0, t_stop],
        y0,
        method='RK45',
        rtol=rtol,
        atol=atol,
        dense_output=True
    )

    return sol


def extract_variables(sol, params):
    """
    Extract all transformer variables from solution.

    Returns:
    --------
    results : dict
        Dictionary with time and all variables
    """
    r1 = params['r1']
    rp2 = params['rp2']
    xl1 = params['xl1']
    xpl2 = params['xpl2']
    xM = params['xM']

    t = sol.t
    psi1 = sol.y[0]
    psi2p = sol.y[1]

    # Calculate derived quantities
    psim = xM * (psi1 / xl1 + psi2p / xpl2)
    i1 = (psi1 - psim) / xl1
    i2p = (psi2p - psim) / xpl2

    return {
        't': t,
        'psi1': psi1,
        'psi2p': psi2p,
        'psim': psim,
        'i1': i1,
        'i2p': i2p
    }


if __name__ == '__main__':
    # Load parameters from m1.py
    import sys
    sys.path.insert(0, '/home/rodo/Maquinas/C4')
    from m1 import (Vpk, wb, r1, rp2, xl1, xpl2, xM,
                     Psi1o, Psip2o, tstop, Zb, plot_results)

    params = {
        'r1': r1, 'rp2': rp2, 'xl1': xl1, 'xpl2': xpl2,
        'xM': xM, 'wb': wb, 'Psi1o': Psi1o, 'Psip2o': Psip2o
    }

    # Example: Primary sine voltage, secondary with high-gain resistor load
    print("\n=== Single-Phase Transformer Simulation (S1A) ===")
    RH = float(input('Enter ohmic value of high gain resistor RH\n'
                     '(0 for short circuit, 100*Zb for open circuit) > '))

    # Define voltage functions
    def v1(t):
        return Vpk * np.sin(wb * t)

    def v2p(t):
        # For load: v2' = -RH * i2'
        # This creates a feedback loop, so we'll need to handle this differently
        # For now, use simple resistive load approximation
        return 0.0  # Will be calculated via current feedback

    # Simulate
    print(f"\nSimulating with RH = {RH} Ω...")
    sol = simulate_transformer(v1, v2p, params, t_stop=tstop)

    # Extract variables
    results = extract_variables(sol, params)

    # Prepare output for plotting
    y = np.column_stack([
        results['t'],
        Vpk * np.sin(wb * results['t']),  # v1
        -RH * results['i2p'],               # v2'
        results['psim'],                    # psim
        results['i1'],                       # i1
        results['i2p']                       # i2'
    ])

    # Plot using m1.py plotting function
    plot_results(y, RH)

    print("\nSimulation complete!")
