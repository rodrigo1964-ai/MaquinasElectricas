#!/usr/bin/env python3
"""
test_transformers.py - Test all C4 transformer models

Runs examples for all five transformer simulation models:
- S1A: Basic single-phase transformer (linear)
- S1B: Single-phase with piecewise linear saturation
- S1C: Single-phase with full saturation curve
- S4: Three-phase transformer bank (delta-wye)
- SMG: Magnetization curve validation

Usage:
    python3 test_transformers.py
    python3 test_transformers.py --model S1A
    python3 test_transformers.py --model all
"""
import sys
import argparse
import numpy as np

# Add C4 directory to path
sys.path.insert(0, '/home/rodo/Maquinas/C4')


def test_S1A():
    """Test S1A - Basic single-phase transformer."""
    print("\n" + "="*60)
    print("Testing S1A - Single-Phase Transformer (Linear)")
    print("="*60)

    from m1 import (Vpk, wb, r1, rp2, xl1, xpl2, xM,
                     Psi1o, Psip2o, tstop, Zb, plot_results)
    from S1A import simulate_transformer, extract_variables

    params = {
        'r1': r1, 'rp2': rp2, 'xl1': xl1, 'xpl2': xpl2,
        'xM': xM, 'wb': wb, 'Psi1o': Psi1o, 'Psip2o': Psip2o
    }

    # Test with open circuit condition
    RH = 100 * Zb
    print(f"\nTesting with RH = {RH:.2f} Ω (open circuit)")

    def v1(t):
        return Vpk * np.sin(wb * t)

    def v2p(t):
        return 0.0

    sol = simulate_transformer(v1, v2p, params, t_stop=tstop)
    results = extract_variables(sol, params)

    y = np.column_stack([
        results['t'],
        Vpk * np.sin(wb * results['t']),
        -RH * results['i2p'],
        results['psim'],
        results['i1'],
        results['i2p']
    ])

    print(f"✓ Simulation complete: {len(results['t'])} time points")
    print(f"  Max i1: {np.max(np.abs(results['i1'])):.4f} A")
    print(f"  Max psim: {np.max(np.abs(results['psim'])):.3f} Wb-turns")

    return True


def test_S1B():
    """Test S1B - Single-phase with piecewise saturation."""
    print("\n" + "="*60)
    print("Testing S1B - Single-Phase with Piecewise Saturation")
    print("="*60)

    from m1 import (Vpk, wb, r1, rp2, xl1, xpl2, xM, xm,
                     Psi1o, Psip2o, tstop, Zb)
    from S1B import simulate_transformer_saturated, extract_variables

    params = {
        'r1': r1, 'rp2': rp2, 'xl1': xl1, 'xpl2': xpl2,
        'xM': xM, 'xm': xm, 'wb': wb, 'Psi1o': Psi1o, 'Psip2o': Psip2o
    }

    # Test with short circuit
    RH = 0.0
    print(f"\nTesting with RH = {RH} Ω (short circuit)")

    def v1(t):
        return Vpk * np.sin(wb * t)

    def v2p(t):
        return 0.0

    sol = simulate_transformer_saturated(v1, v2p, params, t_stop=tstop)
    results = extract_variables(sol, params)

    print(f"✓ Simulation complete: {len(results['t'])} time points")
    print(f"  Max i1: {np.max(np.abs(results['i1'])):.4f} A")
    print(f"  Max psim: {np.max(np.abs(results['psim'])):.3f} Wb-turns")

    return True


def test_S1C():
    """Test S1C - Single-phase with full saturation curve."""
    print("\n" + "="*60)
    print("Testing S1C - Single-Phase with Full Saturation Curve")
    print("="*60)

    from m1 import (Vpk, wb, r1, rp2, xl1, xpl2, xM, xm,
                     Psi1o, Psip2o, tstop, Zb, Dpsi, psisat)
    from S1C import simulate_transformer_full_saturation, extract_variables

    params = {
        'r1': r1, 'rp2': rp2, 'xl1': xl1, 'xpl2': xpl2,
        'xM': xM, 'xm': xm, 'wb': wb, 'Vpk': Vpk,
        'Psi1o': Psi1o, 'Psip2o': Psip2o,
        'Dpsi': Dpsi, 'psisat': psisat
    }

    # Test with moderate load
    RH = 10 * Zb
    print(f"\nTesting with RH = {RH:.2f} Ω (moderate load)")

    sol = simulate_transformer_full_saturation(RH, params, t_stop=tstop)
    results = extract_variables(sol, RH, params)

    print(f"✓ Simulation complete: {len(results['t'])} time points")
    print(f"  Max i1: {np.max(np.abs(results['i1'])):.4f} A")
    print(f"  Max psim: {np.max(np.abs(results['psim'])):.3f} Wb-turns")
    print(f"  Max Dpsi: {np.max(np.abs(results['Dpsi'])):.2f}")

    return True


def test_S4():
    """Test S4 - Three-phase transformer bank."""
    print("\n" + "="*60)
    print("Testing S4 - Three-Phase Transformer Bank")
    print("="*60)

    from m4 import (r1, rp2, xl1, xpl2, xM, xm, wb, NpbyNs,
                     Psi1o, Psip2o, tstop, Rload, Dpsi, psisat)
    from S4 import simulate_three_phase_transformer, extract_variables

    Vpk_ph = 169.7 / np.sqrt(3)

    params = {
        'r1': r1, 'rp2': rp2, 'xl1': xl1, 'xpl2': xpl2,
        'xM': xM, 'xm': xm, 'wb': wb, 'Vpk_ph': Vpk_ph,
        'NpbyNs': NpbyNs, 'Psi1o': Psi1o, 'Psip2o': Psip2o,
        'Dpsi': Dpsi, 'psisat': psisat
    }

    # Test with grounded neutral
    Rn = 0.01
    print(f"\nTesting with Rn = {Rn} Ω (grounded neutral)")
    print(f"Load resistance Rload = {Rload:.2f} Ω per phase")

    # Shorter simulation for speed
    t_stop_test = 0.3
    sol = simulate_three_phase_transformer(Rn, Rload, params, t_stop=t_stop_test)
    results = extract_variables(sol, Rn, Rload, params)

    print(f"✓ Simulation complete: {len(results['t'])} time points")
    print(f"  Max vAB: {np.max(np.abs(results['vAB'])):.2f} V")
    print(f"  Max iA: {np.max(np.abs(results['iA'])):.4f} A")
    print(f"  Max vnG: {np.max(np.abs(results['vnG'])):.4f} V")

    return True


def test_SMG():
    """Test SMG - Magnetization curve validation."""
    print("\n" + "="*60)
    print("Testing SMG - Magnetization Curve Validation")
    print("="*60)

    from mginit import (V, I, psifull, ifull, Vmaxrms, tstop)
    from SMG import simulate_magnetization_validation

    params = {
        'V': V,
        'I': I,
        'psifull': psifull,
        'ifull': ifull,
        'Vmaxrms': Vmaxrms,
        'we': 377
    }

    print(f"\nTesting magnetization validation")
    print(f"  Vmaxrms = {Vmaxrms:.2f} V")

    # Shorter test for speed
    t_stop_test = 1.0
    results = simulate_magnetization_validation(params, t_stop=t_stop_test)

    max_error_rms = np.max(np.abs(results['error_rms'])) * 1000
    max_error_inst = np.max(np.abs(results['error_inst']))

    print(f"✓ Simulation complete: {len(results['t'])} time points")
    print(f"  Max error from RMS curve: {max_error_rms:.3f} mA")
    print(f"  Max error from instantaneous curve: {max_error_inst:.4f} Wb-turns")

    return True


def main():
    """Main test function."""
    parser = argparse.ArgumentParser(description='Test C4 transformer models')
    parser.add_argument('--model', type=str, default='all',
                        choices=['all', 'S1A', 'S1B', 'S1C', 'S4', 'SMG'],
                        help='Model to test (default: all)')
    parser.add_argument('--no-plot', action='store_true',
                        help='Disable plotting (for automated testing)')

    args = parser.parse_args()

    # Disable plotting in test mode
    if args.no_plot:
        import matplotlib
        matplotlib.use('Agg')

    print("\n" + "="*60)
    print("C4 TRANSFORMER MODELS TEST SUITE")
    print("="*60)

    tests = {
        'S1A': test_S1A,
        'S1B': test_S1B,
        'S1C': test_S1C,
        'S4': test_S4,
        'SMG': test_SMG
    }

    if args.model == 'all':
        models_to_test = tests.keys()
    else:
        models_to_test = [args.model]

    results = {}
    for model in models_to_test:
        try:
            results[model] = tests[model]()
        except Exception as e:
            print(f"\n✗ Error testing {model}: {e}")
            import traceback
            traceback.print_exc()
            results[model] = False

    # Summary
    print("\n" + "="*60)
    print("TEST SUMMARY")
    print("="*60)

    passed = sum(1 for v in results.values() if v)
    total = len(results)

    for model, status in results.items():
        status_str = "✓ PASS" if status else "✗ FAIL"
        print(f"  {model}: {status_str}")

    print(f"\nTotal: {passed}/{total} tests passed")

    if passed == total:
        print("\n✓ All tests passed!")
        return 0
    else:
        print(f"\n✗ {total - passed} test(s) failed")
        return 1


if __name__ == '__main__':
    sys.exit(main())
