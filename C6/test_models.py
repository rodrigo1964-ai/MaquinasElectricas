#!/usr/bin/env python3
"""
Test script to verify all C6 induction machine models
"""
import sys
import numpy as np

def test_imports():
    """Test that all modules can be imported"""
    print("=" * 70)
    print("Testing C6 Induction Machine Model Imports")
    print("=" * 70)

    models = ['S1', 'S4EIG', 'S4STP', 'S5A', 'S5B', 'S6']
    success = []
    failed = []

    for model in models:
        try:
            exec(f"import {model}")
            print(f"✓ {model}.py - Import successful")
            success.append(model)
        except Exception as e:
            print(f"✗ {model}.py - Import failed: {e}")
            failed.append(model)

    print("\n" + "=" * 70)
    print(f"Results: {len(success)}/{len(models)} models imported successfully")
    if failed:
        print(f"Failed: {', '.join(failed)}")
    print("=" * 70)

    return len(failed) == 0

def test_parameter_file():
    """Test parameter file"""
    print("\n" + "=" * 70)
    print("Testing Parameter File (p20hp.py)")
    print("=" * 70)

    try:
        from p20hp import *
        print(f"✓ Parameters loaded successfully")
        print(f"  - Power rating: {Sb/746:.1f} HP ({Sb:.0f} VA)")
        print(f"  - Rated voltage: {Vrated:.0f} V")
        print(f"  - Number of poles: {P}")
        print(f"  - Rated frequency: {frated} Hz")
        print(f"  - Stator resistance: {rs:.4f} Ω")
        print(f"  - Rotor resistance: {rpr:.4f} Ω")
        print(f"  - Inertia: {J:.2f} kg·m²")
        print(f"  - Inertia constant H: {H:.4f} s")
        return True
    except Exception as e:
        print(f"✗ Failed to load parameters: {e}")
        return False

def list_models():
    """List all available models with descriptions"""
    print("\n" + "=" * 70)
    print("Available C6 Induction Machine Models")
    print("=" * 70)

    models = [
        ("S1.py", "Stationary frame dq model",
         "Three-phase balanced supply, stationary reference frame"),

        ("S4EIG.py", "Synchronous frame for eigenvalue analysis",
         "Synchronously rotating frame, eigenvalue computation"),

        ("S4STP.py", "Synchronous frame step response",
         "Step voltage response in synchronous frame"),

        ("S5A.py", "With neutral voltage",
         "Includes zero-sequence circuit and neutral-to-ground voltage"),

        ("S5B.py", "Unbalanced load with neutral voltage",
         "Unbalanced voltage supply, V/Hz control, neutral voltage"),

        ("S6.py", "Single-phase motor with capacitor",
         "Single-phase motor with start/run capacitor switching"),
    ]

    for i, (name, title, desc) in enumerate(models, 1):
        print(f"\n{i}. {name}")
        print(f"   {title}")
        print(f"   → {desc}")

    print("\n" + "=" * 70)
    print("Usage Examples:")
    print("=" * 70)
    print("  python S1.py          # Run stationary frame simulation")
    print("  python S4EIG.py       # Run eigenvalue analysis")
    print("  python S4STP.py       # Run step response")
    print("  python S5A.py         # Run with neutral voltage")
    print("  python S5B.py         # Run unbalanced load simulation")
    print("  python S6.py          # Run single-phase motor")
    print("=" * 70)

def show_equations():
    """Display the fundamental induction machine equations"""
    print("\n" + "=" * 70)
    print("Induction Machine Fundamental Equations")
    print("=" * 70)

    print("\nStator Voltage Equations (dq frame):")
    print("  vqs = rs·iqs + dψqs/dt - ωe·ψds")
    print("  vds = rs·ids + dψds/dt + ωe·ψqs")
    print("  (ωe = 0 for stationary frame)")

    print("\nRotor Voltage Equations (rotor dq frame):")
    print("  vqr = rr·iqr + dψqr/dt - (ωe-ωr)·ψdr")
    print("  vdr = rr·idr + dψdr/dt + (ωe-ωr)·ψqr")
    print("  (vqr = vdr = 0 for squirrel cage)")

    print("\nFlux Linkage Equations:")
    print("  ψqs = Ls·iqs + Lm·iqr")
    print("  ψds = Ls·ids + Lm·idr")
    print("  ψqr = Lr·iqr + Lm·iqs")
    print("  ψdr = Lr·idr + Lm·ids")
    print("  where Ls = Lls + Lm, Lr = Llr + Lm")

    print("\nElectromagnetic Torque:")
    print("  Te = (3/2)·(P/2)·(ψds·iqs - ψqs·ids)")
    print("  Tfactor = (3·P)/(4·ωb)")

    print("\nMechanical Equation:")
    print("  J·dωm/dt = Te - Tm - D·ωm")
    print("  or: (2H)·d(ωr/ωb)/dt = Te - Tm - D·(ωr/ωb)")
    print("  where H = J·ωbm²/(2·Sb)")

    print("\nPer-Unit System:")
    print("  Base power: Sb (VA)")
    print("  Base voltage: Vb = Vrated·√(2/3)")
    print("  Base impedance: Zb = Vrated²/Sb")
    print("  Base frequency: ωb = 2π·frated")
    print("  Base mechanical frequency: ωbm = 2ωb/P")
    print("=" * 70)

if __name__ == "__main__":
    print("\n")
    print("╔" + "=" * 68 + "╗")
    print("║" + " " * 15 + "C6 INDUCTION MACHINE MODELS TEST" + " " * 20 + "║")
    print("╚" + "=" * 68 + "╝")

    # Test parameter file
    param_ok = test_parameter_file()

    # Test imports
    import_ok = test_imports()

    # Show available models
    list_models()

    # Show equations
    show_equations()

    # Final summary
    print("\n" + "=" * 70)
    print("SUMMARY")
    print("=" * 70)
    if param_ok and import_ok:
        print("✓ All models are ready to run!")
        print("✓ Parameter file loaded successfully")
        print("\nYou can now run any model by executing:")
        print("  python <model_name>.py")
    else:
        print("✗ Some issues detected. Please review the errors above.")
        sys.exit(1)
    print("=" * 70 + "\n")
