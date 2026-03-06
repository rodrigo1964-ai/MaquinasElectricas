# C4 Transformer Models - Quick Reference

## 🚀 Quick Start

```bash
cd /home/rodo/Maquinas/C4

# Run any model directly:
python3 S1C.py   # Single-phase with full saturation
python3 S4.py    # Three-phase bank
python3 SMG.py   # Magnetization validation

# Test all models:
python3 test_transformers.py
```

---

## 📊 Models at a Glance

| Model | Type | Saturation | States | Use Case |
|-------|------|------------|--------|----------|
| **S1A** | Single-phase | None | 2 | Basic analysis, education |
| **S1B** | Single-phase | Piecewise | 2 | Moderate saturation, fast |
| **S1C** | Single-phase | Full curve | 2 | Accurate nonlinear analysis |
| **S4** | Three-phase | Full curve | 6 | Power systems, 3φ studies |
| **SMG** | Validation | N/A | 0 | Curve verification |

---

## 🔧 Basic Usage Patterns

### Pattern 1: Run Pre-built Example
```python
# Just run the file - it has built-in example
python3 S1C.py
# Enter load resistance when prompted
```

### Pattern 2: Import and Customize
```python
from S1C import simulate_transformer_full_saturation
from m1 import *  # Load all parameters

# Custom load
RH = 5 * Zb
sol = simulate_transformer_full_saturation(RH, params, t_stop=0.3)
```

### Pattern 3: Access Results
```python
results = extract_variables(sol, RH, params)
print(f"Max current: {np.max(np.abs(results['i1']))} A")
```

---

## 📐 Key Equations

### Transformer ODEs (all models)
```
dψ1/dt = ωb·(v1 - (r1/xl1)·(ψ1 - ψm))
dψ2'/dt = ωb·(v2' - (r2'/xl2')·(ψm - ψ2'))
```

### Mutual Flux (no saturation)
```
ψm = xM·(ψ1/xl1 + ψ2'/xl2')
```

### Mutual Flux (with saturation)
```
ψm = xM·(ψ1/xl1 + ψ2'/xl2' - Dpsi/xm)
where Dpsi = f(ψm) from lookup table
```

### Currents
```
i1 = (ψ1 - ψm) / xl1
i2' = (ψ2' - ψm) / xl2'
```

---

## 🎯 Common Tasks

### Task: Open Circuit Test
```python
RH = 100 * Zb  # Very high resistance
# Observe magnetizing current and flux
```

### Task: Short Circuit Test
```python
RH = 0.0  # Zero resistance
# Observe large currents, small flux
```

### Task: Rated Load Test
```python
RH = Zb  # Base impedance = rated load
# Observe normal operation
```

### Task: Saturation Study
```python
# Vary voltage amplitude
Vpk_test = 1.5 * Vpk  # 150% overvoltage
# Observe Dpsi and harmonic distortion
```

### Task: Three-Phase Neutral Study
```python
# Vary neutral grounding
for Rn in [0.01, 1.0, 100.0, 1e6]:
    sol = simulate_three_phase_transformer(Rn, Rload, params)
    # Observe vnG variation
```

---

## 📦 Parameter Quick Reference

### From m1.py (Single-Phase)
```python
Vrated = 120 V      # RMS voltage
Srated = 1500 VA    # Apparent power
Frated = 60 Hz      # Frequency
Zb = 9.6 Ω         # Base impedance
wb = 377 rad/s     # Angular frequency
Vpk = 169.7 V      # Peak voltage

r1 = 0.25 Ω        # Primary resistance
rp2 = 0.134 Ω      # Secondary resistance (referred)
xl1 = 0.056 Ω      # Primary leakage
xpl2 = 0.056 Ω     # Secondary leakage (referred)
xm = 708.8 Ω       # Magnetizing reactance

Dpsi[127]          # Saturation correction array
psisat[127]        # Flux array for lookup

tstop = 0.2 s      # Simulation time
```

### From m4.py (Three-Phase)
```python
# Same electrical params as m1.py, plus:
Rload = 9.6 Ω      # Per-phase load
tstop = 1.2 s      # Longer simulation
```

---

## 🔍 Output Variables

### S1A, S1B, S1C (Single-Phase)
```python
results = extract_variables(sol, params)

results['t']      # Time array
results['psi1']   # Primary flux linkage
results['psi2p']  # Secondary flux linkage (referred)
results['psim']   # Mutual flux linkage
results['i1']     # Primary current
results['i2p']    # Secondary current (referred)
```

### S1C Additional
```python
results['v1']     # Primary voltage
results['v2p']    # Secondary voltage (referred)
results['Dpsi']   # Saturation correction
```

### S4 (Three-Phase)
```python
results = extract_variables(sol, Rn, Rload, params)

results['vAB'], results['vBC'], results['vCA']  # Primary line voltages
results['vab'], results['vbc'], results['vca']  # Secondary line voltages
results['iA'], results['iB'], results['iC']     # Primary line currents
results['ia'], results['ib'], results['ic']     # Secondary line currents
results['vnG']                                   # Neutral voltage
```

### SMG (Magnetization)
```python
results = simulate_magnetization_validation(params)

results['v']            # Applied voltage
results['psi']          # Flux linkage
results['i']            # Current
results['error_rms']    # Error from RMS curve
results['error_inst']   # Error from instantaneous curve
```

---

## 🎨 Plotting

### Use Built-in Plot Functions
```python
from m1 import plot_results

# For single-phase (format: [t, v1, v2', psim, i1, i2'])
plot_results(y_array, RH)
```

### Custom Plotting
```python
import matplotlib.pyplot as plt

plt.figure()
plt.plot(results['t'], results['i1'])
plt.xlabel('Time (s)')
plt.ylabel('Primary Current (A)')
plt.grid(True)
plt.show()
```

### Three-Phase Plotting
```python
from m4 import plot_results

# Format: [t, vAB, vab, iA, ia, avg_primary, avg_secondary, vnG]
plot_results(y_array, Rn)
```

---

## ⚙️ Solver Settings

### Default Settings (Already Optimized)
```python
# S1A
rtol=1e-8, atol=1e-6, max_step=1e-3

# S1B
rtol=1e-5, atol=1e-5, max_step=0.01

# S1C
rtol=5e-5, atol=5e-5, max_step=1e-3

# S4
rtol=1e-5, atol=1e-5, max_step=1e-2

# SMG
rtol=1e-5, atol=1e-6
```

### If Convergence Issues
```python
# Tighten tolerances
rtol=1e-6, atol=1e-7

# Or reduce max step
max_step=1e-4
```

---

## 🐛 Common Issues

### Issue: "RuntimeWarning: invalid value in interpolation"
**Cause:** Flux exceeds saturation curve range
**Fix:** Check voltage levels or extend Dpsi/psisat arrays

### Issue: Slow simulation
**Cause:** Too tight tolerances or too small max_step
**Fix:** Relax tolerances slightly or increase max_step

### Issue: Oscillations in results
**Cause:** Saturation feedback instability
**Fix:** Reduce max_step for better resolution

### Issue: Import errors
**Cause:** Python path not set
**Fix:** Add to path: `sys.path.insert(0, '/home/rodo/Maquinas/C4')`

---

## 📚 File Locations

```
All models:        /home/rodo/Maquinas/C4/
Parameters:        /home/rodo/Maquinas/C4/m1.py, m4.py
Test suite:        /home/rodo/Maquinas/C4/test_transformers.py
Documentation:     /home/rodo/Maquinas/C4/TRANSFORMER_MODELS.md
This guide:        /home/rodo/Maquinas/C4/QUICK_REFERENCE.md
```

---

## 🧪 Testing Checklist

Before using models in production:

- [ ] Run `python3 test_transformers.py` → All tests pass
- [ ] Run individual model examples → Produces plots
- [ ] Verify parameter loading → No import errors
- [ ] Check output ranges → Reasonable values
- [ ] Compare with theory → Matches expectations

---

## 💡 Tips

1. **Start with S1C** - Most complete, easiest to understand
2. **Use test file** - Verify setup before custom analysis
3. **Check units** - All SI units (V, A, Ω, Wb-turns, s)
4. **Save results** - Use `np.savez` for later analysis
5. **Batch runs** - Loop over parameters, disable plotting
6. **FFT analysis** - Use `fftplot.py` for harmonics
7. **Modify params** - Edit m1.py/m4.py for different transformers

---

## 🔗 Related Files

- `fftplot.py` - FFT analysis of any variable
- `mgplt.py` - Magnetization curve plotting
- `mginit.py` - Curve conversion utility
- Original `.M` files - MATLAB references
- `.MDL` files - Simulink diagrams

---

## 📖 Full Documentation

For detailed information, see:
- **TRANSFORMER_MODELS.md** - Complete technical documentation
- **IMPLEMENTATION_STATUS.md** - Development and verification details
- **README.md** - Original project overview

---

## ⚡ One-Line Commands

```bash
# Run with default settings
python3 S1C.py <<< "960"  # RH = 960 Ω

# Test specific model
python3 test_transformers.py --model S4

# Interactive Python
python3 -i S1C.py  # Stay in REPL after execution

# Time execution
time python3 test_transformers.py --no-plot
```

---

**End of Quick Reference**

For questions or issues, refer to the full documentation or examine the well-commented source code.
