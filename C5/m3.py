"""
MATLAB script file for Project 3 on the transformation of
sinusoidal and complex quantities in the qd0 reference frames in Chapter 5.

This script prompts the user for the harmonic order m of the phase
currents, nframe and theta(0) of the reference frame to set up the
SIMULINK file s3.m and plots the results of the simulation.

Converted from MATLAB to Python.
"""

import numpy as np
import matplotlib.pyplot as plt

def main():
    """
    Main function for qd0 reference frame transformations.

    Prompts user for:
    - m: harmonic order of abc currents
    - alpha: attenuation factor
    - nframe: speed factor of qd0 frame with respect to synchronous speed
    - theta0: initial value theta(0)

    The simulation transforms three-phase currents to:
    - Stationary reference frame (qd0s)
    - Arbitrary reference frame (qd0e)
    """

    repeat_run = 'Y'

    while repeat_run.upper() == 'Y':
        m = float(input('Enter the value of m for abc currents  > '))
        alpha = float(input('Enter attenuation factor alpha, try 1,  > '))

        print('nframe is the speed factor of qd0 frame')
        print('  with respect to the sychronous speed of')
        print('  the fundamental abc currents')
        nframe = float(input('Enter the value of nframe of the qd0 frame  > '))

        print('theta0 is the initial value theta(0)')
        theta0 = float(input('Enter value of theta0 > '))

        print('\nNOTE: This is a Python conversion of the MATLAB script.')
        print('The original MATLAB version runs a Simulink model (s3.m).')
        print('This Python version requires manual implementation of the')
        print('simulation logic to compute the reference frame transformations.')
        print('\nTo fully implement this, you would need to:')
        print('1. Simulate the three-phase currents with harmonic m')
        print('2. Apply abc to qd0 transformation (stationary frame)')
        print('3. Apply qd0s to qd0e transformation (arbitrary frame)')
        print('4. Plot time-domain waveforms of all components')

        # Example simulation (simplified placeholder)
        t = np.linspace(0, 3, 3000)
        omega = 2 * np.pi  # fundamental frequency

        # Three-phase currents
        ias = 10 * np.exp(-alpha * t) * np.cos(m * omega * t)
        ibs = 10 * np.exp(-alpha * t) * np.cos(m * (omega * t - 2 * np.pi / 3))
        ics = 10 * np.exp(-alpha * t) * np.cos(m * (omega * t + 2 * np.pi / 3))

        # abc to qd0 transformation (stationary frame)
        iqs = (2 * ias - ibs - ics) / 3
        ids = (-ibs + ics) / np.sqrt(3)
        i0s = (ias + ibs + ics) / 3

        # Angle for arbitrary reference frame
        theta = nframe * omega * t + theta0

        # qd0s to qd0e transformation (arbitrary reference frame)
        iqe = iqs * np.cos(theta) - ids * np.sin(theta)
        ide = iqs * np.sin(theta) + ids * np.cos(theta)

        # Create first figure - stationary frame
        fig1, (ax1, ax2, ax3) = plt.subplots(3, 1, figsize=(10, 8))

        ax1.plot(t, ias, '-')
        ax1.set_ylabel('ias in A')
        ax1.set_ylim([-20, 20])
        ax1.grid(True)

        ax2.plot(t, iqs, '-')
        ax2.set_ylabel('iqs in A')
        ax2.set_ylim([-20, 20])
        ax2.grid(True)

        ax3.plot(t, ids, '-')
        ax3.set_ylabel('ids in A')
        ax3.set_ylim([-20, 20])
        ax3.grid(True)

        plt.tight_layout()

        # Create second figure - arbitrary frame
        fig2, (ax4, ax5, ax6) = plt.subplots(3, 1, figsize=(10, 8))

        ax4.plot(t, i0s, '-')
        ax4.set_ylabel('i0s in A')
        ax4.set_ylim([-20, 20])
        ax4.grid(True)

        ax5.plot(t, iqe, '-')
        ax5.set_ylabel('iqe in A')
        ax5.set_ylim([-20, 20])
        ax5.grid(True)

        ax6.plot(t, ide, '-')
        ax6.set_ylabel('ide in A')
        ax6.set_xlabel('Time in sec')
        ax6.set_ylim([-20, 20])
        ax6.grid(True)

        plt.tight_layout()

        print('\nSave plots in Figs 1 and 2 before continuing')
        plt.show()

        # Prompt for repeat
        repeat_run = input('Repeat with new system condition? Y/N: ')
        if not repeat_run:
            repeat_run = 'N'

    plt.close('all')


if __name__ == '__main__':
    main()
