"""
S1B.py - Single-phase two-winding transformer with saturation (Variant B)
Project 2 on single-phase transformers in Chapter 4

Implements transformer with nonlinear saturation using piecewise linear approximation.
Uses Dead Zone block and slope to model core saturation.

Primary: v1 = r1*i1 + dψ1/dt
Secondary: v2' = r2'*i2' + dψ2'/dt
Saturation: Dpsi as function of psim using dead zone and slope
"""
import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt


def simulate_transformer_saturated(v1_func, v2p_func, params, t_stop=0.2, rtol=1e-5, atol=1e-5):
    """
    Simulate single-phase transformer with piecewise linear saturation model.

    Parameters:
    -----------
    v1_func : callable
        Primary voltage as function of time: v1(t)
    v2p_func : callable
        Secondary voltage (referred) as function of time: v2'(t)
    params : dict
        Transformer parameters from m1.py including saturation parameters
    t_stop : float
        Simulation stop time
    rtol, atol : float
        Relative and absolute tolerances

    Returns:
    --------
    sol : OdeResult
        Solution with states [psi1, psi2']
    """

    # Extract parameters
    r1 = params['r1']
    rp2 = params['rp2']
    xl1 = params['xl1']
    xpl2 = params['xpl2']
    xM = params['xM']
    xm = params['xm']
    wb = params['wb']
    Psi1o = params.get('Psi1o', 0)
    Psip2o = params.get('Psip2o', 0)

    # Saturation parameters (from S1B.M)
    # Dead Zone: -154 to +154
    # Slope: 150 * 3.9502e-5 = 0.00592530
    dead_zone_lower = -154
    dead_zone_upper = 154
    slope = 150 * 3.9502e-5

    # Memory for Dpsi (previous value)
    Dpsi_prev = [0.0]

    def dead_zone(x, lower, upper):
        """Apply dead zone nonlinearity."""
        if x < lower:
            return x - lower
        elif x > upper:
            return x - upper
        else:
            return 0.0

    def transformer_ode(t, y):
        """
        Transformer differential equations with saturation.
        States: y = [psi1, psi2']
        """
        psi1, psi2p = y

        # Input voltages
        v1 = v1_func(t)
        v2p = v2p_func(t)

        # Calculate initial mutual flux (unsaturated)
        psim_unsaturated = xM * (psi1 / xl1 + psi2p / xpl2)

        # Apply saturation model (from Simulink)
        # Dead zone output
        dz_out = dead_zone(psim_unsaturated, dead_zone_lower, dead_zone_upper)

        # Dpsi = slope * dead_zone_output
        Dpsi = slope * dz_out

        # Update memory (for next step)
        Dpsi_prev[0] = Dpsi

        # Corrected mutual flux with saturation
        # psim = xM * (psi1/xl1 + psi2'/xpl2 - Dpsi/xm)
        psim = xM * (psi1 / xl1 + psi2p / xpl2 - Dpsi / xm)

        # Calculate currents
        i1 = (psi1 - psim) / xl1
        i2p = (psi2p - psim) / xpl2

        # Voltage equations
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
        dense_output=True,
        max_step=0.01  # Ensure good resolution for saturation
    )

    return sol


def extract_variables(sol, params):
    """Extract all transformer variables from solution."""
    r1 = params['r1']
    rp2 = params['rp2']
    xl1 = params['xl1']
    xpl2 = params['xpl2']
    xM = params['xM']
    xm = params['xm']

    dead_zone_lower = -154
    dead_zone_upper = 154
    slope = 150 * 3.9502e-5

    t = sol.t
    psi1 = sol.y[0]
    psi2p = sol.y[1]

    # Recalculate with saturation
    def dead_zone(x, lower, upper):
        if x < lower:
            return x - lower
        elif x > upper:
            return x - upper
        else:
            return 0.0

    psim = np.zeros_like(t)
    for i in range(len(t)):
        psim_unsaturated = xM * (psi1[i] / xl1 + psi2p[i] / xpl2)
        dz_out = dead_zone(psim_unsaturated, dead_zone_lower, dead_zone_upper)
        Dpsi = slope * dz_out
        psim[i] = xM * (psi1[i] / xl1 + psi2p[i] / xpl2 - Dpsi / xm)

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
    from m1 import (Vpk, wb, r1, rp2, xl1, xpl2, xM, xm,
                     Psi1o, Psip2o, tstop, Zb, plot_results)

    params = {
        'r1': r1, 'rp2': rp2, 'xl1': xl1, 'xpl2': xpl2,
        'xM': xM, 'xm': xm, 'wb': wb, 'Psi1o': Psi1o, 'Psip2o': Psip2o
    }

    # Example simulation
    print("\n=== Single-Phase Transformer with Saturation (S1B) ===")
    RH = float(input('Enter ohmic value of high gain resistor RH\n'
                     '(0 for short circuit, 100*Zb for open circuit) > '))

    # Define voltage functions
    def v1(t):
        return Vpk * np.sin(wb * t)

    def v2p(t):
        return 0.0

    # Simulate
    print(f"\nSimulating with saturation, RH = {RH} Ω...")
    sol = simulate_transformer_saturated(v1, v2p, params, t_stop=tstop)

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

    # Plot
    plot_results(y, RH)
    print("\nSimulation complete!")
