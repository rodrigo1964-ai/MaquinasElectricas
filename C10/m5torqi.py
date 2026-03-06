"""
Function file to be used in conjunction with m5.py
of Project 5 on permanent magnet drive in Chapter 10.
"""

import numpy as np


def m5torqi(sing, Tem, Em, Ia, xd, xq):
    """
    To obtain underexcited motoring and generating conditions
    Set Iq = abs(Ia)*cos(gamma); Id = Ia*sin(gamma)

    Parameters:
    -----------
    sing : float
        sin(gamma)
    Tem : float
        Electromagnetic torque
    Em : float
        Magnet excitation voltage
    Ia : float
        Armature current amplitude
    xd : float
        d-axis reactance
    xq : float
        q-axis reactance

    Returns:
    --------
    f : float
        Objective function value
    """
    f = Tem - Em * abs(Ia) * np.sqrt(1 - sing**2) - \
        Ia * abs(Ia) * (xd - xq) * sing * np.sqrt(1 - sing**2)
    return f
