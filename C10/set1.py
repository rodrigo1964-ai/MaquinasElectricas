"""
Parameters of synchronous generator set 1
"""

import numpy as np

# Parameters given in per unit of machine base
Perunit = 1
Frated = 60
Poles = 4
Pfrated = 0.9
Vrated = 18e3
Prated = 828315e3
rs = 0.0048
xd = 1.790
xq = 1.660
xls = 0.215
xpd = 0.355
xpq = 0.570
xppd = 0.275
xppq = 0.275
Tpdo = 7.9
Tpqo = 0.410
Tppdo = 0.032
Tppqo = 0.055
H = 3.77
Domega = 2  # nonzero to account for damper winding not represented
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
