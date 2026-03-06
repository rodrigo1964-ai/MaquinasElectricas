"""
S4.py - Three-phase transformer bank (Variant S4)
Project 4 on three-phase transformers in Chapter 4

Implements three independent single-phase transformer units:
- ABan_unit: Phase A-B to a-n transformer
- BCbn_unit: Phase B-C to b-n transformer
- CAcn_unit: Phase C-A to c-n transformer

Delta-wye connection with neutral voltage calculation.
Each phase includes full saturation curve.

Primary (delta): vAB, vBC, vCA
Secondary (wye): van, vbn, vcn with neutral point n
Neutral voltage: vnG calculated from current balance
"""
import numpy as np
from scipy.integrate import solve_ivp
from scipy.interpolate import interp1d
import matplotlib.pyplot as plt


class TransformerPhaseUnit:
    """Single transformer unit with saturation."""

    def __init__(self, params):
        self.r1 = params['r1']
        self.rp2 = params['rp2']
        self.xl1 = params['xl1']
        self.xpl2 = params['xpl2']
        self.xM = params['xM']
        self.xm = params['xm']
        self.wb = params['wb']

        # Saturation curve
        psisat = params['psisat']
        Dpsi_array = params['Dpsi']
        self.sat_lookup = interp1d(psisat, Dpsi_array, kind='linear',
                                   bounds_error=False, fill_value='extrapolate')

        # Memory for saturation
        self.Dpsi_prev = 0.0

    def equations(self, psi1, psi2p, v1, v2p):
        """
        Calculate derivatives for one transformer unit.

        Parameters:
        -----------
        psi1, psi2p : float
            Primary and secondary flux linkages
        v1, v2p : float
            Primary and secondary voltages

        Returns:
        --------
        dpsi1_dt, dpsi2p_dt : float
            Time derivatives of flux linkages
        psim : float
            Mutual flux linkage
        i1, i2p : float
            Primary and secondary currents
        """
        # Look up Dpsi from previous psim value (Memory block)
        Dpsi = self.sat_lookup(self.Dpsi_prev)

        # Mutual flux with saturation
        psim = self.xM * (psi1 / self.xl1 + psi2p / self.xpl2 - Dpsi / self.xm)

        # Update memory
        self.Dpsi_prev = psim

        # Currents
        i1 = (psi1 - psim) / self.xl1
        i2p = (psi2p - psim) / self.xpl2

        # Flux derivatives
        dpsi1_dt = self.wb * (v1 - (self.r1 / self.xl1) * (psi1 - psim))
        dpsi2p_dt = self.wb * (v2p - (self.rp2 / self.xpl2) * (psim - psi2p))

        return dpsi1_dt, dpsi2p_dt, psim, i1, i2p


def simulate_three_phase_transformer(Rn, Rload, params, t_stop=1.2, rtol=1e-5, atol=1e-5):
    """
    Simulate three-phase transformer bank.

    Parameters:
    -----------
    Rn : float
        Neutral to ground resistance (Ohms)
    Rload : float
        Load resistance per phase (referred to primary, Ohms)
    params : dict
        Transformer parameters from m4.py
    t_stop : float
        Simulation stop time
    rtol, atol : float
        ODE solver tolerances

    Returns:
    --------
    sol : OdeResult
        Solution with states [psi1_AB, psi2p_an, psi1_BC, psi2p_bn, psi1_CA, psi2p_cn]
    """

    # Create three transformer units
    unit_AB = TransformerPhaseUnit(params)
    unit_BC = TransformerPhaseUnit(params)
    unit_CA = TransformerPhaseUnit(params)

    wb = params['wb']
    Vpk_ph = params['Vpk_ph']  # Phase-to-neutral peak voltage
    NpbyNs = params['NpbyNs']
    Psi1o = params.get('Psi1o', 0)
    Psip2o = params.get('Psip2o', 0)

    def three_phase_ode(t, y):
        """
        Three-phase transformer ODE.
        States: [psi1_AB, psi2p_an, psi1_BC, psi2p_bn, psi1_CA, psi2p_cn]
        """
        psi1_AB, psi2p_an, psi1_BC, psi2p_bn, psi1_CA, psi2p_cn = y

        # Primary voltages (phase-to-neutral, delta connection gives line voltages)
        vAO = Vpk_ph * np.sin(wb * t)
        vBO = Vpk_ph * np.sin(wb * t - 2*np.pi/3)
        vCO = Vpk_ph * np.sin(wb * t - 4*np.pi/3)

        # Primary line-to-line voltages (delta)
        vAB = vAO - vBO
        vBC = vBO - vCO
        vCA = vCO - vAO

        # Calculate currents for each phase (need for neutral voltage)
        _, _, _, _, i2p_an = unit_AB.equations(psi1_AB, psi2p_an, 0, 0)
        _, _, _, _, i2p_bn = unit_BC.equations(psi1_BC, psi2p_bn, 0, 0)
        _, _, _, _, i2p_cn = unit_CA.equations(psi1_CA, psi2p_cn, 0, 0)

        # Neutral voltage calculation
        # From current balance: (van/Rload + vbn/Rload + vcn/Rload) + vnG/Rn = ia' + ib' + ic'
        # van = v2p_an + vnG, etc.
        # Solving for vnG:
        Rn_eff = Rn * (NpbyNs**2)  # Referred to primary
        numerator = Rn_eff * (i2p_an + i2p_bn + i2p_cn)
        denominator = 1 + 3 * Rn_eff / Rload
        vnG = numerator / denominator

        # Secondary voltages (wye with neutral)
        # From load: v2p = -Rload * i2p + vnG
        v2p_an = -Rload * i2p_an + vnG
        v2p_bn = -Rload * i2p_bn + vnG
        v2p_cn = -Rload * i2p_cn + vnG

        # Calculate derivatives for each phase
        dpsi1_AB, dpsi2p_an, _, _, _ = unit_AB.equations(psi1_AB, psi2p_an, vAB, v2p_an)
        dpsi1_BC, dpsi2p_bn, _, _, _ = unit_BC.equations(psi1_BC, psi2p_bn, vBC, v2p_bn)
        dpsi1_CA, dpsi2p_cn, _, _, _ = unit_CA.equations(psi1_CA, psi2p_cn, vCA, v2p_cn)

        return [dpsi1_AB, dpsi2p_an, dpsi1_BC, dpsi2p_bn, dpsi1_CA, dpsi2p_cn]

    # Initial conditions (6 states)
    y0 = [Psi1o, Psip2o, Psi1o, Psip2o, Psi1o, Psip2o]

    # Solve ODE
    sol = solve_ivp(
        three_phase_ode,
        [0, t_stop],
        y0,
        method='RK45',
        rtol=rtol,
        atol=atol,
        dense_output=True,
        max_step=1e-2
    )

    return sol


def extract_variables(sol, Rn, Rload, params):
    """Extract all three-phase variables."""
    wb = params['wb']
    Vpk_ph = params['Vpk_ph']
    NpbyNs = params['NpbyNs']

    # Recreate units for variable extraction
    unit_AB = TransformerPhaseUnit(params)
    unit_BC = TransformerPhaseUnit(params)
    unit_CA = TransformerPhaseUnit(params)

    t = sol.t
    n = len(t)

    # Allocate arrays
    vAB, vBC, vCA = np.zeros(n), np.zeros(n), np.zeros(n)
    vab, vbc, vca = np.zeros(n), np.zeros(n), np.zeros(n)
    iA, iB, iC = np.zeros(n), np.zeros(n), np.zeros(n)
    ia, ib, ic = np.zeros(n), np.zeros(n), np.zeros(n)
    vnG = np.zeros(n)

    for i in range(n):
        psi1_AB, psi2p_an, psi1_BC, psi2p_bn, psi1_CA, psi2p_cn = sol.y[:, i]

        # Primary voltages
        vAO = Vpk_ph * np.sin(wb * t[i])
        vBO = Vpk_ph * np.sin(wb * t[i] - 2*np.pi/3)
        vCO = Vpk_ph * np.sin(wb * t[i] - 4*np.pi/3)

        vAB[i] = vAO - vBO
        vBC[i] = vBO - vCO
        vCA[i] = vCO - vAO

        # Get currents
        _, _, _, iAB, i2p_an = unit_AB.equations(psi1_AB, psi2p_an, 0, 0)
        _, _, _, iBC, i2p_bn = unit_BC.equations(psi1_BC, psi2p_bn, 0, 0)
        _, _, _, iCA, i2p_cn = unit_CA.equations(psi1_CA, psi2p_cn, 0, 0)

        # Primary line currents (delta connection)
        iA[i] = iAB - iCA
        iB[i] = iBC - iAB
        iC[i] = iCA - iBC

        # Neutral voltage
        Rn_eff = Rn * (NpbyNs**2)
        numerator = Rn_eff * (i2p_an + i2p_bn + i2p_cn)
        denominator = 1 + 3 * Rn_eff / Rload
        vnG[i] = numerator / denominator

        # Secondary currents (actual, not referred)
        ia[i] = i2p_an / NpbyNs
        ib[i] = i2p_bn / NpbyNs
        ic[i] = i2p_cn / NpbyNs

        # Secondary line voltages
        van = -Rload * i2p_an + vnG[i]
        vbn = -Rload * i2p_bn + vnG[i]
        vcn = -Rload * i2p_cn + vnG[i]

        vab[i] = (van - vbn) / NpbyNs
        vbc[i] = (vbn - vcn) / NpbyNs
        vca[i] = (vcn - van) / NpbyNs

    return {
        't': t,
        'vAB': vAB, 'vBC': vBC, 'vCA': vCA,
        'vab': vab, 'vbc': vbc, 'vca': vca,
        'iA': iA, 'iB': iB, 'iC': iC,
        'ia': ia, 'ib': ib, 'ic': ic,
        'vnG': vnG
    }


if __name__ == '__main__':
    # Load parameters from m4.py
    import sys
    sys.path.insert(0, '/home/rodo/Maquinas/C4')
    from m4 import (r1, rp2, xl1, xpl2, xM, xm, wb, Vpk, NpbyNs,
                     Psi1o, Psip2o, tstop, Rload, Dpsi, psisat, plot_results)

    # Phase-to-neutral voltage (for wye-equivalent)
    Vpk_ph = 169.7 / np.sqrt(3)

    params = {
        'r1': r1, 'rp2': rp2, 'xl1': xl1, 'xpl2': xpl2,
        'xM': xM, 'xm': xm, 'wb': wb, 'Vpk_ph': Vpk_ph,
        'NpbyNs': NpbyNs, 'Psi1o': Psi1o, 'Psip2o': Psip2o,
        'Dpsi': Dpsi, 'psisat': psisat
    }

    # Example simulation
    print("\n=== Three-Phase Transformer Bank Simulation (S4) ===")
    print(f"Load resistance Rload = {Rload:.2f} Ω (referred to primary)")
    Rn = float(input('Enter ohmic value of neutral to ground resistor Rn > '))

    # Simulate
    print(f"\nSimulating three-phase bank with Rn = {Rn} Ω...")
    sol = simulate_three_phase_transformer(Rn, Rload, params, t_stop=tstop)

    # Extract variables
    results = extract_variables(sol, Rn, Rload, params)

    # Prepare output for plotting (format for m4.plot_results)
    y = np.column_stack([
        results['t'],
        results['vAB'],
        results['vab'],
        results['iA'],
        results['ia'],
        (results['iA'] + results['iB'] + results['iC']) / 3,  # Average primary
        (results['ia'] + results['ib'] + results['ic']) / 3,  # Average secondary
        results['vnG']
    ])

    # Plot
    plot_results(y, Rn)

    print(f"\nSimulation Statistics:")
    print(f"  Max vAB: {np.max(np.abs(results['vAB'])):.2f} V")
    print(f"  Max iA: {np.max(np.abs(results['iA'])):.3f} A")
    print(f"  Max vnG: {np.max(np.abs(results['vnG'])):.3f} V")

    print("\nSimulation complete!")
