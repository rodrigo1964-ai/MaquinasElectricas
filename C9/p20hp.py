"""
Parameters of 20 hp, three-phase induction machine
"""
import numpy as np

# Machine ratings
Sb = 20 * 746  # rating in VA
Vrated = 220  # rated line-to-line voltage in V
pf = 0.853  # rated power factor
Irated = Sb / (np.sqrt(3) * Vrated * pf)  # rated rms current
P = 4  # number of poles
frated = 60  # rated frequency in Hz

# Base quantities
wb = 2 * np.pi * frated  # base electrical frequency
we = wb
wbm = 2 * wb / P  # base mechanical frequency
Tb = Sb / wbm  # base torque
Zb = Vrated * Vrated / Sb  # base impedance in ohms
Vm = Vrated * np.sqrt(2/3)  # magnitude of phase voltage
Vb = Vm
Tfactor = (3 * P) / (4 * wb)  # factor for torque expression

# Operating point
srated = 0.0287  # rated slip
Nrated = 1748.3  # rated speed in rev/min
wmrated = 2 * np.pi * Nrated / 60  # rated speed in rad/sec
Trated = Sb / wmrated  # rated torque
iasb = 49.68  # rated rms phase current

# Machine parameters (in ohms at base frequency)
rs = 0.1062  # stator winding resistance in ohms
xls = 0.2145  # stator leakage reactance in ohms
xplr = xls  # rotor leakage reactance in ohms
xm = 5.8339  # stator magnetizing reactance in ohms
rpr = 0.0764  # referred rotor winding resistance in ohms
xM = 1 / (1/xm + 1/xls + 1/xplr)
J = 2.8  # rotor inertia in kg m2
H = J * wbm * wbm / (2 * Sb)  # inertia constant in sec
Domega = 0  # rotor damping coefficient
