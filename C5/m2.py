"""
M-file for Project 2 on space vectors in Chapter 5.

This script prompts the user for the values of m, n and attenuation
factor used in the SIMULINK file s2.m and plots the results of the simulation.

Converted from MATLAB to Python.
"""

import numpy as np
import matplotlib.pyplot as plt

def main():
    """
    Main function for space vector analysis.

    Prompts user for:
    - m: harmonic order for the m component
    - alpha: attenuation factor (0 for constant amplitude, 0.2 for spiral effect)
    - n: harmonic order for the n component (negative to disable)

    Phase currents:
    iam = 10*cos(m*(2*pi*t))
    ibm = 10*cos(m*(2*pi*t - 2*pi/3))
    icm = 10*cos(m*(2*pi*t - 4*pi/3))

    ian = (10/n)*cos(2*n*pi*t)
    ibn = (10/n)*cos(2*n*pi*t - 2*n*pi/3)
    icn = (10/n)*cos(2*n*pi*t - 4*n*pi/3)
    """

    repeat_run = 'Y'

    while repeat_run.upper() == 'Y':
        print('iam = 10*cos(m*(2*pi*t))')
        print('ibm = 10*cos(m*(2*pi*t - 2*pi/3))')
        print('icm = 10*cos(m*(2*pi*t - 4*pi/3))')
        m = float(input('Enter value of m  > '))

        print('Enter attenuation factor for m component')
        print('For constant amplitude, enter zero for alpha')
        print('For spiral effect, use an alpha of 0.2')
        alpha = float(input('Enter attenuation factor, alpha > '))
        print('')

        print('Next enter the harmonic number n after the prompt')
        print('Enter any negative number for n if')
        print('     you do not want that component')
        print('')
        print('ian = (10/n)*cos(2*n*pi*t)')
        print('ibn = (10/n)*cos(2*n*pi*t - 2*n*pi/3)')
        print('icn = (10/n)*cos(2*n*pi*t - 4*n*pi/3)')
        n = float(input('Enter value of harmonic order n  > '))

        # Set simulation time to 0.95 of basic period when m=1 and n<0
        tstop = 0.95

        print('\nNOTE: This is a Python conversion of the MATLAB script.')
        print('The original MATLAB version runs a Simulink model (s2.m).')
        print('This Python version requires manual implementation of the')
        print('simulation logic to compute the space vectors and sequences.')
        print('\nTo fully implement this, you would need to:')
        print('1. Simulate the three-phase currents with harmonics m and n')
        print('2. Apply Clarke transformation to get alpha-beta components')
        print('3. Separate into positive and negative sequence components')
        print('4. Plot the locus of i1 (positive sequence) and i2 (negative sequence)')

        # Example simulation (simplified placeholder)
        t = np.linspace(0, tstop, 1000)

        # Phase currents with m harmonic component
        iam = 10 * np.exp(-alpha * t) * np.cos(m * 2 * np.pi * t)
        ibm = 10 * np.exp(-alpha * t) * np.cos(m * (2 * np.pi * t - 2 * np.pi / 3))
        icm = 10 * np.exp(-alpha * t) * np.cos(m * (2 * np.pi * t + 2 * np.pi / 3))

        # Add n harmonic component if n > 0
        if n > 0:
            iam += (10 / n) * np.cos(2 * n * np.pi * t)
            ibm += (10 / n) * np.cos(2 * n * np.pi * t - 2 * n * np.pi / 3)
            icm += (10 / n) * np.cos(2 * n * np.pi * t + 2 * n * np.pi / 3)

        # Clarke transformation: abc to alpha-beta (simplified)
        # This is a placeholder - full implementation would match Simulink model
        i_alpha = iam
        i_beta = (2 * ibm + icm) / np.sqrt(3)

        # Positive sequence (i1) and negative sequence (i2) separation
        # This is simplified - actual implementation depends on the Simulink model
        i1_x = i_alpha * 0.5
        i1_y = i_beta * 0.5
        i2_x = i_alpha * 0.5
        i2_y = -i_beta * 0.5

        # Plot results
        fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 5))

        ax1.plot(i1_x, i1_y, '-')
        ax1.set_xlim([-20, 20])
        ax1.set_ylim([-20, 20])
        ax1.set_aspect('equal')
        ax1.set_title('Positive sequence i_1 locus')
        ax1.grid(True)

        ax2.plot(i2_x, i2_y, '-')
        ax2.set_xlim([-20, 20])
        ax2.set_ylim([-20, 20])
        ax2.set_aspect('equal')
        ax2.set_title('Negative sequence i_2 locus')
        ax2.grid(True)

        plt.tight_layout()
        plt.show()

        # Prompt for repeat
        repeat_run = input('Repeat with new system condition? Y/N: ')
        if not repeat_run:
            repeat_run = 'N'

    plt.close('all')


if __name__ == '__main__':
    main()
