#!/usr/bin/env python3
"""
Test script for all enhanced control system models
Tests C9 (induction motor) and C10 (power systems) implementations
"""

import sys
import os

print("="*70)
print("TESTING ENHANCED CONTROL SYSTEM MODELS")
print("="*70)

# Test C9 models (Induction Motor Control)
print("\n" + "="*70)
print("C9 - INDUCTION MOTOR CONTROL")
print("="*70)

print("\n[1/5] Testing S1C.py - V/f Closed Loop Control...")
try:
    sys.path.append('/home/rodo/Maquinas/C9')
    os.chdir('/home/rodo/Maquinas/C9')
    exec(open('/home/rodo/Maquinas/C9/S1C.py').read())
    print("✓ S1C.py completed successfully")
except Exception as e:
    print(f"✗ S1C.py failed: {e}")

print("\n[2/5] Testing S1O.py - V/f Open Loop Control...")
try:
    exec(open('/home/rodo/Maquinas/C9/S1O.py').read())
    print("✓ S1O.py completed successfully")
except Exception as e:
    print(f"✗ S1O.py failed: {e}")

print("\n[3/5] Testing S3.py - Field-Oriented Control...")
try:
    exec(open('/home/rodo/Maquinas/C9/S3.py').read())
    print("✓ S3.py (FOC) completed successfully")
except Exception as e:
    print(f"✗ S3.py failed: {e}")

# Test C10 models (Power Systems)
print("\n" + "="*70)
print("C10 - POWER SYSTEMS")
print("="*70)

print("\n[4/5] Testing S4.py - Power System Stabilizer...")
try:
    sys.path.append('/home/rodo/Maquinas/C10')
    os.chdir('/home/rodo/Maquinas/C10')
    exec(open('/home/rodo/Maquinas/C10/S4.py').read())
    print("✓ S4.py (PSS) completed successfully")
except Exception as e:
    print(f"✗ S4.py failed: {e}")

print("\n[5/5] Testing S3.py - Subsynchronous Resonance...")
try:
    exec(open('/home/rodo/Maquinas/C10/S3.py').read())
    print("✓ S3.py (SSR) completed successfully")
except Exception as e:
    print(f"✗ S3.py failed: {e}")

print("\n" + "="*70)
print("TESTING COMPLETE")
print("="*70)
print("\nImplemented models:")
print("  C9/S1C.py  - V/f closed loop (speed feedback)")
print("  C9/S1O.py  - V/f open loop (frequency ramp)")
print("  C9/S3.py   - Field-oriented control (FOC)")
print("  C10/S4.py  - Generator with PSS")
print("  C10/S3.py  - SSR with 6-mass torsional system")
print("\nCheck output plots in respective directories:")
print("  /home/rodo/Maquinas/C9/")
print("  /home/rodo/Maquinas/C10/")
