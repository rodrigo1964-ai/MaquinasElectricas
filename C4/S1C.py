"""
S1C.py - Single-phase two-winding transformer with full saturation curve (Variant C)
Project 2 on single-phase transformers in Chapter 4

Complete implementation with:
- Internal sine voltage source
- Look-up table for saturation curve (psisat vs Dpsi from m1.py)
- Resistive load module
- Full nonlinear magnetic saturation

Primary: v1 = r1*i1 + dψ1/dt
Secondary: v2' = r2'*i2' + dψ2'/dt
Saturation: Dpsi = f(psim) from lookup table
"""
import numpy as np
from scipy.integrate import solve_ivp
from scipy.interpolate import interp1d
import matplotlib.pyplot as plt


def simulate_transformer_full_saturation(RH, params, t_stop=0.2, rtol=5e-5, atol=5e-5):
    """
    Simulate single-phase transformer with complete saturation curve.

    Parameters:
    -----------
    RH : float
        High-gain resistor load (Ohms)
        0 = short circuit, large value (~100*Zb) = open circuit
    params : dict
        Transformer parameters from m1.py including Dpsi and psisat arrays
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
    Vpk = params['Vpk']
    Psi1o = params.get('Psi1o', 0)
    Psip2o = params.get('Psip2o', 0)

    # Saturation curve
    psisat = params['psisat']
    Dpsi_array = params['Dpsi']

    # Create interpolation function for saturation
    # Look-up table: Input = psisat, Output = Dpsi
    sat_lookup = interp1d(psisat, Dpsi_array, kind='linear',
                          bounds_error=False, fill_value='extrapolate')

    # Memory for Dpsi (previous value)
    Dpsi_prev = [0.0]

    def transformer_ode(t, y):
        """
        Transformer differential equations with full saturation.
        States: y = [psi1, psi2']
        """
        psi1, psi2p = y

        # Primary voltage source (built-in sine wave)
        v1 = Vpk * np.sin(wb * t)

        # Calculate unsaturated mutual flux
        psim_unsaturated = xM * (psi1 / xl1 + psi2p / xpl2)

        # Look up Dpsi from saturation curve using Memory (previous value)
        # In Simulink: Memory delays the feedback by one time step
        Dpsi = sat_lookup(Dpsi_prev[0])

        # Corrected mutual flux with saturation
        psim = xM * (psi1 / xl1 + psi2p / xpl2 - Dpsi / xm)

        # Update memory for next step
        Dpsi_prev[0] = psim

        # Calculate currents
        i1 = (psi1 - psim) / xl1
        i2p = (psi2p - psim) / xpl2

        # Secondary voltage from load module: v2' = -RH * i2'
        v2p = -RH * i2p

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
        max_step=1e-3  # Match Simulink max step
    )

    return sol


def extract_variables(sol, RH, params):
    """Extract all transformer variables from solution."""
    r1 = params['r1']
    rp2 = params['rp2']
    xl1 = params['xl1']
    xpl2 = params['xpl2']
    xM = params['xM']
    xm = params['xm']
    wb = params['wb']
    Vpk = params['Vpk']

    psisat = params['psisat']
    Dpsi_array = params['Dpsi']
    sat_lookup = interp1d(psisat, Dpsi_array, kind='linear',
                          bounds_error=False, fill_value='extrapolate')

    t = sol.t
    psi1 = sol.y[0]
    psi2p = sol.y[1]

    # Recalculate with saturation
    psim = np.zeros_like(t)
    Dpsi_values = np.zeros_like(t)

    for i in range(len(t)):
        if i == 0:
            Dpsi = 0.0
        else:
            Dpsi = sat_lookup(psim[i-1])

        Dpsi_values[i] = Dpsi
        psim[i] = xM * (psi1[i] / xl1 + psi2p[i] / xpl2 - Dpsi / xm)

    i1 = (psi1 - psim) / xl1
    i2p = (psi2p - psim) / xpl2

    v1 = Vpk * np.sin(wb * t)
    v2p = -RH * i2p

    return {
        't': t,
        'v1': v1,
        'v2p': v2p,
        'psi1': psi1,
        'psi2p': psi2p,
        'psim': psim,
        'i1': i1,
        'i2p': i2p,
        'Dpsi': Dpsi_values
    }


if __name__ == '__main__':
    # Load parameters from m1.py
    import sys
    sys.path.insert(0, '/home/rodo/Maquinas/C4')
    from m1 import (Vpk, wb, r1, rp2, xl1, xpl2, xM, xm,
                     Psi1o, Psip2o, tstop, Zb, Dpsi, psisat, plot_results)

    params = {
        'r1': r1, 'rp2': rp2, 'xl1': xl1, 'xpl2': xpl2,
        'xM': xM, 'xm': xm, 'wb': wb, 'Vpk': Vpk,
        'Psi1o': Psi1o, 'Psip2o': Psip2o,
        'Dpsi': Dpsi, 'psisat': psisat
    }

    # Example simulation
    print("\n=== Single-Phase Transformer with Full Saturation Curve (S1C) ===")
    print(f"Base impedance Zb = {Zb:.2f} Ω")
    RH = float(input('Enter ohmic value of high gain resistor RH\n'
                     '(0 for short circuit, ~{:.0f} for open circuit) > '.format(100*Zb)))

    # Simulate
    print(f"\nSimulating with full saturation curve, RH = {RH} Ω...")
    sol = simulate_transformer_full_saturation(RH, params, t_stop=tstop)

    # Extract variables
    results = extract_variables(sol, RH, params)

    # Prepare output for plotting (format expected by m1.plot_results)
    y = np.column_stack([
        results['t'],
        results['v1'],
        results['v2p'],
        results['psim'],
        results['i1'],
        results['i2p']
    ])

    # Plot using m1.py plotting function
    plot_results(y, RH)

    # Additional saturation analysis
    print(f"\nSimulation Statistics:")
    print(f"  Max psim: {np.max(np.abs(results['psim'])):.2f} Wb-turns")
    print(f"  Max i1: {np.max(np.abs(results['i1'])):.3f} A")
    print(f"  Max i2': {np.max(np.abs(results['i2p'])):.3f} A")
    print(f"  Max Dpsi: {np.max(np.abs(results['Dpsi'])):.2f}")

    print("\nSimulation complete!")
