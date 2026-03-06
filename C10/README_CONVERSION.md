# MATLAB to Python Conversion - Chapter 10

This directory contains Python conversions of MATLAB files for Chapter 10 machine analysis projects.

## Conversion Summary

### Parameter Files (Fully Converted)
- `i3essr.py` - IEEE SSR benchmark model parameters
- `set1.py` - Synchronous generator set 1 parameters
- `set2.py` - Synchronous generator set 2 parameters

### Helper Functions (Fully Converted)
- `m5torqi.py` - Torque-current optimization function for PM motor
- `m5torqv.py` - Torque-voltage optimization function for PM motor

### Main Analysis Scripts (Functional Python Implementations)

#### Project 1: Transient Model
- `m1.py` - Synchronous machine transient model analysis
  - Loads machine parameters
  - Calculates steady-state operating points
  - Prepares for eigenvalue and transfer function analysis
  - **Note**: Simulink `trim` and `linmod` functions require manual implementation

#### Project 2: Multi-Machine Systems
- `m2.py` - Two-generator system analysis
  - Sets up multi-machine parameters
  - Calculates network Y-bus
  - Prepares operating conditions for both generators
  - Sets up fault and torque disturbance scenarios
  - **Note**: Eigenvalue analysis requires scipy.linalg equivalents

#### Project 3: Subsynchronous Resonance
- `m3.py` - SSR with series capacitor compensation
  - Torsional modal analysis (6-mass system)
  - Network parameter setup
  - Eigenvalue and eigenvector calculations
  - Mode shape plotting
  - **Fully functional** for modal analysis

- `m3g.py` - SSR with fixed terminal voltage
  - Similar to m3.py but different network configuration
  - **Fully functional** for modal analysis

#### Project 4: Power System Stabilizer
- `m4.py` - PSS transfer function design
  - Steady-state calculations
  - Transfer function derivation (Exc(s), GEP(s))
  - Bode plot generation
  - Nonlinear gain calculations (K1-K6)
  - **Fully functional** for transfer function analysis

- `m4comp.py` - PSS design verification
  - PSS transfer function Bode plots
  - Root locus capabilities (partial)
  - **Fully functional** for frequency response

#### Project 5: Permanent Magnet Motor Drive
- `m5.py` - PM motor steady-state and control
  - Steady-state torque-speed characteristics
  - Optimal torque/ampere operation
  - Curve fitting for control lookup tables
  - Multiple steady-state plots
  - **Fully functional** for steady-state analysis

### Simulink Model Stubs (Information Only)
These files are stubs indicating the Simulink models that require manual implementation:
- `s1eig.py`, `s1.py` - Single machine models
- `s2eig.py`, `s2.py` - Multi-machine models
- `s3eig.py`, `s3.py`, `s3geig.py`, `s3g.py` - SSR models
- `s4.py` - PSS model
- `s5.py` - PM motor drive model

**Note**: Simulink block diagrams would need to be implemented using:
- `scipy.integrate.solve_ivp` for ODE integration
- Custom state-space implementations
- Or control system libraries like `python-control`

## Key Differences from MATLAB

### 1. Numerical Libraries
- MATLAB arrays → NumPy arrays
- MATLAB complex numbers → Python complex (1j)
- MATLAB functions → scipy.signal, scipy.linalg

### 2. Indexing
- MATLAB 1-based → Python 0-based indexing
- Adjusted all array accesses accordingly

### 3. Plotting
- MATLAB figures → matplotlib.pyplot
- Interactive plots saved as PNG files

### 4. Control System Functions
- `tf2zpk` → `scipy.signal.tf2zpk`
- `bode` → `scipy.signal.bode`
- `eig` → `scipy.linalg.eig`
- `polyfit` → `numpy.polyfit`

### 5. Optimization
- `fmin` → `scipy.optimize.fminbound`

## Usage Examples

### Example 1: Run steady-state PM motor analysis
```python
python m5.py
```
This will generate:
- `m5_steady_state_1.png` - Torque-angle curves and voltage/current vs torque
- `m5_steady_state_2.png` - QD voltages, currents, angles, and P-Q curve

### Example 2: Analyze torsional modes
```python
python m3.py
```
This will display:
- Modal frequencies and damping
- Mode shape matrix
- Save mode shape plots

### Example 3: PSS design
```python
# First run m4.py to get transfer functions
python m4.py

# Then run m4comp.py for PSS analysis
python m4comp.py
```

### Example 4: Multi-machine system setup
```python
python m2.py
```

## Required Python Packages

```bash
pip install numpy scipy matplotlib
```

## Limitations and Future Work

### Simulink Conversion
The Simulink models (S*.M files) are provided as information stubs. Full implementation would require:
1. Translating block diagrams to differential equations
2. Implementing using scipy.integrate
3. Creating visualization for time-domain responses

### Missing Features
- Interactive root locus plotting (partial in m4comp.py)
- Simulink `trim` and `linmod` automatic linearization
- Interactive keyboard mode (replaced with print statements)

### Recommended Next Steps
1. Implement key Simulink models using scipy.integrate.solve_ivp
2. Add interactive plotting with matplotlib widgets
3. Create control system analysis using python-control package
4. Add GUI for parameter input (e.g., with tkinter or PyQt)

## File Naming Convention
All Python files use lowercase names (MATLAB .M → Python .py):
- `M1.M` → `m1.py`
- `SET1.M` → `set1.py`
- `S1EIG.M` → `s1eig.py` (stub)

## Testing
Each main script can be run standalone:
```bash
python m1.py
python m2.py
python m3.py
python m3g.py
python m4.py
python m4comp.py
python m5.py
```

Parameter files can be imported:
```python
from set1 import *
from i3essr import *
```

## References
- IEEE First Benchmark Model for SSR (1977)
- Bose, B.K. (1988) - PM motor drive reference

## Support
For questions about the conversion or to report issues, refer to the original MATLAB files in the same directory.
