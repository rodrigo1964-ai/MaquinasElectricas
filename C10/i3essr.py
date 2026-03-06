"""
MATLAB to Python conversion of I3ESSR.M
Loads synchronous machine parameters from IEEE First Benchmark Model
for Computer Simulation of Subsynchronous Resonance
IEEE Trans on PAS, Vol. 1, PAS-96, Sept/Oct 1977, pp. 1565-1572.
Copyright 1977 IEEE
"""

import numpy as np

# Parameters given in per unit of machine base
Perunit = 1
Frated = 60
Poles = 2
Pfrated = 0.9
Vrated = 18e3
Prated = 892e6
rs = 0.00
xd = 1.79
xq = 1.71
xls = 0.13
xpd = 0.169
xpq = 0.228
xppd = 0.135
xppq = 0.200
Tpdo = 4.3
Tpqo = 0.85
Tppdo = 0.032
Tppqo = 0.05
Domega = 0  # Nonzero to account for damper winding not represented
H = 2.89
KA = 50
# KA = 200  # high gain value for case 5
TA = 0.06
VRmax = 1
VRmin = -1
TE = 0.052
KE = -0.0465
TF = 1.0
KF = 0.0832
AEx = 0.0012
BEx = 1.264
