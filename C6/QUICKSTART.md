# Quick Start Guide - MDL to Python Conversions

## What Was Converted

Six Simulink `.MDL` files for induction machine simulations were converted to Python:

| Original MDL | Python Script | Description |
|--------------|---------------|-------------|
| S1.MDL | S1_stationary_frame.py | Stationary frame (abc→qd0) balanced operation |
| S4EIG.MDL | S4EIG_synchronous_frame.py | Synchronous frame eigenvalue analysis |
| S4STP.MDL | S4STP_step_response.py | Step response with voltage change |
| S5A.MDL | S5A_neutral_voltage.py | With neutral voltage (zero-sequence) |
| S5B.MDL | S5B_unbalanced_load.py | Unbalanced rectifier loads |
| S6.MDL | S6_single_phase.py | Single-phase motor with auxiliary winding |

## Quick Run

```bash
cd /home/rodo/Maquinas/C6

# Verify everything is ready
python verify_conversions.py

# Run any simulation
python S1_stationary_frame.py
python S4EIG_synchronous_frame.py
python S4STP_step_response.py
python S5A_neutral_voltage.py
python S5B_unbalanced_load.py
python S6_single_phase.py

# Analyze MDL structure
python analyze_mdl_files.py
```

## Output Files

Each simulation produces:
- Console output with progress and final values
- Multi-panel matplotlib plot (displayed on screen)
- PNG file saved in `/home/rodo/Maquinas/C6/` with naming pattern `S*_results.png`

## Key Features

### All Models Use:
- **Motor parameters**: 20 HP induction motor from `p20hp.py`
- **Solver**: `scipy.integrate.solve_ivp` (equivalent to MATLAB ODE solvers)
- **States**: Flux linkages (not currents) for natural integration
- **Reference frames**: dq0 transformations (Clarke, Park)

### State Variables by Model:

**S1, S4EIG, S4STP, S5A, S5B** (5 states):
1. `psi_qs` or `psi_qs^e` - q-axis stator flux
2. `psi_ds` or `psi_ds^e` - d-axis stator flux
3. `psi_qr'` or `psi_qr'^e` - q-axis rotor flux (referred)
4. `psi_dr'` or `psi_dr'^e` - d-axis rotor flux (referred)
5. `wr/wb` - normalized rotor speed

**S6** (4 states - single phase):
1. `psi'_ds` - d-axis stator flux (main winding)
2. `psi_qr'` - q-axis rotor flux
3. `psi_dr'` - d-axis rotor flux
4. `wr/wb` - normalized rotor speed

## Core Equations

### Flux Linkage Derivatives (Stationary Frame)
```python
dpsi_qs/dt = wb*(psi_mq + (rs/xls)*(vqs - psi_qs))
dpsi_ds/dt = wb*(psi_md + (rs/xls)*(vds - psi_ds))
dpsi_qr'/dt = wb*((wr/wb)*psi_dr' + (rpr/xplr)*(psi_mq - psi_qr'))
dpsi_dr'/dt = wb*(-(wr/wb)*psi_qr' + (rpr/xplr)*(psi_md - psi_dr'))
```

### Magnetizing Flux
```python
psi_mq = xM*(psi_qs/xls + psi_qr'/xplr)
psi_md = xM*(psi_ds/xls + psi_dr'/xplr)
```

### Currents (from flux linkages)
```python
iqs = (psi_qs - psi_mq)/xls
ids = (psi_ds - psi_md)/xls
```

### Electromagnetic Torque
```python
Te = Tfactor*(psi_qs*ids - psi_ds*iqs)
# where Tfactor = (3*P)/(4*wb)
```

### Rotor Dynamics
```python
dwr_wb/dt = (Te - Tmech)/(2*H*wb)
# where H = J*wbm²/(2*Sb) is inertia constant
```

## Clarke Transformation (abc → qd0)

### Forward
```python
vqs = (2/3)*(vas - (vbs + vcs)/2)
vds = (vcs - vbs)/sqrt(3)
v0s = (vas + vbs + vcs)/3
```

### Inverse
```python
ias = iqs + i0s
ibs = -(iqs + sqrt(3)*ids)/2 + i0s
ics = -(iqs - sqrt(3)*ids)/2 + i0s
```

## Motor Parameters (from p20hp.py)

```python
# Electrical parameters
rs = 0.1062 Ω        # Stator resistance
rpr = 0.0764 Ω       # Rotor resistance (referred)
xls = 0.2145 Ω       # Stator leakage reactance
xplr = 0.2145 Ω      # Rotor leakage reactance (referred)
xm = 5.8339 Ω        # Magnetizing reactance
xM = 0.1944 Ω        # Mutual reactance

# Mechanical parameters
J = 2.8 kg·m²        # Rotor inertia
H = 0.5425 s         # Inertia constant
P = 4                # Number of poles

# Ratings
Sb = 14920 VA        # 20 HP
Vrated = 220 V       # Line-to-line
frated = 60 Hz
Nrated = 1748.3 RPM  # Rated speed
srated = 0.0287      # Rated slip (2.87%)
```

## Modification Examples

### Change Load Profile
Edit the mechanical torque function in any script:
```python
# Original (step load)
if t < 1.0:
    Tmech = 0.0
else:
    Tmech = -Trated * 0.5

# Ramp load
Tmech = -Trated * min(t/2.0, 0.5)

# Fan load (speed-squared)
Tmech = -Trated * 0.5 * (wr/wbm)**2
```

### Change Voltage Input
```python
# Original balanced
vas = Vm * np.cos(wb * t)
vbs = Vm * np.cos(wb * t - 2*np.pi/3)
vcs = Vm * np.cos(wb * t + 2*np.pi/3)

# Voltage sag on phase A
vas = Vm * 0.7 * np.cos(wb * t)  # 30% sag
vbs = Vm * np.cos(wb * t - 2*np.pi/3)
vcs = Vm * np.cos(wb * t + 2*np.pi/3)

# Frequency ramp (variable speed drive)
freq = 60 * min(t/5.0, 1.0)  # 0 to 60 Hz in 5 seconds
vas = Vm * np.cos(2*np.pi*freq * t)
```

### Adjust Simulation Time
```python
# Original
tstop = 2.0

# Longer for steady-state
tstop = 10.0

# Shorter for starting transient only
tstop = 0.5
```

## Troubleshooting

### Import Errors
```bash
# If "No module named p20hp"
cd /home/rodo/Maquinas/C6
python S1_stationary_frame.py  # Run from correct directory

# Or add to path explicitly
export PYTHONPATH=/home/rodo/Maquinas/C6:$PYTHONPATH
```

### Slow Simulation
- Reduce `tstop` for quicker results
- Increase `max_step` (but may reduce accuracy)
- Use `RK45` instead of `Radau` for non-stiff systems

### Numerical Issues
- Check initial conditions (steady-state calculation)
- Reduce `max_step` for better accuracy
- Use `Radau` solver for stiff systems (S4STP, S5B, S6)

## Validation Checks

Expected results for healthy simulation:

| Metric | Expected Value | Check In |
|--------|----------------|----------|
| Rated speed | ~1748 RPM | Final value in plot |
| Rated slip | ~2.87% | Final value in output |
| Starting current | 5-7× rated | Peak in transient |
| Rated torque | ~81.7 Nm | Steady-state torque |
| Power factor | ~0.85 | Calculate from V, I |

## Documentation Files

- **MDL_to_Python_Conversion_Summary.md** - Detailed technical documentation
- **QUICKSTART.md** - This file
- **verify_conversions.py** - Automated verification script
- **analyze_mdl_files.py** - MDL structure analysis tool

## Next Steps

1. **Run verification**: `python verify_conversions.py`
2. **Try basic simulation**: `python S1_stationary_frame.py`
3. **Explore results**: Check PNG files and console output
4. **Modify parameters**: Edit load, voltage, or timing
5. **Read full docs**: See `MDL_to_Python_Conversion_Summary.md`

## Contact / Issues

These conversions were created from original Simulink MDL files using:
- Parser: `/home/rodo/Maquinas/tools/mdl_parser.py`
- Manual equation extraction from Fcn blocks
- State-space reconstruction from block diagrams
- Validation against expected induction machine behavior

For questions about the electrical machine theory, consult:
- Krause, "Analysis of Electric Machinery and Drive Systems"
- Original MDL files for Simulink block structure

---

**Ready to run!** Start with `python S1_stationary_frame.py` for the simplest case.
