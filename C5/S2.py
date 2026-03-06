"""
Space Vector Transformation (abc → αβ → i1, i2)
Converted from s2.mdl to Python

Transforms three-phase currents to:
- Alpha-beta components (stationary reference frame)
- Positive sequence (i1) and negative sequence (i2) components
"""
import numpy as np
import matplotlib.pyplot as plt

def clarke_transform(ia, ib, ic):
    """
    Clarke transformation: abc → αβ0

    [i_alpha]   [1    -1/2      -1/2    ] [ia]
    [i_beta ] = [0  sqrt(3)/2  -sqrt(3)/2] [ib]
    [i_0    ]   [1/2   1/2       1/2    ] [ic]

    Returns: (i_alpha, i_beta, i_0)
    """
    i_alpha = ia - 0.5 * ib - 0.5 * ic
    i_beta = (np.sqrt(3)/2) * (ib - ic)
    i_0 = 0.5 * (ia + ib + ic)

    return i_alpha, i_beta, i_0

def sequence_components(i_alpha, i_beta):
    """
    Separate alpha-beta into positive and negative sequence

    Positive sequence (i1):
    i1_x = (i_alpha + 0) / 2
    i1_y = (i_beta + 0) / 2

    Negative sequence (i2):
    i2_x = (i_alpha - 0) / 2
    i2_y = (-i_beta + 0) / 2

    Returns: (i1_x, i1_y, i2_x, i2_y)
    """
    # For balanced systems, these simplify to:
    i1_x = i_alpha / np.sqrt(2)
    i1_y = i_beta / np.sqrt(2)
    i2_x = i_alpha / np.sqrt(2)
    i2_y = -i_beta / np.sqrt(2)

    return i1_x, i1_y, i2_x, i2_y

def simulate_space_vectors(m=1, alpha=0, n=-1, tstop=0.95):
    """
    Simulate three-phase currents and compute space vectors

    Parameters:
    - m: harmonic order for m component
    - alpha: attenuation factor (0 for constant, >0 for spiral)
    - n: harmonic order for n component (negative to disable)
    - tstop: simulation time

    Phase currents:
    iam = 10*exp(-alpha*t)*cos(m*2*pi*t)
    ibm = 10*exp(-alpha*t)*cos(m*(2*pi*t - 2*pi/3))
    icm = 10*exp(-alpha*t)*cos(m*(2*pi*t + 2*pi/3))
    """
    # Time vector
    t = np.linspace(0, tstop, 1000)
    omega = 2 * np.pi

    # Phase currents with m harmonic component
    iam = 10 * np.exp(-alpha * t) * np.cos(m * omega * t)
    ibm = 10 * np.exp(-alpha * t) * np.cos(m * (omega * t - 2*np.pi/3))
    icm = 10 * np.exp(-alpha * t) * np.cos(m * (omega * t + 2*np.pi/3))

    # Add n harmonic component if n > 0
    if n > 0:
        iam += (10/n) * np.cos(2*n*omega*t)
        ibm += (10/n) * np.cos(2*n*omega*t - 2*n*np.pi/3)
        icm += (10/n) * np.cos(2*n*omega*t + 2*n*np.pi/3)

    # Clarke transformation
    i_alpha, i_beta, i_0 = clarke_transform(iam, ibm, icm)

    # Sequence components
    i1_x, i1_y, i2_x, i2_y = sequence_components(i_alpha, i_beta)

    return t, iam, ibm, icm, i_alpha, i_beta, i1_x, i1_y, i2_x, i2_y

def plot_results(t, iam, ibm, icm, i_alpha, i_beta, i1_x, i1_y, i2_x, i2_y):
    """
    Plot space vector transformation results
    """
    # Time domain plots
    fig1, axes = plt.subplots(3, 1, figsize=(10, 8))

    axes[0].plot(t, iam, label='ia')
    axes[0].plot(t, ibm, label='ib')
    axes[0].plot(t, icm, label='ic')
    axes[0].set_ylabel('Current (A)')
    axes[0].set_title('Three-Phase Currents')
    axes[0].legend()
    axes[0].grid(True)

    axes[1].plot(t, i_alpha, label='i_alpha')
    axes[1].set_ylabel('Current (A)')
    axes[1].set_title('Alpha Component')
    axes[1].grid(True)

    axes[2].plot(t, i_beta, label='i_beta')
    axes[2].set_ylabel('Current (A)')
    axes[2].set_xlabel('Time (sec)')
    axes[2].set_title('Beta Component')
    axes[2].grid(True)

    plt.tight_layout()

    # Space vector plots
    fig2, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 5))

    ax1.plot(i1_x, i1_y, '-', linewidth=1.5)
    ax1.set_xlim([-20, 20])
    ax1.set_ylim([-20, 20])
    ax1.set_aspect('equal')
    ax1.set_xlabel('i1_x')
    ax1.set_ylabel('i1_y')
    ax1.set_title('Positive Sequence i1 Locus')
    ax1.grid(True)

    ax2.plot(i2_x, i2_y, '-', linewidth=1.5)
    ax2.set_xlim([-20, 20])
    ax2.set_ylim([-20, 20])
    ax2.set_aspect('equal')
    ax2.set_xlabel('i2_x')
    ax2.set_ylabel('i2_y')
    ax2.set_title('Negative Sequence i2 Locus')
    ax2.grid(True)

    plt.tight_layout()
    plt.show()

def interactive_mode():
    """
    Interactive mode for exploring different harmonic combinations
    """
    repeat_run = 'Y'

    while repeat_run.upper() == 'Y':
        print('\n' + '='*60)
        print('Space Vector Transformation')
        print('='*60)
        print('\nPhase currents:')
        print('iam = 10*exp(-alpha*t)*cos(m*2*pi*t)')
        print('ibm = 10*exp(-alpha*t)*cos(m*(2*pi*t - 2*pi/3))')
        print('icm = 10*exp(-alpha*t)*cos(m*(2*pi*t + 2*pi/3))')

        m = float(input('\nEnter value of m > '))

        print('\nEnter attenuation factor for m component')
        print('  For constant amplitude, enter 0')
        print('  For spiral effect, use 0.2')
        alpha = float(input('Enter attenuation factor alpha > '))

        print('\nNext enter the harmonic number n')
        print('  Enter any negative number if you do not want that component')
        print('\nian = (10/n)*cos(2*n*pi*t)')
        print('ibn = (10/n)*cos(2*n*pi*t - 2*n*pi/3)')
        print('icn = (10/n)*cos(2*n*pi*t + 2*n*pi/3)')
        n = float(input('Enter value of n > '))

        # Run simulation
        t, iam, ibm, icm, i_alpha, i_beta, i1_x, i1_y, i2_x, i2_y = \
            simulate_space_vectors(m, alpha, n)

        # Plot results
        plot_results(t, iam, ibm, icm, i_alpha, i_beta, i1_x, i1_y, i2_x, i2_y)

        repeat_run = input('\nRepeat with new system condition? Y/N: ')
        if not repeat_run:
            repeat_run = 'N'

    plt.close('all')

if __name__ == "__main__":
    print("Space Vector Transformation (abc → αβ → i1, i2)")
    print("\nRunning example with m=1, alpha=0, n=-1...")

    # Example run
    t, iam, ibm, icm, i_alpha, i_beta, i1_x, i1_y, i2_x, i2_y = \
        simulate_space_vectors(m=1, alpha=0, n=-1, tstop=0.95)

    plot_results(t, iam, ibm, icm, i_alpha, i_beta, i1_x, i1_y, i2_x, i2_y)

    # Uncomment to run interactive mode:
    # interactive_mode()
