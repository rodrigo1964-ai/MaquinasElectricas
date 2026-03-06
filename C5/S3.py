"""
qd0 Reference Frame Transformations
Converted from s3.mdl to Python

Transforms three-phase currents through:
1. abc → qd0s (stationary reference frame)
2. qd0s → qd0e (arbitrary rotating reference frame)
"""
import numpy as np
import matplotlib.pyplot as plt

def abc_to_qd0s(ia, ib, ic):
    """
    Transform abc to qd0 in stationary reference frame

    Park's transformation (stationary frame):
    [iqs]   [2/3  -1/3  -1/3] [ia]
    [ids] = [0     1/√3 -1/√3] [ib]
    [i0s]   [1/3   1/3   1/3] [ic]

    Returns: (iqs, ids, i0s)
    """
    iqs = (2*ia - ib - ic) / 3
    ids = (ib - ic) / np.sqrt(3)
    i0s = (ia + ib + ic) / 3

    return iqs, ids, i0s

def qd0s_to_qd0e(iqs, ids, theta):
    """
    Transform qd0 from stationary to arbitrary rotating frame

    Rotation transformation:
    [iqe]   [cos(θ)  -sin(θ)] [iqs]
    [ide] = [sin(θ)   cos(θ)] [ids]

    theta: angle of the rotating reference frame

    Returns: (iqe, ide)
    """
    iqe = iqs * np.cos(theta) - ids * np.sin(theta)
    ide = iqs * np.sin(theta) + ids * np.cos(theta)

    return iqe, ide

def simulate_qd0_transform(m=1, alpha=1, nframe=1, theta0=0, tstop=3):
    """
    Simulate three-phase currents and apply qd0 transformations

    Parameters:
    - m: harmonic order of abc currents
    - alpha: attenuation factor
    - nframe: speed factor of qd0 frame (relative to synchronous speed)
    - theta0: initial angle theta(0)
    - tstop: simulation time

    Phase currents:
    ias = 10*exp(-alpha*t)*cos(m*omega*t)
    ibs = 10*exp(-alpha*t)*cos(m*(omega*t - 2*pi/3))
    ics = 10*exp(-alpha*t)*cos(m*(omega*t + 2*pi/3))
    """
    # Time vector
    t = np.linspace(0, tstop, 3000)
    omega = 2 * np.pi  # Fundamental frequency (rad/sec)

    # Three-phase currents with harmonic m
    ias = 10 * np.exp(-alpha * t) * np.cos(m * omega * t)
    ibs = 10 * np.exp(-alpha * t) * np.cos(m * (omega * t - 2*np.pi/3))
    ics = 10 * np.exp(-alpha * t) * np.cos(m * (omega * t + 2*np.pi/3))

    # Transform to stationary qd0 frame
    iqs, ids, i0s = abc_to_qd0s(ias, ibs, ics)

    # Angle for arbitrary rotating reference frame
    theta = nframe * omega * t + theta0

    # Transform to arbitrary rotating frame
    iqe, ide = qd0s_to_qd0e(iqs, ids, theta)

    return t, ias, ibs, ics, iqs, ids, i0s, iqe, ide

def plot_results(t, ias, ibs, ics, iqs, ids, i0s, iqe, ide, nframe):
    """
    Plot qd0 transformation results
    """
    # Figure 1: Stationary reference frame
    fig1, axes1 = plt.subplots(3, 1, figsize=(10, 8))

    axes1[0].plot(t, ias, '-')
    axes1[0].set_ylabel('ias (A)')
    axes1[0].set_ylim([-20, 20])
    axes1[0].set_title('Phase a Current')
    axes1[0].grid(True)

    axes1[1].plot(t, iqs, '-')
    axes1[1].set_ylabel('iqs (A)')
    axes1[1].set_ylim([-20, 20])
    axes1[1].set_title('q-axis Current (Stationary Frame)')
    axes1[1].grid(True)

    axes1[2].plot(t, ids, '-')
    axes1[2].set_ylabel('ids (A)')
    axes1[2].set_xlabel('Time (sec)')
    axes1[2].set_ylim([-20, 20])
    axes1[2].set_title('d-axis Current (Stationary Frame)')
    axes1[2].grid(True)

    plt.tight_layout()

    # Figure 2: Arbitrary rotating reference frame
    fig2, axes2 = plt.subplots(3, 1, figsize=(10, 8))

    axes2[0].plot(t, i0s, '-')
    axes2[0].set_ylabel('i0s (A)')
    axes2[0].set_ylim([-20, 20])
    axes2[0].set_title('Zero Sequence Current')
    axes2[0].grid(True)

    axes2[1].plot(t, iqe, '-')
    axes2[1].set_ylabel('iqe (A)')
    axes2[1].set_ylim([-20, 20])
    axes2[1].set_title(f'q-axis Current (Rotating Frame, nframe={nframe})')
    axes2[1].grid(True)

    axes2[2].plot(t, ide, '-')
    axes2[2].set_ylabel('ide (A)')
    axes2[2].set_xlabel('Time (sec)')
    axes2[2].set_ylim([-20, 20])
    axes2[2].set_title(f'd-axis Current (Rotating Frame, nframe={nframe})')
    axes2[2].grid(True)

    plt.tight_layout()
    plt.show()

def interactive_mode():
    """
    Interactive mode for exploring different reference frames
    """
    repeat_run = 'Y'

    while repeat_run.upper() == 'Y':
        print('\n' + '='*60)
        print('qd0 Reference Frame Transformations')
        print('='*60)

        m = float(input('\nEnter the value of m for abc currents > '))
        alpha = float(input('Enter attenuation factor alpha, try 1 > '))

        print('\nnframe is the speed factor of qd0 frame')
        print('  with respect to the synchronous speed')
        print('  of the fundamental abc currents')
        nframe = float(input('Enter the value of nframe > '))

        print('\ntheta0 is the initial value theta(0)')
        theta0 = float(input('Enter value of theta0 > '))

        # Run simulation
        t, ias, ibs, ics, iqs, ids, i0s, iqe, ide = \
            simulate_qd0_transform(m, alpha, nframe, theta0)

        # Plot results
        plot_results(t, ias, ibs, ics, iqs, ids, i0s, iqe, ide, nframe)

        print('\nSave plots in Figs 1 and 2 before continuing')

        repeat_run = input('\nRepeat with new system condition? Y/N: ')
        if not repeat_run:
            repeat_run = 'N'

    plt.close('all')

if __name__ == "__main__":
    print("qd0 Reference Frame Transformations")
    print("\nRunning example with m=1, alpha=1, nframe=1, theta0=0...")

    # Example run
    t, ias, ibs, ics, iqs, ids, i0s, iqe, ide = \
        simulate_qd0_transform(m=1, alpha=1, nframe=1, theta0=0)

    plot_results(t, ias, ibs, ics, iqs, ids, i0s, iqe, ide, nframe=1)

    # Uncomment to run interactive mode:
    # interactive_mode()
