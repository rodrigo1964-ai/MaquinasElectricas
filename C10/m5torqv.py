"""
Function file to be used in conjunction with m5.py
of Project 5 on permanent magnet drive in Chapter 10.
"""

import numpy as np


def m5torqv(sind, Temo, Em, Va, xd, xq):
    """
    Torque-voltage relationship function

    Parameters:
    -----------
    sind : float
        sin(delta)
    Temo : float
        Electromagnetic torque
    Em : float
        Magnet excitation voltage
    Va : float
        Armature voltage amplitude
    xd : float
        d-axis reactance
    xq : float
        q-axis reactance

    Returns:
    --------
    y : float
        Objective function value
    """
    y = Temo + (Em * Va / xd) * sind + \
        Va * Va * (1 / xq - 1 / xd) * sind * np.sqrt(1 - sind**2)
    return y
