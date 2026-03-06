"""
Machine parameter input file SET3A.py

Machine data for 2x3 equivalent circuit model with two
nonzero coupling inductances in the d-axis rotor circuits

Machine data for 2x3 equivalent circuit model from
Canay, I. M., " Determination of the Model Parameters
of Machines from the Reactance Operators xd(p), xq(p)
(Evaluation of Standstill Frequency Response Test),"
IEEE Trans. on energy Conversion, Vol. 8,
No.2 June 1993, pp. 272- 279.
Copyright 1993 IEEE
"""

Frated = 60
Poles = 2
Vrated = 26e3
Srated = 722.222e6
rs = 0.004  # estimate, not from above reference
xls = 0.19
xpd = 0.346
xpq = 0.642

# d-axis circuit parameters
xmd = 1.70
xd = xmd + xls
xpr2c = 0.06523
xpr1c = 0.01925
xp1c = 0.1055
xp2c = 0.03076
xp3c = -0.009134
rpkd3 = 0.02467
rpkd2 = 0.01297
rpf = 0.00112

# q-axis circuit parameters
xmq = 1.61
xq = xmq + xls
xplkq3 = 0.1225
xplkq2 = 0.3248
xplkq1 = 0.6802
rpkq3 = 0.2237
rpkq2 = 0.03537
rpkq1 = 0.005698

H = 3.0  # estimate, not from above reference
Domega = 0  # mechanical damping coeff
