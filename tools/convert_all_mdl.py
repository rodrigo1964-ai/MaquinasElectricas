#!/usr/bin/env python3
"""
Batch conversion script for all .MDL files in C7 and C8 directories
Converts Simulink models to Python simulations with proper machine equations
"""

import os
import sys
from pathlib import Path
from mdl_parser import MDLParser

# Directory paths
BASE_DIR = Path("/home/rodo/Maquinas")
C7_DIR = BASE_DIR / "C7"
C8_DIR = BASE_DIR / "C8"
TOOLS_DIR = Path("/home/rodo/Maquinas/tools")

# Add tools directory to path
sys.path.insert(0, str(TOOLS_DIR))

# Import the enhanced converters
from sync_machine_converter import convert_sync_machine_mdl
from dc_machine_converter import convert_dc_machine_mdl

def convert_c7_models():
    """Convert C7 synchronous machine models"""
    print("\n" + "="*70)
    print("CONVERTING C7 - SYNCHRONOUS MACHINES")
    print("="*70)

    c7_models = [
        ("S1.MDL", "m1.py", "Synchronous generator"),
        ("S3.MDL", "m3.py", "Synchronous generator - linearization"),
        ("S3EIG.MDL", "m3.py", "Synchronous generator - eigenvalue analysis"),
        ("S4.MDL", "m4.py", "Permanent magnet motor"),
        ("S5.MDL", "m5.py", "2x3 phase machine"),
    ]

    for mdl_file, param_file, description in c7_models:
        mdl_path = C7_DIR / mdl_file
        param_path = C7_DIR / param_file

        if not mdl_path.exists():
            print(f"\nSkipping {mdl_file} - file not found")
            continue

        print(f"\n{'─'*70}")
        print(f"Converting: {mdl_file}")
        print(f"Description: {description}")
        print(f"Parameters: {param_file}")
        print(f"{'─'*70}")

        try:
            output_file = convert_sync_machine_mdl(
                str(mdl_path),
                str(param_path),
                description
            )
            print(f"✓ Successfully created: {output_file}")
        except Exception as e:
            print(f"✗ Error converting {mdl_file}: {e}")

def convert_c8_models():
    """Convert C8 DC machine models"""
    print("\n" + "="*70)
    print("CONVERTING C8 - DC MACHINES")
    print("="*70)

    c8_models = [
        ("S1.MDL", "m1.py", "Shunt generator"),
        ("S2.MDL", "m2.py", "DC motor starting"),
        ("S3A.MDL", "m3a.py", "Dynamic braking"),
        ("S3B.MDL", "m3b.py", "Regenerative braking"),
        ("S4.MDL", "m4.py", "Universal motor"),
        ("S5.MDL", "m5.py", "Series motor"),
    ]

    for mdl_file, param_file, description in c8_models:
        mdl_path = C8_DIR / mdl_file
        param_path = C8_DIR / param_file

        if not mdl_path.exists():
            print(f"\nSkipping {mdl_file} - file not found")
            continue

        print(f"\n{'─'*70}")
        print(f"Converting: {mdl_file}")
        print(f"Description: {description}")
        print(f"Parameters: {param_file}")
        print(f"{'─'*70}")

        try:
            output_file = convert_dc_machine_mdl(
                str(mdl_path),
                str(param_path),
                description
            )
            print(f"✓ Successfully created: {output_file}")
        except Exception as e:
            print(f"✗ Error converting {mdl_file}: {e}")

def main():
    """Main conversion function"""
    print("\n" + "="*70)
    print("MDL TO PYTHON CONVERTER")
    print("Converting Simulink models to Python simulations")
    print("="*70)

    # Convert C7 synchronous machines
    convert_c7_models()

    # Convert C8 DC machines
    convert_c8_models()

    print("\n" + "="*70)
    print("CONVERSION COMPLETE")
    print("="*70)
    print("\nAll MDL files have been processed.")
    print("Check the output files in C7 and C8 directories.")

if __name__ == "__main__":
    main()
