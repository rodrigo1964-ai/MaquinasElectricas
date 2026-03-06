# MATLAB to Python Conversion - C6 Directory

## Conversion Summary

All MATLAB `.M` files in `/home/rodo/Maquinas/C6/` have been converted to Python `.py` files.

### Parameter Files (Fully Converted)

These files contain machine parameters and are fully functional in Python:

1. **p1hp.py** - 1 HP three-phase induction motor parameters
2. **p20hp.py** - 20 HP three-phase induction motor parameters
3. **psph.py** - Single-phase (1/4 HP) induction motor parameters

### Analysis/Plotting Scripts (Fully Converted)

These files contain computational analysis and plotting, fully functional:

4. **m1.py** - Project 1&3: Setup and plotting for induction machine simulation
5. **m2fig.py** - Project 2: Torque-speed and current-speed curves for motor starting
6. **m4.py** - Project 4: Linearized analysis setup (requires scipy/control for full functionality)
7. **m4stp.py** - Project 4: Step response simulation setup
8. **m4ustp.py** - Project 4: Unit step response plotting (uses scipy.signal)
9. **m5.py** - Project 5: Non-zero neutral voltage conditions setup and plotting
10. **m6.py** - Project 6: Single-phase motor torque-speed calculation and plotting

### Simulink Model Stubs (Documentation Only)

These files are stubs with implementation guidance. The original `.M` files were Simulink block diagrams that require numerical ODE implementation in Python:

11. **s1.py** - Induction machine in stationary reference frame
12. **s4eig.py** - Induction machine in synchronous frame (for eigenvalue analysis)
13. **s4stp.py** - Step response simulation model
14. **s5a.py** - Machine with neutral voltage (variant A)
15. **s5b.py** - Machine with neutral voltage (variant B)
16. **s6.py** - Single-phase induction motor with capacitor switching

## Usage Examples

### Parameter Files
```python
# Import motor parameters
from p1hp import *
print(f"Motor rating: {Sb} VA")
print(f"Base torque: {Tb} Nm")
```

### Analysis Scripts
```python
# Run torque-speed analysis
import m2fig  # This will generate and display the plots

# Or for simulation setup and plotting:
from m1 import *
# ... run simulation to generate y array ...
plot_results(y)
```

### Single-Phase Motor Analysis
```python
# Steady-state characteristics
import m6  # This will display torque-speed curves
```

## Dependencies

Required Python packages:
- `numpy` - Array operations and numerical calculations
- `matplotlib` - Plotting and visualization
- `scipy` - Signal processing and integration (for m4ustp.py and ODE implementations)

Optional (for full control system analysis):
- `python-control` - Transfer functions, root locus, linearization

Install dependencies:
```bash
pip install numpy matplotlib scipy
pip install control  # Optional, for advanced control analysis
```

## Implementation Notes

### Simulink Models (S*.py files)

The original Simulink models contain block diagrams that define differential equations for motor dynamics. To fully implement these in Python, you need to:

1. **Use `scipy.integrate.solve_ivp`** for ODE integration
2. **Implement the state equations** from the Simulink blocks:
   - Flux linkage dynamics (psi)
   - Current calculations
   - Torque computation
   - Rotor speed dynamics

3. **Example structure**:
```python
from scipy.integrate import solve_ivp
import numpy as np
from m1 import *  # Load parameters

def motor_dynamics(t, x, params):
    # x = [psids, psidr', psiqs, psiqr', wr/wb]
    # Unpack parameters and state
    # Compute derivatives
    # Return dx/dt
    pass

# Initial conditions
x0 = [Psidso, Psipdro, Psiqso, Psipqro, wrbywbo]

# Solve
sol = solve_ivp(motor_dynamics, [0, tstop], x0,
                method='RK45', dense_output=True)
```

### Key Differences from MATLAB

1. **Array indexing**: Python uses 0-based indexing (MATLAB uses 1-based)
2. **Complex numbers**: Use `1j` instead of MATLAB's `j`
3. **Matrix operations**: Use `@` operator or `np.dot()` for matrix multiplication
4. **Integration**: Use `scipy.integrate.solve_ivp` instead of MATLAB's `ode45`
5. **Plotting**: Use `matplotlib.pyplot` instead of MATLAB's `plot`

### Coordinate Transformations

The induction motor models use several reference frames:
- **abc**: Three-phase stationary (natural coordinates)
- **qd0**: Synchronous or stationary reference frame
- **Transformations**: Implemented in the Simulink subsystems

## Project Descriptions

- **Project 1**: Three-phase induction motor starting and loading
- **Project 2**: Starting methods analysis (torque-speed characteristics)
- **Project 3**: Similar to Project 1
- **Project 4**: Linearized analysis and transfer functions
- **Project 5**: Unbalanced conditions and neutral voltage
- **Project 6**: Single-phase induction motor with capacitor start/run

## File Naming Convention

- Original MATLAB files: `*.M` (uppercase)
- Converted Python files: `*.py` (lowercase)

## References

These simulations are based on induction machine models from electrical machines textbooks, likely:
- Krause, P.C., et al., "Analysis of Electric Machinery and Drive Systems"

The single-phase motor parameters reference:
- Krause, P. C., "Simulation of Unsymmetrical Induction Machinery,"
  IEEE Trans. on Power Apparatus, Vol.PAS-84, No.11, November 1965.
