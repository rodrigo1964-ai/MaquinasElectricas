# C6 Induction Machine Models - Complete Implementation

This directory contains complete Python implementations of induction machine models from Chapter 6, converted from MATLAB/Simulink to Python with full equation implementations.

## Overview

All models have been fully implemented with:
- ✓ Complete differential equations
- ✓ Proper state-space formulation
- ✓ Integration with scipy.integrate.solve_ivp
- ✓ Visualization with matplotlib
- ✓ Parameters from p20hp.py (20 HP motor)
- ✓ Executable scripts

## Models Implemented

### 1. **S1.py** - Stationary Reference Frame
**Description:** Three-phase induction machine in stationary qd0 reference frame

**Features:**
- Balanced three-phase voltage supply
- abc to qds transformation
- Zero-sequence circuit with capacitor to ground
- Mechanical load profile
- Complete qd0 model

**States:** `[psiqs, psiqr, psids, psidr, wr_wb, vsg, i0s]`

**Usage:**
```python
python S1.py
```

**Equations Implemented:**
- Stator: `vqs = rs·iqs + dψqs/dt`, `vds = rs·ids + dψds/dt`
- Rotor: `0 = rr·iqr + dψqr/dt - ωr·ψdr`, `0 = rr·idr + dψdr/dt + ωr·ψqr`
- Flux: `ψqs = Ls·iqs + Lm·iqr`, etc.
- Torque: `Te = Tfactor·(ψds·iqs - ψqs·ids)`
- Mechanical: `(2H)·dωr/dt = Te - Tm - D·ωr`

---

### 2. **S4EIG.py** - Synchronous Reference Frame (Eigenvalue Analysis)
**Description:** Induction machine in synchronously rotating reference frame for stability analysis

**Features:**
- Synchronous frame transformation (rotating at we)
- Eigenvalue computation for linearized system
- Numerical Jacobian calculation
- Stability analysis
- Constant voltage and torque inputs

**States:** `[psiqs, psiqr, psids, psidr, wr_wb]`

**Usage:**
```python
python S4EIG.py
```

**Special Features:**
- `compute_eigenvalues()` function for stability analysis
- Steady-state operating point computation
- Linear system analysis

---

### 3. **S4STP.py** - Step Response (Synchronous Frame)
**Description:** Studies transient response to voltage step changes

**Features:**
- Step voltage input
- Time-varying vqse profile
- Synchronous frame dynamics
- Fast transient analysis

**States:** `[psiqs, psiqr, psids, psidr, wr_wb]`

**Usage:**
```python
python S4STP.py
```

**Application:** Voltage transient studies, control system design

---

### 4. **S5A.py** - With Neutral Voltage
**Description:** Includes zero-sequence circuit modeling

**Features:**
- Neutral-to-ground voltage (vsg)
- Capacitor to ground model
- Zero-sequence current (i0s)
- Three-phase to qd0 transformation
- Ungrounded wye connection effects

**States:** `[psiqs, psiqr, psids, psidr, wr_wb, vsg, i0s]`

**Usage:**
```python
python S5A.py
```

**Application:** Neutral voltage studies, grounding analysis

---

### 5. **S5B.py** - Unbalanced Load with Neutral Voltage
**Description:** Machine performance under unbalanced voltage conditions

**Features:**
- Unbalanced voltage supply (configurable unbalance factor)
- Variable frequency operation (V/Hz control)
- Neutral voltage development
- Torque pulsations at 2× line frequency
- Zero-sequence effects

**States:** `[psiqs, psiqr, psids, psidr, wr_wb, vsg, i0s, theta]`

**Usage:**
```python
python S5B.py
```

**Parameters:**
- `unbalance_factor`: Voltage unbalance (default 10%)
- `frequency_ramp`: Enable V/Hz control

**Application:** Unbalanced voltage studies, power quality analysis

---

### 6. **S6.py** - Single-Phase Motor with Capacitor
**Description:** Single-phase induction motor with start and run capacitors

**Features:**
- Main winding (d-axis aligned)
- Auxiliary winding (q-axis, capacitor connected)
- Automatic capacitor switching
- Start capacitor: high torque at startup
- Run capacitor: efficiency at running speed
- Asymmetric machine (different d/q axis reactances)

**States:** `[psiqs, psiqr, psipds, psidr, wr_wb, Vcap]`

**Usage:**
```python
python S6.py
```

**Parameters:**
- `Cstart`: Starting capacitor (default 200 µF)
- `Crun`: Running capacitor (default 20 µF)
- `switch_speed`: Switching threshold (default 0.75 pu)

**Application:** Single-phase motor design, capacitor sizing

---

## Common Parameters (from p20hp.py)

All models use the 20 HP three-phase induction motor parameters:

```python
Sb = 14920 VA          # 20 HP rating
Vrated = 220 V         # Line-to-line voltage
P = 4                  # Number of poles
frated = 60 Hz         # Rated frequency
rs = 0.1062 Ω          # Stator resistance
rpr = 0.0764 Ω         # Rotor resistance (referred)
xls = 0.2145 Ω         # Stator leakage reactance
xplr = 0.2145 Ω        # Rotor leakage reactance
xm = 5.8339 Ω          # Magnetizing reactance
J = 2.8 kg·m²          # Rotor inertia
H = 0.5 s              # Inertia constant
```

## Fundamental Equations

### Voltage Equations (dq frame)

**Stator:**
```
vqs = rs·iqs + dψqs/dt - ωe·ψds
vds = rs·ids + dψds/dt + ωe·ψqs
```
(ωe = 0 for stationary frame, ωe = ωb for synchronous frame)

**Rotor:**
```
0 = rr·iqr + dψqr/dt - (ωe-ωr)·ψdr
0 = rr·idr + dψdr/dt + (ωe-ωr)·ψqr
```
(squirrel cage rotor: vqr = vdr = 0)

### Flux Linkages
```
ψqs = Ls·iqs + Lm·iqr
ψds = Ls·ids + Lm·idr
ψqr = Lr·iqr + Lm·iqs
ψdr = Lr·idr + Lm·ids
```

Using inverse form (per-unit reactances):
```
ψm = xM·(ψs/xls + ψr/xplr)
is = (ψs - ψm)/xls
ir = (ψr - ψm)/xplr
```

### Electromagnetic Torque
```
Te = (3/2)·(P/2)·(ψds·iqs - ψqs·ids)
Tfactor = (3·P)/(4·ωb)
```

### Mechanical Equation
```
J·dωm/dt = Te - Tm - D·ωm
```
In per-unit:
```
(2H)·d(ωr/ωb)/dt = Te - Tm - D·(ωr/ωb)
```
where `H = J·ωbm²/(2·Sb)`

## Running the Models

### Individual Model Execution
```bash
python S1.py          # Stationary frame
python S4EIG.py       # Eigenvalue analysis
python S4STP.py       # Step response
python S5A.py         # With neutral voltage
python S5B.py         # Unbalanced load
python S6.py          # Single-phase motor
```

### Test All Models
```bash
python test_models.py
```

This will:
- Verify all imports
- Load parameter file
- List available models
- Display fundamental equations
- Show usage examples

## Customization

### Modify Initial Conditions
```python
Psiqso = 0.0    # Initial q-axis stator flux
Psipqro = 0.0   # Initial q-axis rotor flux
Psidso = 0.0    # Initial d-axis stator flux
Psipdro = 0.0   # Initial d-axis rotor flux
wrbywbo = 0.0   # Initial rotor speed (pu)
```

### Modify Mechanical Load
```python
tmech_time = np.array([0, 0.8, 0.8, 1.2, 1.2, 2.0])
tmech_value = np.array([0, 0, -0.5, -0.5, -1.0, -1.0]) * Tb
```

### Change Simulation Time
```python
tstop = 2.0  # Simulation duration in seconds
```

### Adjust Solver Tolerances
```python
rtol = 1e-6  # Relative tolerance
atol = 1e-8  # Absolute tolerance
```

## Output

Each model generates plots showing:
- Voltages (phase and/or dq frame)
- Currents (phase and/or dq frame)
- Electromagnetic torque
- Rotor speed
- Model-specific quantities (neutral voltage, capacitor state, etc.)

## Dependencies

```python
numpy>=1.20.0
scipy>=1.7.0
matplotlib>=3.3.0
```

Install with:
```bash
pip install numpy scipy matplotlib
```

## File Structure

```
C6/
├── S1.py                    # Stationary frame model
├── S4EIG.py                 # Eigenvalue analysis
├── S4STP.py                 # Step response
├── S5A.py                   # With neutral voltage
├── S5B.py                   # Unbalanced load
├── S6.py                    # Single-phase motor
├── p20hp.py                 # 20 HP motor parameters
├── test_models.py           # Test/verification script
└── README_MODELS.md         # This file
```

## Theory References

These models implement the induction machine equations from:
- Chapter 6: Induction Machines
- Stationary reference frame (αβ0 or qd0)
- Synchronously rotating reference frame
- Per-unit system representation
- Zero-sequence modeling
- Single-phase motor theory

## Key Features of Implementation

1. **State-Space Formulation**: All models use flux linkages as state variables
2. **Efficient Integration**: scipy's solve_ivp with adaptive step size
3. **Modular Design**: Each model is self-contained and executable
4. **Clear Documentation**: Extensive comments and docstrings
5. **Validated**: Based on established MATLAB/Simulink models
6. **Extensible**: Easy to modify for different motors or operating conditions

## Troubleshooting

**Integration fails:**
- Reduce step size or adjust tolerances
- Check initial conditions are reasonable
- Verify parameters are physical (positive resistances, etc.)

**Results look incorrect:**
- Verify parameter units (Ω, H, kg·m², etc.)
- Check voltage/torque profile definitions
- Ensure per-unit conversions are correct

**Import errors:**
- Ensure p20hp.py is in same directory
- Install required packages (numpy, scipy, matplotlib)
- Check Python version (3.7+)

## Contact & Support

For questions about the models or implementation details, refer to the original MATLAB files (S*.M, S*.MDL) or contact the maintainer.

---

**Status:** ✓ All models complete and executable
**Last Updated:** 2026-03-06
**Python Version:** 3.7+
**License:** Educational use
