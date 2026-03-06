#!/usr/bin/env python3
"""
Utility script to analyze all MDL files using the mdl_parser
Extracts and displays structure of each Simulink model
"""
import sys
sys.path.append('/home/rodo/Maquinas/tools')
from mdl_parser import MDLParser
import os

# MDL files to analyze
mdl_files = [
    '/home/rodo/Maquinas/C6/S1.MDL',
    '/home/rodo/Maquinas/C6/S4EIG.MDL',
    '/home/rodo/Maquinas/C6/S4STP.MDL',
    '/home/rodo/Maquinas/C6/S5A.MDL',
    '/home/rodo/Maquinas/C6/S5B.MDL',
    '/home/rodo/Maquinas/C6/S6.MDL',
]

descriptions = {
    'S1.MDL': 'Induction machine - Stationary reference frame',
    'S4EIG.MDL': 'Induction machine - Synchronous frame (eigenvalue analysis)',
    'S4STP.MDL': 'Induction machine - Step response',
    'S5A.MDL': 'Induction machine - With neutral voltage',
    'S5B.MDL': 'Induction machine - Unbalanced load',
    'S6.MDL': 'Single-phase induction motor',
}

def extract_fcn_expressions(mdl_file):
    """Extract all Fcn block expressions from MDL file"""
    expressions = []
    with open(mdl_file, 'r') as f:
        lines = f.readlines()
        in_fcn_block = False
        fcn_name = None

        for line in lines:
            if 'BlockType		  Fcn' in line or 'BlockType\t\tFcn' in line:
                in_fcn_block = True
            elif in_fcn_block and 'Name' in line and 'BlockType' not in line:
                # Extract function block name
                import re
                match = re.search(r'Name\s+"([^"]+)"', line)
                if match:
                    fcn_name = match.group(1)
            elif in_fcn_block and 'Expr' in line:
                # Extract expression
                import re
                match = re.search(r'Expr\s+"([^"]+)"', line)
                if match:
                    expr = match.group(1)
                    expressions.append((fcn_name if fcn_name else 'Unknown', expr))
                    fcn_name = None
                    in_fcn_block = False

    return expressions

def extract_integrators(mdl_file):
    """Extract integrator blocks and their initial conditions"""
    integrators = []
    with open(mdl_file, 'r') as f:
        lines = f.readlines()
        in_integrator = False
        int_name = None
        int_ic = None

        for line in lines:
            if 'BlockType		  Integrator' in line or 'BlockType\t\tIntegrator' in line:
                in_integrator = True
            elif in_integrator and 'Name' in line and 'BlockType' not in line:
                import re
                match = re.search(r'Name\s+"([^"]+)"', line)
                if match:
                    int_name = match.group(1)
            elif in_integrator and 'InitialCondition' in line:
                import re
                match = re.search(r'InitialCondition\s+"([^"]+)"', line)
                if match:
                    int_ic = match.group(1)
            elif in_integrator and int_name and (line.strip() == '}' or 'Block {' in line):
                integrators.append((int_name, int_ic if int_ic else '0'))
                int_name = None
                int_ic = None
                in_integrator = False

    return integrators

print("="*80)
print("MDL FILES ANALYSIS")
print("="*80)

for mdl_file in mdl_files:
    if not os.path.exists(mdl_file):
        print(f"\n[!] File not found: {mdl_file}")
        continue

    filename = os.path.basename(mdl_file)
    print(f"\n{'='*80}")
    print(f"FILE: {filename}")
    print(f"Description: {descriptions.get(filename, 'N/A')}")
    print(f"{'='*80}")

    # Parse using MDLParser
    try:
        parser = MDLParser(mdl_file)
        model_info = parser.parse()

        # Display basic info
        print(f"\nModel Name: {model_info['model_name']}")
        print(f"\nSolver Configuration:")
        for key, value in model_info['solver'].items():
            print(f"  {key:15s}: {value}")

        # Block summary
        print(f"\nBlock Summary:")
        block_types = {}
        for block in model_info['blocks']:
            btype = block.get('type', 'Unknown')
            block_types[btype] = block_types.get(btype, 0) + 1

        for btype in sorted(block_types.keys()):
            print(f"  {btype:20s}: {block_types[btype]:3d}")

        print(f"\nTotal Blocks: {len(model_info['blocks'])}")
        print(f"Total Connections: {len(model_info['connections'])}")

        # Extract Fcn expressions
        print(f"\n{'─'*80}")
        print("Fcn Block Expressions (Key Equations):")
        print(f"{'─'*80}")
        expressions = extract_fcn_expressions(mdl_file)
        if expressions:
            for i, (name, expr) in enumerate(expressions[:10], 1):  # Limit to first 10
                print(f"{i:2d}. {name:20s}: {expr}")
            if len(expressions) > 10:
                print(f"     ... and {len(expressions) - 10} more")
        else:
            print("  No Fcn blocks found")

        # Extract integrators
        print(f"\n{'─'*80}")
        print("Integrator Blocks (State Variables):")
        print(f"{'─'*80}")
        integrators = extract_integrators(mdl_file)
        if integrators:
            for i, (name, ic) in enumerate(integrators, 1):
                print(f"{i:2d}. {name:20s} (IC = {ic})")
        else:
            print("  No integrator blocks found")

    except Exception as e:
        print(f"[!] Error parsing {filename}: {e}")

# Summary table
print("\n" + "="*80)
print("CONVERSION SUMMARY TABLE")
print("="*80)
print(f"{'MDL File':<15} {'Python File':<35} {'States':<8} {'Frame':<15}")
print("-"*80)

conversions = [
    ('S1.MDL', 'S1_stationary_frame.py', 5, 'Stationary qd0'),
    ('S4EIG.MDL', 'S4EIG_synchronous_frame.py', 5, 'Synchronous'),
    ('S4STP.MDL', 'S4STP_step_response.py', 5, 'Synchronous'),
    ('S5A.MDL', 'S5A_neutral_voltage.py', 5, 'Stationary qd0'),
    ('S5B.MDL', 'S5B_unbalanced_load.py', 6, 'Stationary qd0'),
    ('S6.MDL', 'S6_single_phase.py', 4, 'Asymmetric dq'),
]

for mdl, py, states, frame in conversions:
    print(f"{mdl:<15} {py:<35} {states:<8} {frame:<15}")

print("\n" + "="*80)
print("Analysis complete. Python conversions available in /home/rodo/Maquinas/C6/")
print("Documentation: MDL_to_Python_Conversion_Summary.md")
print("="*80)
