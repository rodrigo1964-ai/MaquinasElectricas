# MATLAB to Python Conversion - C7 Directory

## Conversion Summary

All MATLAB .M files in the C7 directory have been converted to Python .py files.

## Converted Files

### Main Script Files (M*.M → *.py)
- **m1.M → m1.py** - Operating characteristics of synchronous machine (Projects 1 and 5)
- **m3.M → m3.py** - Linearized analysis of synchronous generator (Project 3)
- **m4.M → m4.py** - Permanent magnet synchronous motor (Project 4)
- **m5.M → m5.py** - 2x3 synchronous machine model with coupling (Project 5)
- **PLOT5C.M → plot5c.py** - Plotting script for Project 5 comparisons

### Simulink Model Files (S*.M → s*.py)
These are **STUB IMPLEMENTATIONS** - the original files are Simulink graphical models:

- **S1.M → s1.py** - Synchronous machine simulation model
- **S3EIG.M → s3eig.py** - Model for eigenvalue/linearization analysis
- **S3.M → s3.py** - Alternative synchronous machine model
- **S4.M → s4.py** - Permanent magnet motor simulation
- **S5.M → s5.py** - 2x3 coupled synchronous machine simulation

### Parameter Files (SET*.M → set*.py)
- **SET1.M → set1.py** - Machine parameters Set 1
- **SET3A.M → set3a.py** - Machine parameters Set 3A (2 coupling inductances)
- **SET3B.M → set3b.py** - Machine parameters Set 3B (1 coupling inductance)
- **SET3C.M → set3c.py** - Machine parameters Set 3C

## Key Conversion Details

### Python Libraries Used
- **numpy** - For mathematical operations (replaces MATLAB's matrix operations)
- **matplotlib.pyplot** - For plotting (replaces MATLAB's plot functions)
- **scipy.integrate** - For ODE solving (replaces Simulink integration)
- **scipy.signal** - For control system analysis (replaces MATLAB's control toolbox)

### Main Changes from MATLAB to Python

1. **Complex numbers**: `j` → `1j`
2. **Array indexing**: MATLAB 1-based → Python 0-based
3. **Array ranges**: `0:0.2:1` → `np.arange(0, 1.2, 0.2)`
4. **Matrix operations**: Use numpy arrays
5. **Plotting**: `plot()` → `plt.plot()`, `subplot()` → `plt.subplot()`
6. **User input**: `input()` with appropriate type conversion
7. **Execution**: `eval(setX)` → `exec(f'from {setX} import *')`

### Simulink Model Conversion Notes

The S*.M files are Simulink graphical block diagrams that define system dynamics. The Python stub implementations provide:

1. **State-space model functions** that implement the differential equations
2. **Simulation functions** using scipy's ODE solvers
3. **Helper functions** for coordinate transformations

**IMPORTANT**: The stub implementations contain the mathematical models but need to be integrated with the main scripts (m*.py) for full functionality. The original Simulink models had:
- Graphical block diagram interfaces
- Built-in integrators
- Scopes and visualization
- Interactive parameter tuning

The Python versions provide equivalent functionality through:
- State-space function definitions
- scipy.integrate.solve_ivp for time integration
- matplotlib for visualization
- Python scripts for parameter management

### How to Use the Converted Files

#### Example: Running m1.py
```python
# Execute the main script
python m1.py

# When prompted, enter parameter file name (without .py)
# Example: set1

# Follow the prompts to select disturbance type and parameters
```

#### Example: Using simulation models directly
```python
import numpy as np
from s1 import simulate_s1

# Set up parameters dictionary
params = {
    'wb': 2*np.pi*60,
    'rs': 0.0048,
    'xls': 0.215,
    # ... other parameters
}

# Define initial conditions
x0 = np.array([delta0, psiq0, psikq0, psid0, psif0, psikd0, slip0])

# Define input function
def inputs(t):
    return np.array([vqe, vde, Ef, Tmech])

# Simulate
t_span = (0, 5)
t_eval = np.linspace(0, 5, 1000)
sol = simulate_s1(x0, params, inputs, t_span, t_eval)
```

### Missing Functionality

The following MATLAB/Simulink features need additional work:

1. **trim function** - Finding steady-state operating points (used in m3.py)
2. **linmod function** - Linearization of nonlinear models (used in m3.py)
3. **Full integration** between main scripts and simulation models
4. **Interactive plotting** with callbacks (keyboard mode in MATLAB)
5. **Complete ODE system** verification against original Simulink models

### Recommended Next Steps

1. **Test parameter files**: Verify all parameters load correctly
2. **Implement trim function**: Create Python equivalent for steady-state finding
3. **Implement linmod function**: Create linearization tools
4. **Validate simulations**: Compare results with original MATLAB/Simulink
5. **Add plotting**: Complete the visualization in main scripts
6. **Create examples**: Build example notebooks demonstrating usage

## File Naming Convention

- All Python files use lowercase names (e.g., m1.py, s1.py, set1.py)
- Original MATLAB uppercase extensions (.M) preserved in this document for clarity
- Python convention: lowercase with underscores for multi-word names

## Dependencies

Install required packages:
```bash
pip install numpy scipy matplotlib
```

## Notes

- The conversion preserves the original logic and mathematical formulations
- Comments from original MATLAB code are preserved where applicable
- Some MATLAB-specific features (like `keyboard` command) are replaced with Python equivalents (`input()`)
- Error handling and input validation can be enhanced as needed

## Author Notes

These conversions are based on MATLAB code for synchronous machine analysis from Chapter 7 of what appears to be a power systems or electric machines textbook. The models implement:

- Synchronous machine d-q axis models
- Permanent magnet motor models
- Coupled rotor circuit models
- Small-signal linearization analysis
- Transient stability analysis

The stub implementations provide the foundation for Python-based simulation but may require refinement based on specific use cases and validation against known results.
