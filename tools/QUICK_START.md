# Quick Start Guide - Enhanced Machine Simulations

## Installation

```bash
# Install required packages
pip install numpy scipy matplotlib
```

## Running Simulations

### C7 - Synchronous Machines

#### 1. Synchronous Generator (S1_enhanced.py)
```bash
cd /home/rodo/Maquinas/C7
python3 S1_enhanced.py
```
**What it does:** Simulates a synchronous generator with step change in field excitation at t=0.2s
**Output:** 9 plots showing angle, speed, currents, torque, power, flux linkages

#### 2. PM Synchronous Motor (S4_enhanced.py)
```bash
cd /home/rodo/Maquinas/C7
python3 S4_enhanced.py
```
**What it does:** Simulates PM motor starting from rest with constant load
**Output:** 9 plots showing speed, load angle, currents, torque, power, flux linkages, slip

---

### C8 - DC Machines

#### 1. Shunt Generator (S1_enhanced.py)
```bash
cd /home/rodo/Maquinas/C8
python3 S1_enhanced.py
```
**What it does:** Simulates self-excitation voltage build-up from residual magnetism
**Output:** 9 plots showing field current, back-EMF, terminal voltage, armature current, torque, power, magnetization curve

#### 2. Motor Starting (S2_enhanced.py)
```bash
cd /home/rodo/Maquinas/C8
python3 S2_enhanced.py
```
**What it does:** Direct-on-line starting from standstill, shows inrush current
**Output:** 9 plots showing current, speed, back-EMF, torque, power, characteristics, phase plane

#### 3. Braking Methods (S3A_enhanced.py)
```bash
cd /home/rodo/Maquinas/C8
python3 S3A_enhanced.py
```
**What it does:** Compares plugging vs dynamic braking from rated speed
**Output:** 9 plots comparing both methods: current, speed, torque, energy

#### 4. Series Motor Hoist (S5_enhanced.py)
```bash
cd /home/rodo/Maquinas/C8
python3 S5_enhanced.py
```
**What it does:** Simulates elevator/hoist in motoring and two braking modes
**Output:** 6 plots showing all three scenarios: speed, current, torque, characteristics

---

## Quick Modifications

### Change Simulation Time
```python
# In any *_enhanced.py file, modify:
t_stop = 5.0  # Change to desired time in seconds
```

### Change Initial Conditions
```python
# For synchronous machines:
P = 0.8  # Change real power (pu)
Q = 0.3  # Change reactive power (pu)

# For DC motors:
Ia0 = 0.0   # Initial current
wm0 = 0.0   # Initial speed (0 = standstill)
```

### Change Disturbances
```python
# Synchronous generator - step in field excitation:
Ex_time = np.array([0, 0.2, 0.2, 5])
Ex_value = np.array([Efo, Efo, 1.2*Efo, 1.2*Efo])  # 20% increase

# Synchronous generator - short circuit:
Vm_time = np.array([0, 0.1, 0.1, 0.2, 0.2, 5])
Vm_value = np.array([1, 1, 0, 0, 1, 1])  # Fault at t=0.1s for 0.1s

# DC motor - apply load during starting:
# In S2_enhanced.py, modify:
Tload = 0.5 * Trated  # Constant load instead of 0
```

### Change Machine Parameters
Edit the parameter files in each directory:

**C7 (Synchronous):**
- `set1.py` - Standard sync machine
- `set3a.py, set3b.py, set3c.py` - Other configs

**C8 (DC):**
- `m1.py` - Shunt generator with mag curve
- `m2.py` - Motor starting params
- `m3a.py` - Braking params
- `m5.py` - Series motor with mag curve

---

## Understanding the Output

### Synchronous Machine Plots

1. **Rotor Angle (δ)**: Should stabilize after disturbance. If grows unbounded → instability
2. **Rotor Speed (ω)**: Should return to 1.0 pu (synchronous). Oscillations show damping
3. **Field Current**: Controlled by excitation system
4. **dq Currents**: iq relates to real power, id to reactive power
5. **Torque**: Electromagnetic torque, should balance mechanical input
6. **Power (P, Q)**: Real and reactive power output
7. **Flux Linkages**: Internal states, show transient behavior
8. **Damper Fluxes**: Decay to zero at steady state (no damper current at sync speed)

### DC Machine Plots

1. **Armature Current (Ia)**: Peak during starting or braking, settles at load value
2. **Speed (RPM)**: Rise time for starting, decay for braking
3. **Back-EMF (Ea)**: Proportional to speed, opposes applied voltage
4. **Torque (Te)**: Peak at starting, decreases as speed increases (shunt motor)
5. **Power**: Shows efficiency, losses
6. **Torque-Speed Curve**: Operating characteristic of the machine

---

## Troubleshooting

### Simulation doesn't converge
- Reduce max_step: `max_step=1e-4` (instead of 1e-3)
- Increase tolerances: `rtol=1e-4, atol=1e-5`
- Check initial conditions (should be close to steady state)

### Instability / Divergence
**Synchronous machines:**
- Check if disturbance is too large
- Verify H (inertia) is reasonable
- Check xd, xq parameters

**DC machines:**
- Check if Ka (back-EMF constant) is correct
- Verify Ra, La values
- For series motor, ensure magnetization curve is defined for all Ia ranges

### Plot issues
```python
# If plot window doesn't appear:
import matplotlib
matplotlib.use('TkAgg')  # Add at top of file before importing pyplot

# If plots are too crowded:
fig.set_size_inches(18, 12)  # Increase figure size
```

### Import errors
```bash
# Make sure you're in the correct directory
cd /home/rodo/Maquinas/C7  # or C8

# Check if parameter files exist
ls set*.py m*.py

# If missing, check parent directory
ls ../*.py
```

---

## Example: Custom Scenario

### Synchronous Generator - Three-Phase Fault

Edit `C7/S1_enhanced.py`:

```python
# Around line 100, modify:
tstop = 2.0  # Shorter simulation

# Short circuit at t=0.1s for 3 cycles (3/60 = 0.05s)
Vm_time = np.array([0, 0.1, 0.1, 0.15, 0.15, tstop])
Vm_value = np.array([Vm, Vm, 0, 0, Vm, Vm])

# Keep field constant
Ex_time = np.array([0, tstop])
Ex_value = np.array([Efo, Efo])

# Keep mechanical torque constant
tmech_time = np.array([0, tstop])
tmech_value = np.array([Tmech, Tmech])

print("Simulating 3-phase fault at t=0.1s for 3 cycles")
```

### DC Motor - Starting with Load Ramp

Edit `C8/S2_enhanced.py`:

```python
# Inside dc_motor_starting_equations function:
def dc_motor_starting_equations(t, y):
    Ia, wm = y

    # ... existing code ...

    # Ramp load from 0 to full load over 0.3 seconds
    if t < 0.3:
        Tload = (t / 0.3) * Trated  # Linear ramp
    else:
        Tload = Trated

    # ... rest of function ...
```

---

## Performance Tips

### Faster Simulation
```python
# Reduce accuracy slightly
sol = solve_ivp(..., rtol=1e-4, atol=1e-5)  # Instead of 1e-6

# Increase max_step
max_step=5e-3  # Instead of 1e-3

# Use BDF for stiff problems (DC machines with high L/R)
method='BDF'  # Instead of 'RK45'
```

### Higher Accuracy
```python
# Tighter tolerances
rtol=1e-7, atol=1e-8

# Smaller max_step
max_step=1e-4

# Dense output for smooth plots
dense_output=True
```

---

## Exporting Results

### Save Data to File
```python
# Add after solving:
import pandas as pd

# Create dataframe
df = pd.DataFrame({
    'time': t,
    'current': Ia,
    'speed': wm_rpm,
    'torque': Te
})

# Save to CSV
df.to_csv('results.csv', index=False)
```

### Export Plot as PDF
```python
# Change the savefig line:
plt.savefig('results.pdf', format='pdf', dpi=300, bbox_inches='tight')
```

---

## Next Steps

1. **Run all 6 complete simulations** to verify they work
2. **Modify parameters** to match your specific machines
3. **Add custom disturbances** for your study cases
4. **Compare with Simulink** results if available
5. **Extend models** with control systems, grid models, etc.

---

## Support Files

- `CONVERSION_SUMMARY.md` - Detailed technical documentation
- `mdl_parser.py` - MDL file parser
- `dc_machine_converter.py` - DC templates
- `sync_machine_converter.py` - Sync templates
- `convert_all_mdl.py` - Batch converter

---

**Happy simulating!** 🔌⚡🔋
