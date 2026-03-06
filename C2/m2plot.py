"""
Python conversion of M2PLOT.M
Plotting functionality for M2 simulation
"""
import matplotlib.pyplot as plt

def m2plot(y):
    """
    Plot results from M2 simulation
    """
    # This is likely similar to m2.py plot_results
    # Import and use the function from m2
    from m2 import plot_results
    plot_results(y)
