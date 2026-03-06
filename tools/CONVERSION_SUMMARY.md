# MDL to Python Conversion Summary

## Overview
Complete conversion of Simulink .MDL files to executable Python simulations with proper electrical machine equations.

## Tools Created

### 1. `/home/rodo/Maquinas/tools/mdl_parser.py`
- Basic MDL file parser
- Extracts blocks, connections, and solver configuration
- Generates template Python code

### 2. `/home/rodo/Maquinas/tools/dc_machine_converter.py`
- DC machine equation templates
- Supports: shunt, series, separately-excited configurations
- Implements armature/field circuits, back-EMF, torque equations

### 3. `/home/rodo/Maquinas/tools/sync_machine_converter.py`
- Synchronous machine equation templates
- Implements dq0 reference frame equations
- Supports wound rotor and permanent magnet configurations

### 4. `/home/rodo/Maquinas/tools/convert_all_mdl.py`
- Batch conversion script
- Processes all C7 and C8 MDL files
- Maps MDL files to appropriate parameter files

## Enhanced Simulations Created

### C7 - Synchronous Machines

#### S1_enhanced.py - Synchronous Generator
**Equations Implemented:**
```python
# State variables: [delta, Psiq, Psikq, Psid, Psif, Psikd, wm]
#
# Flux linkages (air-gap mutual):
Psiaq = xMQ * (Psiq/xls + Psikq/xplkq)
Psiad = xMD * (Psid/xls + Psif/xplf + Psikd/xplkd)
#
# Stator equations (dq frame):
dPsiq_dt = vq + rs*iq - wb*wm*Psid
dPsid_dt = vd + rs*id + wb*wm*Psiq
#
# Field winding:
dPsif_dt = vf - rpf*iif
#
# Damper windings:
dPsikd_dt = -rpkd*ikd
dPsikq_dt = -rpkq*ikq
#
# Mechanical:
dwm_dt = (Tm - Te - Domega*(wm - 1.0)) / (2*H)
ddelta_dt = wb*(wm - 1.0)
#
# Torque:
Te = Psid*iq - Psiq*id
```

**Features:**
- Complete 7-state model with field and damper windings
- dq0 transformation in rotor reference frame
- Mutual inductances xMD, xMQ for air-gap flux
- Disturbances: step changes in Ef, Tmech, Vm
- Parameters from set1.py
- Instability detection (loss of synchronism)

**Output:**
- 9 subplots: angle, speed, field current, dq currents, torque, power, flux linkages
- Saved as `s1_results.png`

---

#### S4_enhanced.py - Permanent Magnet Motor
**Equations Implemented:**
```python
# State variables: [delta, Psiq, Psikq, Psid, Psikd, wr_slip]
#
# PM excitation included in d-axis:
Psiad = xMD * (Psid/xls + (Psikd + xmd*Ipm)/xplkd)
#
# Similar stator and damper equations as wound rotor
# But no field winding (replaced by PM)
#
# Slip dynamics:
dwr_slip_dt = (Te - Tm - Domega*wr_slip) / (2*H)
```

**Features:**
- 6-state PM motor model
- Permanent magnet excitation (Ipm parameter)
- Starting from rest or steady-state
- Speed-dependent load capability
- Parameters from m4.py

**Output:**
- Speed (RPM & pu), load angle, dq currents, torque, power, flux linkages, slip
- Saved as `s4_results.png`

---

### C8 - DC Machines

#### S1_enhanced.py - DC Shunt Generator
**Equations Implemented:**
```python
# States: [If, Ia, wm]
#
# Field circuit (self-excited):
dIf_dt = (Vf - (Rf + Rrh)*If) / Lf
# where Vf = Va (field across armature)
#
# Armature circuit:
dIa_dt = (Ea - Ra*Ia - Va) / Laq
#
# Back-EMF from magnetization curve:
Ea = mag_curve(If) * (wm / wmo)
#
# Torque (power balance):
Te = Ea * Ia / wm
#
# Mechanical (constant speed for generator):
dwm_dt = 0  # or (Tmech - Te - D*wm) / J
```

**Features:**
- Self-excitation build-up simulation
- Magnetization curve interpolation (cubic spline)
- Armature reaction effect included
- Load resistance variations
- Parameters from m1.py with SHVP1/SHIP1 mag curve

**Output:**
- Field current, back-EMF, terminal voltage, armature current, torque, power
- Operating point on magnetization curve
- Saved as `s1_results.png`

---

#### S2_enhanced.py - DC Motor Starting
**Equations Implemented:**
```python
# States: [Ia, wm]
#
# Armature circuit:
dIa_dt = (Va - Ea - Ra*Ia) / Laq
#
# Back-EMF:
Ea = Ka * wm
# where Ka = (Vrated - Ra*Iarated) / wmrated
#
# Torque:
Te = Ka * Ia
#
# Mechanical:
dwm_dt = (Te - Tload - D*wm) / J
```

**Features:**
- Direct-on-line starting from standstill
- Optional starting resistance
- Peak current and torque calculation
- Energy balance analysis
- Starting time to 95% speed
- Torque-speed characteristics
- Parameters from m2.py

**Output:**
- Current, speed, back-EMF, torque, power flow, losses
- Torque-speed and current-speed curves
- Phase plane trajectory
- Starting statistics
- Saved as `s2_results.png`

---

#### S3A_enhanced.py - Braking Methods (Plugging & Dynamic)
**Equations Implemented:**
```python
# PLUGGING (t > 0.5s):
# Reverse voltage with added resistance
Va = -Vrated
Rtotal = Ra + Rext_plugging
dIa_dt = (Va - Ea - Rtotal*Ia) / Laq

# DYNAMIC BRAKING (t > 0.5s):
# Disconnect supply, short through resistor
Va = 0
Rtotal = Ra + Rext_dynamic
dIa_dt = (Va - Ea - Rtotal*Ia) / Laq

# Common mechanical equation:
dwm_dt = (Te - Tload) / J
```

**Features:**
- Two braking methods compared side-by-side
- Braking resistor calculation
- Energy dissipation analysis
- Stop-at-zero detection
- Parameters from m3a.py

**Output:**
- 3 columns: plugging, dynamic, comparison
- Current, speed, torque for each method
- Energy bar chart with braking times
- Saved as `s3a_results.png`

---

#### S5_enhanced.py - Series Motor Hoist
**Equations Implemented:**
```python
# States: [Ia, wm]
#
# Series motor (If = Ia):
# Total inductance: Ltotal = Laq + Lse
dIa_dt = (Va - Ea - (Ra + Rse + Rext)*Ia) / Ltotal
#
# Back-EMF from magnetization curve:
kaphi = Ea_curve(Ia) / wmo  # nonlinear
Ea = kaphi * wm
#
# Torque (nonlinear):
Te = kaphi * Ia
#
# Mechanical:
dwm_dt = (Te - Tload) / J
```

**Features:**
- Full magnetization curve (positive & negative)
- Three scenarios: motoring, braking with Va=Vrated, braking with Va=0
- Regenerative braking for hoist/elevator
- Braking resistor calculation for controlled descent
- Parameters from m5.py with SEVP5/SEIP5 mag curve

**Output:**
- Speed, current, torque, back-EMF for all scenarios
- Torque-speed characteristics overlay
- Operating points on magnetization curve
- Comparison of all three modes
- Saved as `s5_results.png`

---

## Key Equations Summary

### Synchronous Machines (dq0 Frame)

**Stator Voltage Equations:**
```
vq = -rs*iq + wb*ψd + dψq/dt
vd = -rs*id - wb*ψq + dψd/dt
```

**Flux Linkages:**
```
ψq = xls*iq + ψaq    (stator q-axis)
ψd = xls*id + ψad    (stator d-axis)
ψf = xplf*if + ψad   (field)
ψkq = xplkq*ikq + ψaq (q-axis damper)
ψkd = xplkd*ikd + ψad (d-axis damper)

where:
ψaq = xMQ * (iq/xls + ikq/xplkq)  (air-gap mutual)
ψad = xMD * (id/xls + if/xplf + ikd/xplkd)
```

**Torque:**
```
Te = ψd*iq - ψq*id
```

**Mechanical:**
```
2H * dωm/dt = Tm - Te - D*ωm
dδ/dt = wb*(ωm - 1)
```

### DC Machines

**Armature Circuit:**
```
La * dIa/dt = Va - Ea - Ra*Ia
```

**Field Circuit:**
```
Lf * dIf/dt = Vf - Rf*If
```

**Back-EMF:**
```
Ea = Kφ * ω
where Kφ from magnetization curve or constant
```

**Torque:**
```
Te = Kφ * Ia
```

**Mechanical:**
```
J * dω/dt = Te - Tload - D*ω
```

**Special Cases:**
- **Shunt:** If and Ia separate, Vf = Va (self-excited)
- **Series:** If = Ia, Kφ = f(Ia) nonlinear
- **Separately Excited:** If constant, Kφ constant

---

## Usage Instructions

### Running Individual Simulations

```bash
# C7 - Synchronous machines
cd /home/rodo/Maquinas/C7
python3 S1_enhanced.py  # Sync generator
python3 S4_enhanced.py  # PM motor

# C8 - DC machines
cd /home/rodo/Maquinas/C8
python3 S1_enhanced.py  # Shunt generator
python3 S2_enhanced.py  # Motor starting
python3 S3A_enhanced.py # Braking methods
python3 S5_enhanced.py  # Series motor hoist
```

### Requirements
```bash
pip install numpy scipy matplotlib
```

### Modifying Parameters

Each simulation imports from its respective parameter file:

**C7:**
- `set1.py`, `set3a.py`, `set3b.py`, `set3c.py` - Sync machine parameters
- `m4.py` - PM motor parameters

**C8:**
- `m1.py` - Shunt generator parameters with mag curve
- `m2.py` - Motor starting parameters
- `m3a.py`, `m3b.py` - Braking parameters
- `m5.py` - Series motor parameters with mag curve

Edit these files to change machine ratings, parameters, or operating conditions.

### Customizing Disturbances

**Synchronous Generator (S1_enhanced.py):**
```python
# Step change in field excitation
Ex_time = np.array([0, 0.2, 0.2, 5])
Ex_value = np.array([Efo, Efo, 1.1*Efo, 1.1*Efo])

# Step change in mechanical torque
tmech_time = np.array([0, 0.5, 0.5, 3, 3, 5])
tmech_value = np.array([Tmech, Tmech, 0, 0, -Tmech, -Tmech])

# Terminal voltage variation (short circuit)
Vm_time = np.array([0, 0.1, 0.1, 0.2, 0.2, 5])
Vm_value = np.array([1, 1, 0, 0, 1, 1])  # 0 = short circuit
```

---

## File Structure

```
/home/rodo/Maquinas/
├── tools/
│   ├── mdl_parser.py                 # Basic MDL parser
│   ├── dc_machine_converter.py       # DC machine templates
│   ├── sync_machine_converter.py     # Sync machine templates
│   ├── convert_all_mdl.py           # Batch converter
│   └── CONVERSION_SUMMARY.md        # This file
│
├── C7/ (Synchronous Machines)
│   ├── *.MDL                         # Original Simulink files
│   ├── set*.py                       # Parameter files
│   ├── m*.py                         # Setup scripts
│   ├── S1_enhanced.py               # ✓ Sync generator
│   ├── S3_enhanced.py               # (template - needs enhancement)
│   ├── S3EIG_enhanced.py            # (template - needs enhancement)
│   ├── S4_enhanced.py               # ✓ PM motor
│   ├── S5_enhanced.py               # (template - needs enhancement)
│   └── s*_results.png               # Output plots
│
└── C8/ (DC Machines)
    ├── *.MDL                         # Original Simulink files
    ├── m*.py                         # Parameter and setup files
    ├── S1_enhanced.py               # ✓ Shunt generator
    ├── S2_enhanced.py               # ✓ Motor starting
    ├── S3A_enhanced.py              # ✓ Braking (plugging/dynamic)
    ├── S3B_enhanced.py              # (template - regenerative braking)
    ├── S4_enhanced.py               # (template - universal motor)
    ├── S5_enhanced.py               # ✓ Series motor hoist
    └── s*_results.png               # Output plots
```

## Completed Models

### Fully Implemented ✓
1. **C7/S1_enhanced.py** - Synchronous generator with field/damper windings
2. **C7/S4_enhanced.py** - PM synchronous motor with starting dynamics
3. **C8/S1_enhanced.py** - DC shunt generator with self-excitation
4. **C8/S2_enhanced.py** - DC motor direct-on-line starting
5. **C8/S3A_enhanced.py** - DC motor braking (plugging & dynamic)
6. **C8/S5_enhanced.py** - DC series motor hoist with regenerative braking

### Templates Available
- C7/S3, S3EIG, S5 (synchronous machines)
- C8/S3B, S4 (DC machines)

---

## Technical Notes

### dq0 Transformation
The synchronous machine models use the **rotor reference frame** where:
- d-axis lags q-axis by 90° (electrical)
- Rotor angle δ is measured from a fixed reference
- Park transformation: `[id, iq] = T(θ) * [ia, ib, ic]`

### Mutual Inductances
Pre-calculated mutual inductances for air-gap flux:
```python
xMQ = (1/xls + 1/xmq + 1/xplkq)**(-1)
xMD = (1/xls + 1/xmd + 1/xplf + 1/xplkd)**(-1)
```

### Magnetization Curves
DC machine models use cubic spline interpolation:
```python
from scipy.interpolate import interp1d
mag_curve = interp1d(If_data, Ea_data, kind='cubic', fill_value='extrapolate')
```

### Solver Settings
All simulations use `scipy.integrate.solve_ivp`:
- Method: RK45 (Runge-Kutta 4-5)
- Relative tolerance: 1e-5 to 1e-6
- Absolute tolerance: 1e-6 to 1e-8
- Max step: 1e-3 to 5e-3 seconds
- Dense output: enabled for smooth plotting

---

## Validation

Each simulation includes:
1. Parameter consistency checks
2. Initial condition calculation from steady-state phasors
3. Physical constraints (torque balance, power balance)
4. Event detection (zero speed, instability)
5. Energy balance verification

Compare results with original Simulink outputs for validation.

---

## Future Enhancements

Potential additions:
1. Complete S3, S3EIG (linearization, eigenvalue analysis)
2. Complete S5 (2x3 phase machine)
3. Complete S3B (regenerative braking separate)
4. Complete S4 (universal motor)
5. Add control systems (AVR, governor)
6. Multi-machine simulations
7. Grid connection models
8. Real-time parameter variation
9. GUI for parameter input
10. Animation of phasor diagrams

---

## References

- Original MDL files: C7/*.MDL, C8/*.MDL
- Parameter files: set*.py, m*.py
- Theory: Krause, "Analysis of Electric Machinery"

---

**Generated:** 2026-03-06
**Author:** Claude Sonnet 4.5 + Human collaboration
**License:** Same as original project
