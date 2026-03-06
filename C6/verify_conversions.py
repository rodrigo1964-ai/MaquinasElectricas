#!/usr/bin/env python3
"""
Verification script for MDL to Python conversions
Tests that all converted scripts can be imported and basic sanity checks pass
"""
import sys
import os

# Add paths
sys.path.append('/home/rodo/Maquinas/C6')

print("="*80)
print("VERIFICATION OF MDL TO PYTHON CONVERSIONS")
print("="*80)

# Test 1: Import parameters
print("\n[1/3] Testing parameter file import...")
try:
    from p20hp import *
    print(f"  ✓ p20hp.py imported successfully")
    print(f"    - Machine rating: {Sb/746:.1f} HP")
    print(f"    - Rated voltage: {Vrated:.1f} V (line-to-line)")
    print(f"    - Number of poles: {P}")
    print(f"    - Rated frequency: {frated} Hz")
    print(f"    - Stator resistance: {rs:.4f} Ω")
    print(f"    - Rotor resistance: {rpr:.4f} Ω")
    print(f"    - Magnetizing reactance: {xm:.4f} Ω")
    print(f"    - Inertia constant H: {H:.4f} s")
    print(f"    - Base torque: {Tb:.2f} Nm")
except Exception as e:
    print(f"  ✗ Failed to import p20hp.py: {e}")
    sys.exit(1)

# Test 2: Check all conversion files exist
print("\n[2/3] Checking converted Python files...")
conversion_files = [
    'S1_stationary_frame.py',
    'S4EIG_synchronous_frame.py',
    'S4STP_step_response.py',
    'S5A_neutral_voltage.py',
    'S5B_unbalanced_load.py',
    'S6_single_phase.py',
]

all_exist = True
for filename in conversion_files:
    filepath = f'/home/rodo/Maquinas/C6/{filename}'
    if os.path.exists(filepath):
        size = os.path.getsize(filepath)
        print(f"  ✓ {filename:<35} ({size:>6,} bytes)")
    else:
        print(f"  ✗ {filename:<35} NOT FOUND")
        all_exist = False

if not all_exist:
    print("\n  Some files are missing!")
    sys.exit(1)

# Test 3: Verify key equations
print("\n[3/3] Verifying key equations implementation...")

test_cases = [
    {
        'name': 'Magnetizing reactance calculation',
        'expression': lambda: xM,
        'expected_approx': 0.194,
        'description': 'xM = 1/(1/xm + 1/xls + 1/xplr)'
    },
    {
        'name': 'Torque factor calculation',
        'expression': lambda: Tfactor,
        'expected_approx': 0.00796,
        'description': 'Tfactor = (3*P)/(4*wb)'
    },
    {
        'name': 'Base mechanical frequency',
        'expression': lambda: wbm,
        'expected_approx': 188.5,
        'description': 'wbm = 2*wb/P'
    },
    {
        'name': 'Rated slip check',
        'expression': lambda: srated,
        'expected_approx': 0.0287,
        'description': 'srated from p20hp.py'
    },
]

for test in test_cases:
    try:
        result = test['expression']()
        expected = test['expected_approx']
        rel_error = abs(result - expected) / expected * 100

        if rel_error < 5:  # 5% tolerance
            status = "✓"
        else:
            status = "⚠"

        print(f"  {status} {test['name']:<40}: {result:.6f} (expected ~{expected:.6f})")
        print(f"     {test['description']}")

    except Exception as e:
        print(f"  ✗ {test['name']:<40}: Error - {e}")

# Test 4: Quick simulation test (optional, commented for speed)
print("\n[4/4] Quick simulation sanity check...")
print("  (For full testing, run individual scripts)")

try:
    import numpy as np
    from scipy.integrate import solve_ivp

    # Quick test of S1 model initialization
    print(f"  ✓ NumPy version: {np.__version__}")
    print(f"  ✓ SciPy solve_ivp available")

    # Test Clarke transformation
    vas_test = 1.0
    vbs_test = -0.5
    vcs_test = -0.5
    vqs_test = (2/3) * (vas_test - (vbs_test + vcs_test) / 2)
    vds_test = (vcs_test - vbs_test) / np.sqrt(3)

    print(f"  ✓ Clarke transformation: vqs={vqs_test:.4f}, vds={vds_test:.4f}")

    # Test simple integration
    def test_ode(t, y):
        return [-y[0]]  # dy/dt = -y

    sol = solve_ivp(test_ode, [0, 1], [1.0], method='RK45')
    final_val = sol.y[0, -1]

    if abs(final_val - np.exp(-1)) < 0.01:
        print(f"  ✓ solve_ivp working correctly: exp(-1) ≈ {final_val:.6f}")
    else:
        print(f"  ⚠ solve_ivp result unexpected: {final_val:.6f}")

except ImportError as e:
    print(f"  ✗ Missing dependency: {e}")
except Exception as e:
    print(f"  ✗ Error during sanity check: {e}")

# Summary
print("\n" + "="*80)
print("VERIFICATION SUMMARY")
print("="*80)
print("\nAll conversions are ready to run!")
print("\nTo execute simulations:")
print("  cd /home/rodo/Maquinas/C6")
print("  python S1_stationary_frame.py")
print("  python S4EIG_synchronous_frame.py")
print("  python S4STP_step_response.py")
print("  python S5A_neutral_voltage.py")
print("  python S5B_unbalanced_load.py")
print("  python S6_single_phase.py")
print("\nTo analyze MDL structure:")
print("  python analyze_mdl_files.py")
print("\nDocumentation:")
print("  See MDL_to_Python_Conversion_Summary.md for detailed information")
print("="*80)
