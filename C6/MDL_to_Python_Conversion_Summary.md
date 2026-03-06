# Simulink MDL to Python Conversion Summary

## Overview
This document summarizes the conversion of Simulink `.MDL` files for induction machine simulations to Python using `scipy.integrate.solve_ivp`. All models use parameters from the 20 HP induction motor defined in `p20hp.py`.

## Converted Models

### 1. S1.MDL → S1_stationary_frame.py
**Description:** Induction machine in stationary reference frame (abc → qd0)

**Reference Frame:** Stationary (qd0)

**State Variables:**
- `psi_qs`: q-axis stator flux linkage
- `psi_ds`: d-axis stator flux linkage
- `psi_qr'`: q-axis rotor flux linkage (referred to stator)
- `psi_dr'`: d-axis rotor flux linkage (referred to stator)
- `wr/wb`: normalized rotor speed

**Key Equations Extracted from MDL:**
```
dpsi_qs/dt = wb*(psi_mq + (rs/xls)*(vqs - psi_qs))
dpsi_ds/dt = wb*(psi_md + (rs/xls)*(vds - psi_ds))
dpsi_qr'/dt = wb*((wr/wb)*psi_dr' + (rpr/xplr)*(psi_mq - psi_qr'))
dpsi_dr'/dt = wb*(-(wr/wb)*psi_qr' + (rpr/xplr)*(psi_md - psi_dr'))

psi_mq = xM*(psi_qs/xls + psi_qr'/xplr)
psi_md = xM*(psi_ds/xls + psi_dr'/xplr)

iqs = (psi_qs - psi_mq)/xls
ids = (psi_ds - psi_md)/xls

Te = Tfactor*(psi_qs*ids - psi_ds*iqs)
```

**Transformations Used:**
- Clarke (abc → qd0):
  - `vqs = (2/3)*(vas - (vbs+vcs)/2)`
  - `vds = (vcs - vbs)/sqrt(3)`
- Inverse Clarke (qd0 → abc):
  - `ias = iqs`
  - `ibs = -(iqs + sqrt(3)*ids)/2`
  - `ics = -(iqs - sqrt(3)*ids)/2`

**Simulation:** Balanced three-phase operation with load step at t=1s

---

### 2. S4EIG.MDL → S4EIG_synchronous_frame.py
**Description:** Induction machine in synchronous reference frame for eigenvalue analysis

**Reference Frame:** Synchronous (rotating at we = wb)

**State Variables:**
- `psi_qs^e`: q-axis stator flux linkage (synchronous frame)
- `psi_ds^e`: d-axis stator flux linkage (synchronous frame)
- `psi_qr'^e`: q-axis rotor flux linkage (synchronous frame, referred)
- `psi_dr'^e`: d-axis rotor flux linkage (synchronous frame, referred)
- `wr/wb`: normalized rotor speed

**Key Equations Extracted from MDL:**
```
dpsi_qs^e/dt = wb*(psi_mq^e + (we/wb)*psi_ds^e + (rs/xls)*(vqs^e - psi_qs^e))
dpsi_ds^e/dt = wb*(psi_md^e - (we/wb)*psi_qs^e + (rs/xls)*(vds^e - psi_ds^e))
dpsi_qr'^e/dt = wb*((wr/wb - we/wb)*psi_dr'^e + (rpr/xplr)*(psi_mq^e - psi_qr'^e))
dpsi_dr'^e/dt = wb*(-(wr/wb - we/wb)*psi_qr'^e + (rpr/xplr)*(psi_md^e - psi_dr'^e))

Te = Tfactor*(psi_qs^e*ids^e - psi_ds^e*iqs^e)
```

**Features:**
- DC steady-state values in synchronous frame
- Better for eigenvalue/stability analysis
- Voltage aligned with d-axis for simplicity

---

### 3. S4STP.MDL → S4STP_step_response.py
**Description:** Step response analysis in synchronous frame

**Reference Frame:** Synchronous (rotating at we = wb)

**Same state variables as S4EIG**

**Special Features:**
- Voltage step input at t=1.0s (Vm → Vm+1V)
- Constant mechanical load (Tmech = -Tb)
- Uses Radau solver (stiff system, equivalent to MATLAB's ode15s)
- Detailed transient response analysis

**Simulation Configuration:**
- `tstop = 1.2s`
- `max_step = 0.0005s`
- `rtol = 1e-6, atol = 1e-6`

---

### 4. S5A.MDL → S5A_neutral_voltage.py
**Description:** Induction machine with neutral voltage (zero-sequence component)

**Reference Frame:** Stationary (qd0 with zero-sequence)

**State Variables:** Same as S1, plus algebraic zero-sequence

**Key Equations:**
```
v0s = (vas + vbs + vcs)/3  # Zero-sequence voltage
i0s = v0s/rs  # Zero-sequence current (for star with neutral)

# Inverse Clarke with zero-sequence:
ias = iqs + i0s
ibs = -(iqs + sqrt(3)*ids)/2 + i0s
ics = -(iqs - sqrt(3)*ids)/2 + i0s
```

**Features:**
- Models neutral connection
- Can handle unbalanced voltage sources
- Zero-sequence path allows ground currents

---

### 5. S5B.MDL → S5B_unbalanced_load.py
**Description:** Induction machine with unbalanced rectifier loads

**Reference Frame:** Stationary (qd0)

**Special Features:**
- Nonlinear loads per phase (diode rectifiers)
- Different load resistances: Ra=10Ω, Rb=15Ω, Rc=12Ω
- Sign function models rectifier behavior: `vload = sign(i) * |i| * Rload`
- Fan-type mechanical load: `Tmech ∝ speed²`

**Load Model:**
```python
def sign_function(x):
    return 1.0 if x > 0 else (-1.0 if x < 0 else 0.0)

vload_a = sign_function(ias) * abs(ias) * Rload_a
vas_terminal = vas_source - vload_a
```

**Analysis:**
- Current unbalance calculation
- Torque ripple quantification
- RMS current tracking per phase

---

### 6. S6.MDL → S6_single_phase.py
**Description:** Single-phase induction motor with auxiliary winding

**Reference Frame:** Asymmetric d-q (different parameters per axis)

**State Variables:**
- `psi'_ds`: d-axis stator flux linkage (main winding)
- `psi_qr'`: q-axis rotor flux linkage
- `psi_dr'`: d-axis rotor flux linkage
- `wr/wb`: normalized rotor speed

**Key Parameters:**
```python
# Main winding (d-axis)
rpds = rs * 1.2
xplds = xls * 1.1
xMd = xm * 0.9

# Auxiliary winding (q-axis)
rqs = rs * 1.5
xlqs = xls * 1.3
xMq = xm * 0.7  # Lower due to asymmetry
```

**Key Equations from MDL:**
```
dpsi'_ds/dt = wb*(psi_md + (rpds/xplds)*(v'_ds - psi'_ds))
dpsi_qr'/dt = wb*((wr/wb)*psi_dr' + (rpr/xplr)*(psi_mq - psi_qr'))
dpsi_dr'/dt = wb*(-(wr/wb)*psi_qr' + (rpr/xplr)*(psi_md - psi_dr'))

psi_md = xMd*(psi'_ds/xplds + psi_dr'/xplr)
psi_mq = xMq*(psi_qs/xlqs + psi_qr'/xplr)

Te = Tfactor*(psi'_ds*idr - psi_dr*i'_ds)
```

**Starting Mechanism:**
- Auxiliary winding active for t < 0.5s (phase-shifted voltage)
- Centrifugal switch opens at t = 0.5s
- Continues running on main winding only

---

## Common Elements Across All Models

### State-Space Formulation
All models use flux linkages as state variables rather than currents because:
1. Natural choice for induction machines
2. Voltage equations integrate directly to flux
3. Avoids algebraic loops in current-based models

### Torque Equation
```python
Te = Tfactor * (psi_qs * ids - psi_ds * iqs)
# where Tfactor = (3*P)/(4*wb)
```

### Rotor Dynamics
```python
dwr_wb/dt = (Te - Tmech) / (2*H*wb)
# where H = J*wbm²/(2*Sb) is the inertia constant
```

### Parameters from p20hp.py
- `rs = 0.1062 Ω` - stator resistance
- `xls = 0.2145 Ω` - stator leakage reactance
- `rpr = 0.0764 Ω` - rotor resistance (referred)
- `xplr = 0.2145 Ω` - rotor leakage reactance (referred)
- `xm = 5.8339 Ω` - magnetizing reactance
- `xM = 1/(1/xm + 1/xls + 1/xplr)` - mutual reactance
- `wb = 2π*60 rad/s` - base electrical frequency
- `wbm = 2*wb/P` - base mechanical frequency (P=4 poles)
- `Vm = 220*sqrt(2/3) V` - phase voltage magnitude
- `J = 2.8 kg·m²` - rotor inertia
- `H = 0.5425 s` - inertia constant

## Solver Configurations

| Model | Python Solver | MATLAB Equivalent | rtol | atol | max_step |
|-------|---------------|-------------------|------|------|----------|
| S1 | RK45 | ode113 | 1e-6 | 1e-5 | 1e-3 |
| S4EIG | RK45 | ode45 | 1e-3 | 1e-6 | 10 |
| S4STP | Radau | ode15s | 1e-6 | 1e-6 | 5e-4 |
| S5A | RK45 | ode113 | 1e-6 | 1e-5 | 1e-2 |
| S5B | Radau | ode15s | 5e-6 | 1e-6 | 5e-3 |
| S6 | Radau | ode15s | 1e-6 | 1e-6 | 1e-2 |

**Solver Notes:**
- **RK45**: Explicit Runge-Kutta for non-stiff systems
- **Radau**: Implicit solver for stiff systems (equivalent to ode15s)

## dq0 Reference Frame Theory

### Clarke Transformation (abc → qd0)
For balanced three-phase systems:
```
[vqs]   [2/3  -1/3  -1/3] [vas]
[vds] = [0   1/√3  -1/√3] [vbs]
[v0s]   [1/3   1/3   1/3] [vcs]
```

Simplified (power-invariant):
```
vqs = (2/3)*(vas - (vbs+vcs)/2)
vds = (vcs - vbs)/√3
v0s = (vas + vbs + vcs)/3
```

### Synchronous Reference Frame
Transformation from stationary to synchronous frame rotating at `we`:
```
[vqs^e]   [cos(θe)  sin(θe)] [vqs]
[vds^e] = [-sin(θe) cos(θe)] [vds]

where θe = ∫we dt
```

In steady-state synchronous frame:
- AC quantities in stationary frame → DC in synchronous frame
- Easier for control design and stability analysis
- Used in S4EIG and S4STP models

## Running the Simulations

### Prerequisites
```bash
pip install numpy scipy matplotlib
```

### Execution
```bash
cd /home/rodo/Maquinas/C6

# Run individual simulations
python S1_stationary_frame.py
python S4EIG_synchronous_frame.py
python S4STP_step_response.py
python S5A_neutral_voltage.py
python S5B_unbalanced_load.py
python S6_single_phase.py
```

### Expected Outputs
Each script generates:
1. Console output with simulation progress and final values
2. Multi-panel matplotlib figure showing:
   - Flux linkages
   - Currents (phase and/or dq)
   - Electromagnetic torque
   - Rotor speed
3. Saved PNG file in `/home/rodo/Maquinas/C6/`

## Validation

### Comparison with Simulink
Key validation points:
1. **Steady-state values**: Slip, torque, current should match rated values
2. **Transient response**: Rise time, overshoot in step responses
3. **Frequency content**: Current harmonics in unbalanced cases
4. **Starting performance**: Torque-speed curve for single-phase motor

### Typical Results
- Rated slip: ~2.87%
- Rated speed: ~1748 RPM (for 4-pole, 60 Hz)
- Rated torque: ~81.7 Nm
- Starting torque (single-phase): ~0.5-1.5 pu

## References

### Equations Source
All equations extracted from Simulink Fcn blocks using pattern:
```
Expr    "equation_string"
```

### Mathematical Foundation
- Krause, P.C., Wasynczuk, O., Sudhoff, S.D. "Analysis of Electric Machinery and Drive Systems"
- Park's transformation for reference frame theory
- Flux linkage state-space model for induction machines

## File Structure
```
/home/rodo/Maquinas/C6/
├── p20hp.py                      # 20 HP motor parameters
├── S1.MDL                        # Original Simulink file
├── S1_stationary_frame.py        # Python conversion
├── S1_results.png                # Output plot
├── S4EIG.MDL
├── S4EIG_synchronous_frame.py
├── S4EIG_results.png
├── S4STP.MDL
├── S4STP_step_response.py
├── S4STP_results.png
├── S5A.MDL
├── S5A_neutral_voltage.py
├── S5A_results.png
├── S5B.MDL
├── S5B_unbalanced_load.py
├── S5B_results.png
├── S6.MDL
├── S6_single_phase.py
├── S6_results.png
└── MDL_to_Python_Conversion_Summary.md
```

## Conversion Methodology

### Parser Usage
The `mdl_parser.py` tool was used to:
1. Extract block structure and types
2. Identify Fcn blocks containing equations
3. Parse integrator initial conditions
4. Map connections between blocks

### Manual Implementation
Due to complexity, equations were manually implemented:
1. Fcn block expressions extracted via grep
2. State equations reconstructed from block diagram
3. Algebraic equations (currents from fluxes) implemented
4. Transformations (Clarke, Park) coded explicitly

### Key Challenges
1. **Subsystem hierarchy**: Nested blocks required careful mapping
2. **Mux/Demux blocks**: Vector signal routing tracked manually
3. **Nonlinear blocks**: Sign functions, absolute value for S5B/S6
4. **Reference frames**: Careful alignment of stationary vs synchronous
5. **Initial conditions**: Steady-state pre-calculation for stability

## Future Enhancements

### Potential Additions
1. **Control systems**: Add voltage/frequency control loops
2. **Saturation**: Include magnetic saturation effects
3. **Parameter estimation**: Fit parameters to experimental data
4. **Real-time simulation**: Port to real-time frameworks
5. **Optimization**: Vectorize calculations for speed

### Validation Suggestions
1. Compare with commercial tools (PSCAD, PLECS)
2. Validate against laboratory measurements
3. Perform sensitivity analysis on parameters
4. Test edge cases (deep saturation, very light load)

---

**Conversion completed:** 2026-03-06
**Tool used:** `/home/rodo/Maquinas/tools/mdl_parser.py` (parsing) + manual implementation
**Target framework:** Python 3.x with SciPy
**Motor parameters:** 20 HP, 4-pole, 60 Hz induction machine
